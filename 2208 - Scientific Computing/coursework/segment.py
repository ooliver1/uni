from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np
from PIL import Image


def _neighbourhood_sum(mask: np.ndarray) -> np.ndarray:
    """3x3 sum over a binary mask using shifted views."""

    padded = np.pad(mask.astype(np.uint8), ((1, 1), (1, 1)), mode="constant")
    return (
        padded[:-2, :-2]
        + padded[:-2, 1:-1]
        + padded[:-2, 2:]
        + padded[1:-1, :-2]
        + padded[1:-1, 1:-1]
        + padded[1:-1, 2:]
        + padded[2:, :-2]
        + padded[2:, 1:-1]
        + padded[2:, 2:]
    )


def _binary_open_close(mask: np.ndarray) -> np.ndarray:
    """Cleanup binary mask with morphological opening and closing using 3x3 structuring elements."""

    # Erosion: keep only pixels whose 3x3 neighborhood is fully foreground.
    eroded = _neighbourhood_sum(mask) == 9

    # Dilation: keep pixels that have at least one foreground neighbor in the opened mask.
    opened = _neighbourhood_sum(eroded) > 0

    # Repeat dilation to close small holes: keep pixels that have at least one foreground neighbor in the dilated mask.
    dilated = _neighbourhood_sum(opened) > 0

    # Closing: keep pixels that have a full 3x3 neighborhood in the dilated mask.
    closed = _neighbourhood_sum(dilated) == 9
    return closed


def _connected_components(binary: np.ndarray) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Label connected components in a binary mask and compute their sizes and border contact.

    This is a custom implementation of connected component labeling using a depth-first search (DFS) approach.
    It iterates over each pixel in the binary mask, and when it finds an unvisited foreground pixel,
    it performs a DFS to label all connected pixels with the same component ID.

    These labels allow for post-processing steps to filter out small components or those that touch the border.

    Returns:
    - labels: A 2D array of the same shape as the input binary mask,
        where each foreground pixel is labeled with its component ID (0, 1, 2, ...), and background pixels are -1.
    - sizes: A 1D array where sizes[i] is the number of pixels in component i.
    - touches_border: A 1D boolean array where touches_border[i] is True if
        component i touches the image border, and False otherwise.
    """

    h, w = binary.shape
    labels = np.full((h, w), -1, dtype=np.int32)
    sizes: list[int] = []
    touches_border: list[bool] = []

    neighbors = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
    label_id = 0

    for y in range(h):
        for x in range(w):
            if not binary[y, x] or labels[y, x] != -1:
                continue

            stack = [(y, x)]
            labels[y, x] = label_id
            size = 0
            touch = False

            # Perform DFS to label all connected pixels in this component.
            while stack:
                cy, cx = stack.pop()
                size += 1
                if cy == 0 or cy == h - 1 or cx == 0 or cx == w - 1:
                    touch = True

                for dy, dx in neighbors:
                    ny, nx = cy + dy, cx + dx
                    if 0 <= ny < h and 0 <= nx < w and binary[ny, nx] and labels[ny, nx] == -1:
                        labels[ny, nx] = label_id
                        stack.append((ny, nx))

            sizes.append(size)
            touches_border.append(touch)
            label_id += 1

    if len(sizes) == 0:
        return labels, np.zeros(0, dtype=np.int32), np.zeros(0, dtype=bool)

    return labels, np.array(sizes, dtype=np.int32), np.array(touches_border, dtype=bool)


def _remove_small_foreground_components(mask: np.ndarray, min_area_ratio: float = 0.0015) -> np.ndarray:
    """Suppress tiny foreground blobs to reduce noise misclassification."""

    labels, sizes, _ = _connected_components(mask)
    if sizes.size == 0:
        return mask

    min_area = max(16, int(min_area_ratio * mask.size))
    keep_labels = np.flatnonzero(sizes >= min_area)
    if keep_labels.size == 0:
        largest = int(np.argmax(sizes))
        return labels == largest

    keep = np.isin(labels, keep_labels)
    return keep


def _fill_background_holes(mask: np.ndarray) -> np.ndarray:
    """Fill enclosed background islands (holes) inside foreground.

    Any background component not touching the image border is treated as an
    internal hole and filled. This helps preserve large bright wall regions
    inside darker structural outlines (e.g., buildings with timber framing).
    """

    bg = ~mask
    labels, sizes, touches = _connected_components(bg)
    if sizes.size == 0:
        return mask

    fill_labels = np.flatnonzero(~touches)
    if fill_labels.size == 0:
        return mask

    filled = mask.copy()
    filled[np.isin(labels, fill_labels)] = True
    return filled


def _choose_foreground_polarity(base_mask: np.ndarray) -> np.ndarray:
    """Pick mask polarity using simple object-on-background heuristics.

    We score two candidates:
    - candidate A: pixels >= threshold
    - candidate B: inverse of A

    Heuristic assumptions (target case): main object is not mostly on the border
    and usually occupies a moderate image area.
    """

    def score(mask: np.ndarray) -> float:
        area_ratio = float(mask.mean())

        border = np.concatenate(
            [
                mask[0, :],
                mask[-1, :],
                mask[:, 0],
                mask[:, -1],
            ]
        )
        border_ratio = float(border.mean())

        area_penalty = 0.0
        if area_ratio < 0.01:
            area_penalty += 2.0
        elif area_ratio > 0.85:
            area_penalty += 2.0
        elif area_ratio > 0.65:
            area_penalty += 0.6

        return area_penalty + 1.2 * border_ratio

    a = base_mask
    b = ~base_mask
    return a if score(a) <= score(b) else b


def _kmeans_two_clusters(features: np.ndarray, max_iters: int = 30) -> np.ndarray:
    """Return 0/1 labels from deterministic 2-cluster k-means."""

    if features.shape[0] < 2:
        return np.zeros(features.shape[0], dtype=np.uint8)

    # Deterministic init from low/high luminance-ish percentiles.
    basis = features[:, 3]
    idx_lo = int(np.argmin(np.abs(basis - np.percentile(basis, 20))))
    idx_hi = int(np.argmin(np.abs(basis - np.percentile(basis, 80))))
    centroids = np.stack([features[idx_lo], features[idx_hi]], axis=0).astype(np.float64)

    labels = np.zeros(features.shape[0], dtype=np.uint8)
    for _ in range(max_iters):
        d0 = np.sum((features - centroids[0]) ** 2, axis=1)
        d1 = np.sum((features - centroids[1]) ** 2, axis=1)
        new_labels = (d1 < d0).astype(np.uint8)

        if np.array_equal(new_labels, labels):
            break
        labels = new_labels

        for cluster_id in (0, 1):
            members = features[labels == cluster_id]
            if len(members) > 0:
                centroids[cluster_id] = members.mean(axis=0)
            else:
                centroids[cluster_id] = features[np.random.randint(0, features.shape[0])]

    return labels


def segment_foreground_mask(rgb_image: np.ndarray) -> np.ndarray:
    """Return a binary foreground mask (True=foreground, False=background).

    Method rationale:
    - I use 2-cluster k-means on color + weak spatial features, then small fixes.
    - Compared to a single global threshold, this is more robust to lighting and
      contrast variation because clustering uses multi-channel information.

    Brief comparison with an alternative:
    - Alternative: Otsu/global thresholding is very fast and simple but often fails
      when foreground/background intensities overlap.
    - Chosen method is better for typical natural/object images, but may still
      struggle on heavy camouflage or scenes with multiple similar objects.
    """
    rgb = rgb_image.astype(np.float64)
    if rgb.ndim != 3 or rgb.shape[2] < 3:
        raise ValueError("Expected an RGB image array with shape (H, W, 3)")

    # Feature set: chromaticity + luminance + weak spatial cues.
    # Chromaticity improves robustness to lighting-scale changes versus raw RGB.
    rgb01 = rgb / 255.0
    gray = 0.299 * rgb01[..., 0] + 0.587 * rgb01[..., 1] + 0.114 * rgb01[..., 2]
    rgb_sum = np.maximum(rgb01.sum(axis=2), 1e-6)
    r_norm = rgb01[..., 0] / rgb_sum
    g_norm = rgb01[..., 1] / rgb_sum
    b_norm = rgb01[..., 2] / rgb_sum

    h, w = gray.shape
    y_grid, x_grid = np.indices((h, w), dtype=np.float64)
    x_norm = x_grid / max(w - 1, 1)
    y_norm = y_grid / max(h - 1, 1)

    features = np.stack(
        [
            r_norm,
            g_norm,
            b_norm,
            1.0 * gray,
            0.15 * x_norm,
            0.15 * y_norm,
        ],
        axis=-1,
    ).reshape(-1, 6)

    # Fit on subset for speed on large images, then classify full image.
    n_pixels = features.shape[0]
    if n_pixels > 120_000:
        step = int(np.ceil(n_pixels / 120_000))
        fit_features = features[::step]
    else:
        fit_features = features

    fit_labels = _kmeans_two_clusters(fit_features)
    if np.all(fit_labels == 0) or np.all(fit_labels == 1):
        threshold = float(np.median(features[:, 3]))
        mask = (features[:, 3] >= threshold).reshape(h, w)
    else:
        centroid0 = fit_features[fit_labels == 0].mean(axis=0)
        centroid1 = fit_features[fit_labels == 1].mean(axis=0)
        d0 = np.sum((features - centroid0) ** 2, axis=1)
        d1 = np.sum((features - centroid1) ** 2, axis=1)
        mask = (d1 < d0).reshape(h, w)

    # Post-processing: fix polarity, remove small blobs, fill holes.
    mask = _choose_foreground_polarity(mask)
    mask = _binary_open_close(mask)
    mask = _remove_small_foreground_components(mask)
    mask = _fill_background_holes(mask)

    return mask


def _load_image_rgb(input_path: Path) -> np.ndarray:
    with Image.open(input_path) as image:
        rgb = image.convert("RGB")
        return np.array(rgb, dtype=np.uint8)


def _save_binary_mask(mask: np.ndarray, output_path: Path) -> None:
    output = (mask.astype(np.uint8) * 255)
    Image.fromarray(output, mode="L").save(output_path)


def _save_visual_overlay(rgb: np.ndarray, mask: np.ndarray, output_path: Path) -> None:
    """Save contour-overlay visual: bright green foreground boundary on original image."""

    foreground = mask.astype(bool)
    neigh = _neighbourhood_sum(foreground)
    boundary = foreground & (neigh < 9)

    visual = rgb.copy()
    visual[boundary] = np.array([0, 255, 0], dtype=np.uint8)
    Image.fromarray(visual, mode="RGB").save(output_path)


def _build_parser() -> argparse.ArgumentParser:
    description = (
        "Segment an input image into foreground/background and save both a binary mask "
        "and a visual evaluation image."
    )

    epilog = (
        "Method summary:\n"
        "  1) Build chromaticity+luminance+spatial features\n"
        "  2) Run 2-cluster k-means segmentation\n"
        "  3) Auto-select foreground polarity\n"
        "  4) Post-processing: fix polarity, remove small blobs, fill holes.\n\n"
        "Best use case:\n"
        "  - Object-vs-background separation in natural images with color/appearance contrast.\n\n"
        "Limitations / critical performance discussion:\n"
        "  - Can fail when object and background share very similar color/texture distributions.\n"
        "  - If multiple similar objects exist, the 2-cluster assumption may split undesirably.\n"
        "  - More advanced alternatives include graph cuts or learned semantic segmentation models."
    )

    parser = argparse.ArgumentParser(
        description=description,
        epilog=epilog,
        formatter_class=argparse.RawTextHelpFormatter,
    )
    parser.add_argument("--in", dest="input_image", required=True, help="Path to input image (PNG/JPG/etc.)")
    parser.add_argument("--out", dest="output_mask", required=True, help="Path to output binary mask image")
    parser.add_argument(
        "--visual",
        dest="output_visual",
        required=True,
        help="Path to visual evaluation image (contour overlay)",
    )
    return parser


def main() -> int:
    parser = _build_parser()
    args = parser.parse_args()

    input_path = Path(args.input_image)
    output_path = Path(args.output_mask)
    visual_path = Path(args.output_visual)

    if not input_path.exists():
        print(f"Error: input file not found: {input_path}", file=sys.stderr)
        return 1

    try:
        rgb = _load_image_rgb(input_path)
        mask = segment_foreground_mask(rgb)
    except Exception as exc:
        print(f"Error: failed to segment image '{input_path}': {exc}", file=sys.stderr)
        return 1

    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        visual_path.parent.mkdir(parents=True, exist_ok=True)
        _save_binary_mask(mask, output_path)
        _save_visual_overlay(rgb, mask, visual_path)
    except Exception as exc:
        print(f"Error: failed to write output image(s): {exc}", file=sys.stderr)
        return 1

    print(f"Saved mask: {output_path}")
    print(f"Saved visual: {visual_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
