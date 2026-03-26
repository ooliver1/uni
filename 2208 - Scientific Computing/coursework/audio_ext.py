from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np

from audio.audio_io import load_audio_auto, save_audio_auto


def _stft(x: np.ndarray, n_fft: int, hop: int) -> np.ndarray:
    """Short-time Fourier transform: returns shape (freq_bins, frames)."""

    if x.ndim != 1:
        raise ValueError("STFT expects a 1D signal")
    if n_fft <= 0 or hop <= 0:
        raise ValueError("n_fft and hop must be positive")

    if len(x) < n_fft:
        x = np.pad(x, (0, n_fft - len(x)))

    n_frames = 1 + int(np.ceil((len(x) - n_fft) / hop))
    total_len = (n_frames - 1) * hop + n_fft
    pad_len = max(0, total_len - len(x))
    x_pad = np.pad(x, (0, pad_len))

    window = np.hanning(n_fft).astype(np.float64)
    spec = np.empty((n_fft // 2 + 1, n_frames), dtype=np.complex128)

    for frame in range(n_frames):
        start = frame * hop
        frame_samples = x_pad[start : start + n_fft] * window
        spec[:, frame] = np.fft.rfft(frame_samples)

    return spec


def _istft(
    spec: np.ndarray, n_fft: int, hop: int, target_len: int | None = None
) -> np.ndarray:
    """Inverse STFT with overlap-add and window-energy normalization."""

    if spec.ndim != 2:
        raise ValueError("ISTFT expects a 2D spectrogram")

    n_frames = spec.shape[1]
    if n_frames == 0:
        return np.zeros(0, dtype=np.float64)

    # Use the same window as in _stft for perfect reconstruction.
    window = np.hanning(n_fft).astype(np.float64)
    out_len = (n_frames - 1) * hop + n_fft
    y = np.zeros(out_len, dtype=np.float64)
    wsum = np.zeros(out_len, dtype=np.float64)

    # Overlap-add the inverse FFT of each frame, weighted by the window.
    for frame in range(n_frames):
        start = frame * hop
        block = np.fft.irfft(spec[:, frame], n=n_fft)
        y[start : start + n_fft] += block * window
        wsum[start : start + n_fft] += window * window

    nonzero = wsum > 1e-10
    y[nonzero] /= wsum[nonzero]

    if target_len is None:
        return y

    if len(y) >= target_len:
        return y[:target_len]
    return np.pad(y, (0, target_len - len(y)))


def _phase_vocoder(spec: np.ndarray, rate: float, hop: int, n_fft: int) -> np.ndarray:
    """Time-scale a complex spectrogram using phase vocoder processing."""

    if rate <= 0:
        raise ValueError("rate must be positive")

    n_bins, n_frames = spec.shape
    if n_frames < 2:
        return spec.copy()

    time_steps = np.arange(0.0, n_frames - 1, rate, dtype=np.float64)
    out = np.zeros((n_bins, len(time_steps)), dtype=np.complex128)

    phase_adv = 2.0 * np.pi * hop * np.arange(n_bins) / n_fft
    phase_acc = np.angle(spec[:, 0]).copy()

    # For each output time step, interpolate magnitude and accumulate phase.
    for out_idx, t in enumerate(time_steps):
        frame = int(np.floor(t))
        frac = t - frame

        s0 = spec[:, frame]
        s1 = spec[:, frame + 1]

        mag = (1.0 - frac) * np.abs(s0) + frac * np.abs(s1)

        phase0 = np.angle(s0)
        phase1 = np.angle(s1)
        delta = phase1 - phase0 - phase_adv
        delta = (delta + np.pi) % (2.0 * np.pi) - np.pi

        phase_acc += phase_adv + delta
        out[:, out_idx] = mag * np.exp(1j * phase_acc)

    return out


def _linear_resample(x: np.ndarray, target_len: int) -> np.ndarray:
    """Length-only linear resampling helper."""

    if target_len <= 0:
        raise ValueError("target_len must be positive")
    if len(x) == target_len:
        return x.copy()
    if len(x) < 2:
        return np.full(target_len, x[0] if len(x) == 1 else 0.0, dtype=np.float64)

    src_pos = np.linspace(0.0, 1.0, num=len(x), endpoint=True)
    dst_pos = np.linspace(0.0, 1.0, num=target_len, endpoint=True)
    return np.interp(dst_pos, src_pos, x)


def pitch_shift_channel(
    x: np.ndarray, semitones: float, n_fft: int = 2048, hop: int = 512
) -> np.ndarray:
    """Shift pitch by semitones while preserving duration (phase vocoder + resample).

    Method:
    1) Time-stretch with phase vocoder by rate = 1 / pitch_factor.
    2) Resample stretched signal back to original sample count.

    Why suitable:
    - Preserves duration while changing perceived pitch.
    - Works for wide range of audio and is a standard DSP approach.
    """

    if x.ndim != 1:
        raise ValueError("pitch_shift_channel expects a 1D array")

    factor = float(2.0 ** (semitones / 12.0))
    if factor <= 0:
        raise ValueError("Invalid pitch factor")

    rate = 1.0 / factor
    spec = _stft(x.astype(np.float64), n_fft=n_fft, hop=hop)
    stretched_spec = _phase_vocoder(spec, rate=rate, hop=hop, n_fft=n_fft)
    stretched = _istft(stretched_spec, n_fft=n_fft, hop=hop)
    shifted = _linear_resample(stretched, target_len=len(x))
    return shifted.astype(np.float32)


def pitch_shift_audio(
    x: np.ndarray, semitones: float, n_fft: int = 2048, hop: int = 512
) -> np.ndarray:
    """Shift pitch of multi-channel audio by semitones while preserving duration."""

    if x.ndim == 1:
        return pitch_shift_channel(x, semitones=semitones, n_fft=n_fft, hop=hop)

    if x.ndim != 2:
        raise ValueError("Expected audio shape (samples,) or (samples, channels)")

    channels = []
    for ch in range(x.shape[1]):
        channels.append(
            pitch_shift_channel(x[:, ch], semitones=semitones, n_fft=n_fft, hop=hop)
        )
    return np.stack(channels, axis=1)


def _build_parser() -> argparse.ArgumentParser:
    description = (
        "Real-time pitch shifting extension: "
        "shift pitch up/down without changing duration."
    )

    parser = argparse.ArgumentParser(
        description=description, formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        "--in", dest="input_audio", required=True, help="Input audio path"
    )
    parser.add_argument(
        "--out", dest="output_audio", required=True, help="Output audio path"
    )
    parser.add_argument(
        "--semitones",
        type=float,
        required=True,
        help="Pitch shift in semitones (e.g., +3, -5, +12)",
    )
    parser.add_argument(
        "--nfft", type=int, default=2048, help="STFT FFT size (default: 2048)"
    )
    parser.add_argument(
        "--hop", type=int, default=512, help="STFT hop size (default: 512)"
    )
    return parser


def main() -> int:
    parser = _build_parser()
    args = parser.parse_args()

    input_path = Path(args.input_audio)
    output_path = Path(args.output_audio)

    if not input_path.exists():
        print(f"Error: input file not found: {input_path}", file=sys.stderr)
        return 1

    if args.nfft <= 0 or args.hop <= 0:
        print("Error: --nfft and --hop must be positive.", file=sys.stderr)
        return 1
    if args.hop > args.nfft:
        print(
            "Error: --hop should be <= --nfft for stable overlap-add.", file=sys.stderr
        )
        return 1

    try:
        x, fs = load_audio_auto(str(input_path), mono=False)
        y = pitch_shift_audio(
            x, semitones=args.semitones, n_fft=args.nfft, hop=args.hop
        )
    except Exception as exc:
        print(f"Error: failed to process '{input_path}': {exc}", file=sys.stderr)
        return 1

    try:
        output_path.parent.mkdir(parents=True, exist_ok=True)
        save_audio_auto(str(output_path), y, fs)
    except Exception as exc:
        print(f"Error: failed to save '{output_path}': {exc}", file=sys.stderr)
        return 1

    print(f"Saved pitch-shifted audio: {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
