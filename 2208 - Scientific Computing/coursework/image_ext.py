from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np
from PIL import Image


def _sobel_magnitude(gray01: np.ndarray) -> np.ndarray:
    """Compute Sobel gradient magnitude on a grayscale image in [0, 1]."""

    padded = np.pad(gray01, ((1, 1), (1, 1)), mode="reflect")

    p00 = padded[:-2, :-2]
    p01 = padded[:-2, 1:-1]
    p02 = padded[:-2, 2:]
    p10 = padded[1:-1, :-2]
    p12 = padded[1:-1, 2:]
    p20 = padded[2:, :-2]
    p21 = padded[2:, 1:-1]
    p22 = padded[2:, 2:]

    #      [ -1 0 +1 ]
    # Gx = [ -2 0 +2 ] * A
    #      [ -1 0 +1 ]
    gx = (-p00 + p02) + (-2.0 * p10 + 2.0 * p12) + (-p20 + p22)

    #      [ -1 -2 -1 ]
    # Gy = [  0  0  0 ] * A
    #      [ +1 +2 +1 ]
    gy = (p00 + 2.0 * p01 + p02) + (-p20 - 2.0 * p21 - p22)

    return np.sqrt(gx * gx + gy * gy)


def detect_and_enhance_edges(image: np.ndarray, sensitivity: float = 0.6, edge_strength: float = 1.5) -> np.ndarray:
    """Detect and enhance edges with user control over sensitivity and strength.

    Method rationale:
    - Detect edges using Sobel gradient magnitude.
    - Convert gradient to a soft edge mask using a threshold controlled by
      `sensitivity`.
    - Enhance by adding an edge-boost term to the original image, scaled by
      `edge_strength`.

    Brief comparison with an alternative:
    - Alternative: Canny edge detection gives cleaner thin edge maps, but it
      requires tuning multiple thresholds and is usually for binary edges.
    - Sobel + soft boosting is simpler and directly suitable for enhancement.

    Limitations:
    - Can also amplify noise/texture in very noisy regions.
    - Very high sensitivity may produce halos around strong contrast boundaries.
    """
    sensitivity = float(np.clip(sensitivity, 0.0, 1.0))
    edge_strength = float(np.clip(edge_strength, 0.0, 5.0))

    if image.ndim == 2:
        image_rgb = np.stack([image, image, image], axis=-1)
        is_grayscale_input = True
    elif image.ndim == 3 and image.shape[2] >= 3:
        image_rgb = image[..., :3]
        is_grayscale_input = False
    else:
        raise ValueError("Expected image with shape (H, W) or (H, W, C>=3)")

    src = image_rgb.astype(np.float64) / 255.0
    gray = 0.299 * src[..., 0] + 0.587 * src[..., 1] + 0.114 * src[..., 2]

    # Compute edge strength and normalize to [0, 1]. If max is near zero, return original image.
    grad = _sobel_magnitude(gray)
    gmax = float(np.max(grad))
    if gmax <= 1e-12:
        result = np.clip(src * 255.0, 0, 255).astype(np.uint8)
        return result[..., 0] if is_grayscale_input else result

    grad_norm = grad / gmax

    # Higher sensitivity => lower threshold => more detected edges.
    threshold = 0.40 - 0.30 * sensitivity
    edge_response = np.clip((grad_norm - threshold) / max(1e-6, 1.0 - threshold), 0.0, 1.0)
    edge_soft = edge_response ** 0.8

    boosted = src + (edge_strength * 0.45) * edge_soft[..., None]
    enhanced = np.clip(boosted, 0.0, 1.0)
    out = np.clip(enhanced * 255.0, 0, 255).astype(np.uint8)

    if is_grayscale_input:
        return out[..., 0]
    return out


def _load_image(path: Path) -> np.ndarray:
    with Image.open(path) as img:
        if img.mode in ("L", "RGB"):
            use = img
        elif img.mode in ("RGBA", "LA"):
            use = img.convert("RGB")
        else:
            use = img.convert("RGB")
        return np.array(use)


def _save_image(arr: np.ndarray, path: Path) -> None:
    Image.fromarray(arr).save(path)


def _build_parser() -> argparse.ArgumentParser:
    description = (
        "Edge detection and enhancement extension with user-controlled sensitivity and edge strength."
    )
    epilog = (
        "The returned image has the same dimensions as the input, "
        "with edges enhanced by boosting pixel values based on a soft mask derived from Sobel gradients. "
        "The `sensitivity` parameter controls how many edges are detected (higher means more), "
        "while `edge_strength` controls how much the detected edges are boosted in intensity. "
        "This method is simple and effective for general edge enhancement, but may amplify noise if sensitivity is set too high."
    )

    parser = argparse.ArgumentParser(
        description=description,
        epilog=epilog,
        formatter_class=argparse.RawTextHelpFormatter,
    )
    parser.add_argument("--in", dest="input_image", required=True, help="Input image path")
    parser.add_argument("--out", dest="output_image", required=True, help="Output edge-enhanced image path")
    parser.add_argument(
        "--sensitivity",
        type=float,
        default=0.6,
        help="Edge sensitivity in [0,1]. Higher detects weaker edges. Default: 0.6",
    )
    parser.add_argument(
        "--strength",
        type=float,
        default=1.5,
        help="Edge boost strength in [0,5]. Higher gives stronger enhancement. Default: 1.5",
    )
    return parser


def main() -> int:
    parser = _build_parser()
    args = parser.parse_args()

    input_path = Path(args.input_image)
    output_path = Path(args.output_image)

    if not input_path.exists():
        print(f"Error: input file not found: {input_path}", file=sys.stderr)
        return 1

    try:
        image = _load_image(input_path)
        enhanced = detect_and_enhance_edges(
            image,
            sensitivity=args.sensitivity,
            edge_strength=args.strength,
        )
    except Exception as exc:
        print(f"Error: failed to detect/enhance edges for '{input_path}': {exc}", file=sys.stderr)
        return 1

    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        _save_image(enhanced, output_path)
    except Exception as exc:
        print(f"Error: failed to save output image '{output_path}': {exc}", file=sys.stderr)
        return 1

    print(f"Saved edge-enhanced image: {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
