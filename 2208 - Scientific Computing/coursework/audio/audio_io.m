function [x, fs] = load_audio_auto(filename, target_fs, mono)
%LOAD_AUDIO_AUTO Load an audio file and return (x, fs).
%   [x, fs] = LOAD_AUDIO_AUTO(filename) loads the audio file using
%   AUDI0READ. The output x is a column vector (mono); stereo files are
%   converted to mono by averaging channels.
%
%   [x, fs] = LOAD_AUDIO_AUTO(filename, target_fs) additionally resamples
%   the signal to target_fs (Hz) using RESAMPLE if target_fs ~= fs.
%
%   [x, fs] = LOAD_AUDIO_AUTO(filename, target_fs, mono) controls whether
%   stereo files are converted to mono. If mono is false, the original
%   channel layout is preserved.
%
%   This helper is intended for use in the DSP1/DSP2 labs and coursework.

    if nargin < 2
        target_fs = [];
    end
    if nargin < 3
        mono = true;
    end

    [x, fs] = audioread(filename);

    if mono && size(x, 2) > 1
        x = mean(x, 2);
    end

    if ~isempty(target_fs) && target_fs ~= fs
        x = resample(x, target_fs, fs);
        fs = target_fs;
    end
end


function save_audio_auto(filename, x, fs)
%SAVE_AUDIO_AUTO Save audio data to a file, inferring format from extension.
%   SAVE_AUDIO_AUTO(filename, x, fs) writes the signal x at sample rate fs
%   using AUDI0WRITE. If the peak amplitude of x exceeds 1, the signal is
%   normalised to avoid clipping.
%
%   This helper is intended for use in the DSP1/DSP2 labs and coursework.

    if nargin < 3
        error('save_audio_auto:NotEnoughInputs', 'Usage: save_audio_auto(filename, x, fs)');
    end

    x = double(x);
    if isempty(x)
        error('save_audio_auto:EmptySignal', 'Cannot save an empty audio array.');
    end

    max_abs = max(abs(x), [], 'all');
    if max_abs > 1
        x = x / max_abs;
    end

    [~, ~, ext] = fileparts(filename);
    if strcmpi(ext, '.pcm')
        error('save_audio_auto:PCMNotSupported', ...
            'For raw .pcm output, use a dedicated writer that sets dtype and header explicitly.');
    end

    audiowrite(filename, x, fs);
end

