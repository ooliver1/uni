module audio_io

"""
Shared audio I/O helpers for labs and lectures (Julia).

These functions are intended for educational use in the 3-DSP1 and 4-DSP2
materials. They use FileIO.load/save with LibSndFile to handle WAV, OGG, FLAC, etc.
Requires: FileIO, LibSndFile, and SampledSignals (the latter two are dependencies of LibSndFile).
"""

using FileIO: load, save
import LibSndFile
using SampledSignals: samplerate, SampleBuf
using Statistics: mean

export load_audio_auto, save_audio_auto

"""
    load_audio_auto(filename; target_fs=nothing, mono=true)

Load an audio file and return `(x, fs)`.

- `x` is a vector of `Float32` samples when `mono=true`, obtained by averaging
  channels for multi-channel input.
- When `mono=false`, the original channel layout is preserved.
- If `target_fs` is provided and differs from the file's sample rate, a simple
  resampling step is applied using DSP.resample (if available).
"""
function load_audio_auto(filename::AbstractString; target_fs::Union{Nothing,Int}=nothing, mono::Bool=true)
    buf = load(filename)
    fs = Int(samplerate(buf))
    x = float.(buf)

    # Convert to mono if requested
    if mono && ndims(x) == 2
        x = dropdims(mean(x, dims=2), dims=2)
    end

    # Optional resampling (requires DSP.jl)
    if target_fs !== nothing && target_fs != fs
        try
            @eval using DSP
            n_new = Int(round(length(x) * target_fs / fs))
            x = DSP.resample(x, n_new)
            fs = target_fs
        catch
            error("Resampling requested but DSP.jl is not available. Either install DSP.jl or omit target_fs.")
        end
    end

    # Normalise if peak exceeds 1.0
    if length(x) > 0
        max_abs = maximum(abs, x)
        if max_abs > 1.0
            x ./= max_abs
        end
    end

    return x, fs
end


"""
    save_audio_auto(filename, x, fs)

Save audio data to a file, inferring the format from the extension.

- `x` is converted to `Float32` and softly normalised if its peak amplitude
  exceeds 1.0.
- For raw PCM output, use explicit `open`/`write` logic instead; this helper is
  intended for container formats such as WAV/OGG.
"""
function save_audio_auto(filename::AbstractString, x, fs::Integer)
    ext = lowercase(splitext(String(filename))[2])
    if ext == ".pcm"
        error("save_audio_auto: For raw .pcm output, write headerless integer samples explicitly.")
    end

    x = Float32.(x)
    if length(x) == 0
        error("save_audio_auto: Cannot save an empty audio array.")
    end

    max_abs = maximum(abs, x)
    if max_abs > 1.0f0
        x ./= max_abs
    end

    # FileIO.save expects a SampleBuf (or array that LibSndFile can write)
    buf_out = SampleBuf(x, fs)
    save(filename, buf_out)
    return nothing
end

end # module

