from __future__ import annotations

import argparse
import sys
from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt
import numpy.typing as npt
from audio.audio_io import load_audio_auto, save_audio_auto

# Method: IIR biquad cascade for 11-band EQ.
# Chosen for:
# - efficient (low coefficient count)
# - direct control over centre frequency/gain/Q per band,
# - standard in real-time audio systems.
# Advantages: low latency, tight computational budget, tunable Q reduces ringing.
# Disadvantages vs:
# FIR: non-linear phase (acceptable for audio EQ)
# FFT: FFT avoids phase distortion but requires block processing and windowing overhead.

FREQ_BANDS = np.array(
    [16, 31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000], dtype=float
)
Q_VALUES = np.array(
    [0.9, 1.4, 1.4, 1.4, 1.4, 1.4, 1.4, 1.4, 1.4, 1.2, 0.9], dtype=float
)


# For these functions, the following applies:
# fs: sampling rate in Hz
# f0: the centre or shelf frequency in Hz
# gain_db: the gain in decibels (positive for boost, negative for cut)
# Q: the quality factor for peaking filters (ignored for shelves, which use S=1)


def design_low_shelf(
    fs: float, f0: float, gain_db: float
) -> tuple[npt.NDArray[np.float64], npt.NDArray[np.float64]]:
    """RBJ-style low-shelf biquad."""
    A = 10 ** (gain_db / 40.0)
    w0 = 2 * np.pi * f0 / fs
    cos_w0 = np.cos(w0)
    sin_w0 = np.sin(w0)
    S = 1.0
    alpha = sin_w0 / 2.0 * np.sqrt((A + 1 / A) * (1 / S - 1) + 2)

    # H(s) = A * (s^2 + (sqrt(A)/Q)*s + A)/(A*s^2 + (sqrt(A)/Q)*s + 1)
    b0 = A * ((A + 1) - (A - 1) * cos_w0 + 2 * np.sqrt(A) * alpha)
    b1 = 2 * A * ((A - 1) - (A + 1) * cos_w0)
    b2 = A * ((A + 1) - (A - 1) * cos_w0 - 2 * np.sqrt(A) * alpha)
    a0 = (A + 1) + (A - 1) * cos_w0 + 2 * np.sqrt(A) * alpha
    a1 = -2 * ((A - 1) + (A + 1) * cos_w0)
    a2 = (A + 1) + (A - 1) * cos_w0 - 2 * np.sqrt(A) * alpha

    #        (b0/a0) + (b1/a0)*z^-1 + (b2/a0)*z^-2
    # H(z) = -------------------------------------
    #        1 + (a1/a0)*z^-1 + (a2/a0)*z^-2
    b = np.array([b0, b1, b2]) / a0
    a = np.array([1.0, a1 / a0, a2 / a0])
    return b, a


def design_high_shelf(
    fs: float, f0: float, gain_db: float
) -> tuple[npt.NDArray[np.float64], npt.NDArray[np.float64]]:
    """RBJ-style high-shelf biquad."""

    A = 10 ** (gain_db / 40.0)
    w0 = 2 * np.pi * f0 / fs
    cos_w0 = np.cos(w0)
    sin_w0 = np.sin(w0)
    S = 1.0
    alpha = sin_w0 / 2.0 * np.sqrt((A + 1 / A) * (1 / S - 1) + 2)

    # H(s) = A * (A*s^2 + (sqrt(A)/Q)*s + 1)/(s^2 + (sqrt(A)/Q)*s + A)
    b0 = A * ((A + 1) + (A - 1) * cos_w0 + 2 * np.sqrt(A) * alpha)
    b1 = -2 * A * ((A - 1) + (A + 1) * cos_w0)
    b2 = A * ((A + 1) + (A - 1) * cos_w0 - 2 * np.sqrt(A) * alpha)
    a0 = (A + 1) - (A - 1) * cos_w0 + 2 * np.sqrt(A) * alpha
    a1 = 2 * ((A - 1) - (A + 1) * cos_w0)
    a2 = (A + 1) - (A - 1) * cos_w0 - 2 * np.sqrt(A) * alpha

    #        (b0/a0) + (b1/a0)*z^-1 + (b2/a0)*z^-2
    # H(z) = -------------------------------------
    #        1 + (a1/a0)*z^-1 + (a2/a0)*z^-2
    b = np.array([b0, b1, b2]) / a0
    a = np.array([1.0, a1 / a0, a2 / a0])
    return b, a


def design_peak(
    fs: float, f0: float, gain_db: float, Q: float = 1.0
) -> tuple[npt.NDArray[np.float64], npt.NDArray[np.float64]]:
    """RBJ peaking EQ biquad."""

    A = 10 ** (gain_db / 40.0)
    w0 = 2 * np.pi * f0 / fs
    cos_w0 = np.cos(w0)
    sin_w0 = np.sin(w0)
    alpha = sin_w0 / (2.0 * Q)

    # H(s) = (s^2 + s*(A/Q) + 1) / (s^2 + s/(A*Q) + 1)
    b0 = 1 + alpha * A
    b1 = -2 * cos_w0
    b2 = 1 - alpha * A
    a0 = 1 + alpha / A
    a1 = -2 * cos_w0
    a2 = 1 - alpha / A

    #        (b0/a0) + (b1/a0)*z^-1 + (b2/a0)*z^-2
    # H(z) = -------------------------------------
    #        1 + (a1/a0)*z^-1 + (a2/a0)*z^-2
    b = np.array([b0, b1, b2]) / a0
    a = np.array([1.0, a1 / a0, a2 / a0])
    return b, a


def apply_filter(
    b: npt.NDArray[np.float64], a: npt.NDArray[np.float64], x: npt.NDArray[np.float64]
) -> npt.NDArray[np.float64]:
    """Apply a biquad using NumPy (feedforward + sequential feedback)."""

    x = np.asarray(x, dtype=np.float64)
    y = np.zeros(len(x), dtype=np.float64)

    # y[n] = (b0/a0)*x[n] + (b1/a0)*x[n-1] + (b2/a0)*x[n-2]
    #                     - (a1/a0)*y[n-1] - (a2/a0)*y[n-2]

    # Applying to multiple elements at once saves significant time in Python.

    # Compute feedforward first.
    for k in range(len(b)):
        if k == 0:
            y[:] = b[k] * x
        else:
            y[k:] += b[k] * x[:-k]

    # Then apply feedback (in-place).
    for n in range(len(x)):
        for k in range(1, len(a)):
            if n - k >= 0:
                y[n] -= a[k] * y[n - k]

    return y


def parse_gains(gains_text: str) -> npt.NDArray[np.float64]:
    """Parse comma-separated gain values from the command line.

    Expects exactly 11 values corresponding to the defined frequency bands, such as:
    "6,4,2,0,-2,-4,-6,-4,-2,0,2"
    """

    values = np.array(
        [float(v.strip()) for v in gains_text.split(",") if v.strip() != ""],
        dtype=np.float64,
    )
    if len(values) != len(FREQ_BANDS):
        raise ValueError(f"Expected {len(FREQ_BANDS)} gain values, got {len(values)}")
    return values


def make_filters(
    fs: float, gains_db: npt.NDArray[np.float64]
) -> tuple[list[npt.NDArray[np.float64]], list[npt.NDArray[np.float64]]]:
    """Create biquad filter coefficients for all bands based on the specified gains."""

    b_list: list[npt.NDArray[np.float64]] = []
    a_list: list[npt.NDArray[np.float64]] = []

    nyquist = fs / 2.0
    for i, (f0, gain_db, Q) in enumerate(zip(FREQ_BANDS, gains_db, Q_VALUES)):
        f0_safe = min(float(f0), nyquist * 0.95)

        # Use shelf filters for the lowest and highest bands, peaking filters for the rest.
        if i == 0:
            b, a = design_low_shelf(fs, f0_safe, gain_db)
        elif i == len(FREQ_BANDS) - 1:
            b, a = design_high_shelf(fs, f0_safe, gain_db)
        else:
            b, a = design_peak(fs, f0_safe, gain_db, Q=Q)

        b_list.append(b)
        a_list.append(a)

    return b_list, a_list


def apply_equaliser(
    x: npt.NDArray[np.float64],
    b_list: list[npt.NDArray[np.float64]],
    a_list: list[npt.NDArray[np.float64]],
) -> npt.NDArray[np.float64]:
    """Apply the cascade of biquad filters to the input signal."""

    y = np.asarray(x, dtype=np.float64)
    for b, a in zip(b_list, a_list):
        y = apply_filter(b, a, y)
        print(f"Applied filter with b={b}, a={a}")
    return y


def estimate_response_from_filter_chain(
    b_list: list[npt.NDArray[np.float64]],
    a_list: list[npt.NDArray[np.float64]],
    n_fft: int = 8192,
) -> tuple[
    npt.NDArray[np.float64],
    list[npt.NDArray[np.complex128]],
    npt.NDArray[np.complex128],
]:
    """Compute one-sided frequency response for each band and cascaded response."""

    omega = np.linspace(0.0, 0.5, n_fft // 2 + 1, endpoint=True)
    z1 = np.exp(-2j * np.pi * omega)
    z2 = z1 * z1

    # Use the transfer function formula for each biquad:
    # H(z) = (b0 + b1*z^-1 + b2*z^-2) / (a0 + a1*z^-1 + a2*z^-2)
    H_list = []
    H_cascade = np.ones_like(omega, dtype=np.complex128)
    for b, a in zip(b_list, a_list):
        numerator = b[0] + b[1] * z1 + b[2] * z2
        denominator = a[0] + a[1] * z1 + a[2] * z2
        H = numerator / (denominator + 1e-12)
        H_list.append(H)
        H_cascade *= H

    return omega, H_list, H_cascade


def save_response_plot(
    omega: npt.NDArray[np.float64],
    H_list: list[npt.NDArray[np.complex128]],
    H_cascade: npt.NDArray[np.complex128],
    fs: float,
    output_image: str,
) -> None:
    """Save a plot of the frequency response for each band and the cascaded response."""

    freq_hz = omega * fs
    valid = freq_hz > 0
    cmap = plt.get_cmap("hsv", len(H_list))

    plt.figure(figsize=(12, 6))
    for i, (H, f0) in enumerate(zip(H_list, FREQ_BANDS)):
        mag_db = 20.0 * np.log10(np.maximum(np.abs(H), 1e-9))
        plt.semilogx(
            freq_hz[valid],
            mag_db[valid],
            color=cmap(i),
            linewidth=0.8,
            alpha=0.6,
            label=f"{f0:.1f} Hz",
        )

    # Overlay cascaded response in bold black.
    mag_db_cascade = 20.0 * np.log10(np.maximum(np.abs(H_cascade), 1e-9))
    plt.semilogx(
        freq_hz[valid],
        mag_db_cascade[valid],
        color="black",
        linewidth=2.5,
        label="Cascaded",
    )

    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Gain (dB)")
    plt.title("11-band Equaliser Frequency Response (Individual Bands + Cascaded)")
    plt.legend(loc="best", fontsize=8)
    plt.grid(True, which="both", linestyle=":")
    plt.tight_layout()
    plt.savefig(output_image, dpi=150)
    plt.close()


def build_arg_parser() -> argparse.ArgumentParser:
    """Build the command-line argument parser for the equaliser script."""

    epilog = (
        "The generated plot shows the frequency response of each individual band (thin colored lines) "
        "and the overall cascaded response (thick black line). The x-axis is logarithmic frequency, "
        "and the y-axis is gain in decibels. This visualisation helps to understand how the specified gains affect the audio spectrum."
    )

    parser = argparse.ArgumentParser(
        description="11-band audio equaliser", epilog=epilog
    )
    parser.add_argument("--input", required=True, help="Input audio file path")
    parser.add_argument("--output", required=True, help="Output audio file path")
    parser.add_argument(
        "--plot",
        required=False,
        help="Output frequency-response image path (e.g. png)",
        default="eq_response.png",
    )
    parser.add_argument(
        "--bands",
        required=True,
        help="11 comma-separated dB gains for bands [16..16000 Hz], e.g. '6,4,2,0,-2,-4,-6,-4,-2,0,2'",
    )
    return parser


def main() -> int:
    args = build_arg_parser().parse_args()

    input_path = Path(args.input)
    output_path = Path(args.output)
    plot_path = Path(args.plot)

    if not input_path.exists():
        print(f"Error: input file not found: {input_path}", file=sys.stderr)
        return 1

    try:
        gains_db = parse_gains(args.bands)
    except ValueError as exc:
        print(f"Error: invalid --bands argument: {exc}", file=sys.stderr)
        return 1

    try:
        x, fs = load_audio_auto(str(input_path), mono=True)
        b_list, a_list = make_filters(fs, gains_db)
        y = apply_equaliser(x, b_list, a_list)
    except Exception as exc:
        print(f"Error: failed to process '{input_path}': {exc}", file=sys.stderr)
        return 1

    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        plot_path.parent.mkdir(parents=True, exist_ok=True)
        save_audio_auto(str(output_path), y, fs)

        omega, H_list, H_cascade = estimate_response_from_filter_chain(
            b_list, a_list, n_fft=8192
        )
        save_response_plot(omega, H_list, H_cascade, fs, str(plot_path))
    except Exception as exc:
        print(f"Error: failed to save output(s): {exc}", file=sys.stderr)
        return 1

    print(f"Saved equalised audio: {output_path}")
    print(f"Saved response plot: {plot_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
