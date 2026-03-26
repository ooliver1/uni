# Audio helpers and sample files

This folder contains small helper modules and short audio clips used in the
**DSP1** and **DSP2** lectures and labs. It is intended to be distributed as a
separate ZIP (`audio.zip`) so students can reuse the same code and data across
languages.

## Helper modules

- `audio_io.py` – Python helper functions:
  - `load_audio_auto(filename, target_fs=None, mono=True)`
  - `save_audio_auto(filename, x, fs)`
  - `load_pcm(...)`, `save_pcm(...)` for raw PCM (advanced)

- `audio_io.m` – MATLAB helper functions:
  - `[x, fs] = load_audio_auto(filename, target_fs, mono)`
  - `save_audio_auto(filename, x, fs)`

- `audio_io.jl` – Julia helper functions:
  - `load_audio_auto(filename; target_fs=nothing, mono=true)`
  - `save_audio_auto(filename, x, fs)`

Each helper provides a simple, unified API for loading and saving at least
**WAV** files, and (depending on installed libraries/codecs) may also work with
**OGG**, **MP3**, and other libsndfile-supported formats.

### Dependencies and installation

- **Python**
  - The helpers in `audio_io.py` use the `soundfile` package (libsndfile) and
    optionally `scipy` for resampling when `target_fs` is set.
  - Install the required packages (e.g. in a virtual environment or your
    Python environment):

    ```bash
    pip install soundfile scipy
    ```

- **MATLAB**
  - The helpers in `audio_io.m` only use built‑in functions
    `audioread`, `audiowrite`, and `resample`. No extra toolboxes are required
    beyond a standard MATLAB installation.

- **Julia**
  - The helpers in `audio_io.jl` depend on:
    - `LibSndFile.jl` (for `loadsndfile` / `savesndfile`),
    - optionally `DSP.jl` for the resampling step when `target_fs` is given.
  - In a Julia REPL, add the packages (same style as in the DSP1/DSP2 module READMEs):

    ```julia
    using Pkg
    Pkg.add("LibSndFile")
    # optional, for resampling when target_fs is set:
    # Pkg.add("DSP")
    ```

## Sample files

All audio in this folder is derived from the original `sample.ogg` (included in
this folder).

- `sample.ogg` – original OGG Vorbis file (mono)
- `sample.wav` – 16‑bit PCM WAV, mono, 44.1 kHz
- `sample.mp3` – MP3, mono, 44.1 kHz
- `sample.pcm` – raw 16‑bit little‑endian PCM, mono, 44.1 kHz

The same WAV/MP3/PCM files are also available in `data/audio/` so that existing
lab paths continue to work.

## Recommended usage

- In labs and coursework, prefer **WAV** as the standard format for loading and
  saving audio, using these helpers.
- Use OGG/MP3/PCM as optional extensions:
  - OGG/MP3: require suitable codecs/libraries (e.g. `soundfile` + system
    codecs, libsndfile-based packages).
  - PCM: requires explicit dtype, number of channels, and sample rate.

The DSP1/DSP2 lab sheets reference this folder and these helper functions; the
reference solutions use the same APIs for any audio‑based examples.

