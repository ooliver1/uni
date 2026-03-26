from __future__ import annotations

"""
Shared audio I/O helpers for labs and lectures (Python).

Supports loading and saving common audio formats (WAV, OGG, MP3, FLAC, etc.)
via the ``soundfile`` package (libsndfile). Headerless PCM is supported via
dedicated helpers that require explicit dtype and sample rate.

These functions are intended for educational use in the 3-DSP1 and 4-DSP2
materials. They mirror the ``audio_io.py`` helper at the repository root so
that this ``audio`` folder can be zipped and distributed independently.
"""

import numpy as np

try:
    import soundfile as sf
except ImportError as exc:  # pragma: no cover - import-time guidance only
    raise ImportError(
        "The 'soundfile' package is required for audio_io.load_audio_auto / "
        "save_audio_auto. Install it with 'pip install soundfile'."
    ) from exc


def load_audio_auto(
    filename: str,
    target_fs: int | None = None,
    mono: bool = True,
) -> tuple[np.ndarray, int]:
    """
    Load an audio file and return (x, fs).

    - Supports formats handled by soundfile (typically WAV, OGG, FLAC, MP3 if codecs are available).
    - Returns float32 samples; if integer data are read, they are normalised to roughly [-1, 1].
    - If mono=True and the file has multiple channels, channels are averaged.
    - If target_fs is given and differs from the file's sample rate, a simple
      Fourier-based resampler is used (via scipy.signal.resample).

    For headerless PCM use load_pcm instead, where you specify dtype and fs explicitly.
    """
    if filename.lower().endswith(".pcm"):
        raise ValueError(
            "Use load_pcm for raw .pcm files where you know dtype, channels, and fs."
        )

    x, fs = sf.read(filename, always_2d=True)

    if mono:
        x = x.mean(axis=1)
    else:
        x = np.asarray(x)

    if target_fs is not None and target_fs != fs:
        try:
            from scipy import signal as sig  # type: ignore[import]
        except ImportError as exc:  # pragma: no cover - import-time guidance only
            raise ImportError(
                "Resampling requires scipy. Install it with 'pip install scipy', "
                "or call load_audio_auto with target_fs=None."
            ) from exc

        n_new = int(round(len(x) * float(target_fs) / float(fs)))
        if n_new <= 0:
            raise ValueError("Computed resampled length is non-positive.")
        x = sig.resample(x, n_new)
        fs = target_fs

    x = np.asarray(x, dtype=np.float32)
    max_abs = float(np.max(np.abs(x))) if x.size else 0.0
    if max_abs > 0 and max_abs > 1.0:
        x /= max_abs

    return x, int(fs)


def save_audio_auto(filename: str, x: np.ndarray, fs: int) -> None:
    """
    Save audio data to a file, inferring the format from the extension.

    - filename extension selects the container (e.g. .wav, .ogg, .mp3 where supported).
    - x is converted to float32 and softly normalised if its peak amplitude exceeds 1.
    - For headerless PCM, use save_pcm instead of this function.
    """
    ext = filename.lower().rsplit(".", 1)[-1]
    if ext == "pcm":
        raise ValueError(
            "Use save_pcm for raw .pcm output where you control dtype and header."
        )

    x = np.asarray(x, dtype=np.float32)
    if x.size == 0:
        raise ValueError("Cannot save an empty audio array.")

    max_abs = float(np.max(np.abs(x)))
    if max_abs > 1.0:
        x = x / max_abs

    sf.write(filename, x, fs)


def load_pcm(
    filename: str,
    fs: int,
    *,
    dtype: np.dtype = np.int16,
    channels: int = 1,
    mono: bool = True,
) -> tuple[np.ndarray, int]:
    """
    Load headerless PCM data from a file and return (x, fs).

    - dtype: integer dtype used in the file (e.g. np.int16).
    - channels: number of interleaved channels.
    - mono=True averages channels to mono; mono=False returns a 2D array (samples, channels).
    """
    data = np.fromfile(filename, dtype=dtype)
    if channels > 1:
        if data.size % channels != 0:
            raise ValueError("PCM data size is not divisible by the number of channels.")
        data = data.reshape(-1, channels)

    if mono and channels > 1:
        x = data.mean(axis=1)
    else:
        x = data

    if np.issubdtype(dtype, np.integer):
        max_val = float(np.iinfo(dtype).max)
        x = x.astype(np.float32) / max_val
    else:
        x = x.astype(np.float32)

    return x, fs


def save_pcm(
    filename: str,
    x: np.ndarray,
    fs: int,
    *,
    dtype: np.dtype = np.int16,
) -> None:
    """
    Save audio data to headerless PCM.

    - x is assumed to be float in approximately [-1, 1]; values are clipped to [-1, 1]
      and scaled to the integer range of dtype.
    - fs is recorded for the caller's reference but not written to the file.
    """
    del fs  # fs not stored in raw PCM, keep for API symmetry only

    x = np.asarray(x, dtype=np.float32)
    if x.size == 0:
        raise ValueError("Cannot save an empty audio array.")

    y = np.clip(x, -1.0, 1.0)
    if not np.issubdtype(dtype, np.integer):
        raise ValueError("save_pcm currently supports only integer dtypes.")

    max_val = float(np.iinfo(dtype).max)
    y = (y * max_val).astype(dtype)
    y.tofile(filename)

