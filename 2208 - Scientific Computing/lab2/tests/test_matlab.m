% Unit tests for Linear Transformations and Fourier Transforms Lab - MATLAB
% Run in MATLAB from lab directory: run('tests/test_matlab.m')
% Or from tests directory: run('test_matlab.m')
%
% Tests only run for functions you have implemented. Missing functions are skipped
% with a short message so you can see your progress at any time.
% Your my_solution.m can return a struct with only the fields you implemented.

% Try my_solution first, then reference solution
lab_dir = fileparts(fileparts(mfilename('fullpath')));
student_solution = fullfile(lab_dir, 'my_solution.m');
ref_solution_dir = fullfile(lab_dir, 'solutions');

if exist(student_solution, 'file')
    fprintf('Testing student solution: my_solution.m\n');
    addpath(lab_dir);
    sol = my_solution();
elseif exist(ref_solution_dir, 'dir')
    fprintf("Notice: 'my_solution.m' not found. Testing reference solution 'solutions/matlab_solution.m'.\n");
    addpath(ref_solution_dir);
    sol = matlab_solution();
else
    error("Could not find 'my_solution.m' or reference solution.");
end

required_names = {'inner_product', 'fourier_basis', 'fourier_coefficient', ...
    'dft_manual', 'idft_manual', 'dft_matrix', 'fftshift_manual'};

implemented = {};
not_impl = {};
for i = 1:length(required_names)
    if isfield(sol, required_names{i})
        implemented{end+1} = required_names{i}; %#ok<AGROW>
    else
        not_impl{end+1} = required_names{i}; %#ok<AGROW>
    end
end

fprintf('Running tests for Linear Transformations and Fourier Transforms Lab\n');
fprintf('================================================================\n');
if isempty(implemented)
    fprintf('Implemented: (none)\n');
else
    fprintf('Implemented: %s\n', strjoin(implemented, ', '));
end
if ~isempty(not_impl)
    fprintf('Not implemented: %s\n', strjoin(not_impl, ', '));
end
fprintf('\n');

% Helper: skip if any required field is missing
function skip = skip_if_missing(sol, names)
    skip = false;
    for i = 1:length(names)
        if ~isfield(sol, names{i})
            fprintf('  Skipping: %s not implemented yet. Add it to your solution file (see lab_exercises.md).\n', names{i});
            skip = true;
            return;
        end
    end
end

% ============================================================================
% Task 1: Functions as Linear Spaces and Fourier Basis
% ============================================================================

fprintf('Task 1: Functions as Linear Spaces and Fourier Basis\n');
fprintf('----------------------------------------------------\n');

% Test 1.1: Inner product of orthogonal functions
if ~skip_if_missing(sol, {'inner_product'})
    f1 = @(t) sin(2*pi*t);
    g1 = @(t) cos(2*pi*t);
    ip1 = sol.inner_product(f1, g1, 0, 1, 1000);
    assert(abs(ip1) < 0.01, 'Inner product of sin and cos should be ~0');
    fprintf('  ✓ Task 1: Inner product orthogonality\n');
end

% Test 1.1: Linearity of inner product
if ~skip_if_missing(sol, {'inner_product'})
    f1 = @(t) sin(2*pi*t);
    f2 = @(t) cos(2*pi*t);
    g = @(t) t;
    a = 2.0; b = 3.0;
    left = sol.inner_product(@(t) a*f1(t) + b*f2(t), g, 0, 1, 1000);
    right = a*sol.inner_product(f1, g, 0, 1, 1000) + b*sol.inner_product(f2, g, 0, 1, 1000);
    assert(abs(left - right) < 1e-6, 'Inner product should be linear');
    fprintf('  ✓ Task 1: Inner product linearity\n');
end

% Test 1.1: Conjugate symmetry
if ~skip_if_missing(sol, {'inner_product'})
    f = @(t) sin(2*pi*t);
    g = @(t) cos(2*pi*t);
    ip_fg = sol.inner_product(f, g, 0, 1, 1000);
    ip_gf = sol.inner_product(g, f, 0, 1, 1000);
    assert(abs(ip_fg - conj(ip_gf)) < 1e-10, 'Inner product should satisfy <f,g> = conj(<g,f>)');
    fprintf('  ✓ Task 1: Conjugate symmetry\n');
end

% Test 1.2: Fourier basis orthonormality
if ~skip_if_missing(sol, {'fourier_basis'})
    t = linspace(0, 1, 1000);
    dt = 1.0 / 1000;
    % Test <e_n, e_n> = 1 for n in {-2,-1,0,1,2}
    for n = [-2, -1, 0, 1, 2]
        e_n = sol.fourier_basis(n, t);
        ip = sum(e_n .* conj(e_n)) * dt;
        assert(abs(ip - 1.0) < 0.01, 'Fourier basis <e_n,e_n> should be ~1');
    end
    % Test <e_n, e_m> = 0 for n ~= m
    e_0 = sol.fourier_basis(0, t);
    e_1 = sol.fourier_basis(1, t);
    ip = sum(e_0 .* conj(e_1)) * dt;
    assert(abs(ip) < 0.01, 'Fourier basis should be orthogonal');
    fprintf('  ✓ Task 1: Fourier basis orthonormality\n');
end

% Test 1.3: Fourier coefficient (square wave)
if ~skip_if_missing(sol, {'fourier_coefficient'})
    square_wave = @(t) 2*double(mod(t,1) < 0.5) - 1;
    c_0 = sol.fourier_coefficient(square_wave, 0, 0, 1, 1000);
    assert(abs(c_0) < 0.01, 'Square wave DC component should be ~0');
    c_1 = sol.fourier_coefficient(square_wave, 1, 0, 1, 1000);
    assert(abs(c_1) > 0.1, 'Square wave first harmonic should be non-zero');
    fprintf('  ✓ Task 1: Fourier coefficient (square wave)\n');
end

% ============================================================================
% Task 2: Fourier Series, DFT, and FFT
% ============================================================================

fprintf('\nTask 2: Fourier Series, DFT, and FFT\n');
fprintf('----------------------------------------------------\n');

% Test 2.1: Manual DFT
if ~skip_if_missing(sol, {'dft_manual'})
    f = [1, 0, 1, 0, 1, 0, 1, 0];
    F_manual = sol.dft_manual(f);
    F_fft = fft(f);
    assert(max(abs(F_manual - F_fft)) < 1e-10, 'Manual DFT should match FFT');
    fprintf('  ✓ Task 2: Manual DFT\n');
end

% Test 2.1: Manual IDFT
if ~skip_if_missing(sol, {'dft_manual', 'idft_manual'})
    f = [1, 0, 1, 0, 1, 0, 1, 0];
    F_manual = sol.dft_manual(f);
    f_reconstructed = sol.idft_manual(F_manual);
    assert(max(abs(f - real(f_reconstructed))) < 1e-10, 'IDFT should recover original');
    fprintf('  ✓ Task 2: Manual IDFT\n');
end

% Test 2.2: dft_matrix unitarity
if ~skip_if_missing(sol, {'dft_matrix'})
    N = 8;
    W = sol.dft_matrix(N);
    I_check = W * W';
    assert(max(max(abs(I_check - eye(N)))) < 1e-10, 'dft_matrix should be unitary');
    fprintf('  ✓ Task 2: dft_matrix unitarity\n');
end

% Test 2.2: dft_matrix vs FFT
if ~skip_if_missing(sol, {'dft_matrix'})
    f_vec = [1, 0, 1, 0, 1, 0, 1, 0];
    W = sol.dft_matrix(8);
    F_matrix = W * f_vec';
    F_fft_normalized = fft(f_vec)' / sqrt(8);
    assert(max(abs(F_matrix - F_fft_normalized)) < 1e-10, 'W*f should match fft(f)/sqrt(N)');
    fprintf('  ✓ Task 2: dft_matrix vs FFT\n');
end

% ============================================================================
% Task 3: Properties of the Fourier Transform
% ============================================================================

fprintf('\nTask 3: Properties of the Fourier Transform\n');
fprintf('----------------------------------------------------\n');

% Test 3.1: Linearity
N = 32;
t = (0:N-1) / N;
f1 = sin(2*pi*3*t);
f2 = cos(2*pi*3*t);
a = 2.0;
b = 3.0;
F_linear = a * fft(f1) + b * fft(f2);
F_combined = fft(a * f1 + b * f2);
assert(max(abs(F_linear - F_combined)) < 1e-10, 'FFT should be linear');
fprintf('  ✓ Task 3: Linearity\n');

% Test 3.2: Shifting property
N = 64;
t = (0:N-1) / N;
f = sin(2*pi*3*t);
shift = 10;
f_shifted = circshift(f, shift);
F = fft(f);
F_shifted = fft(f_shifted);
phase_factor = exp(-2*pi*1i*shift*(0:N-1)/N);
F_theoretical = F .* phase_factor;
assert(max(abs(F_shifted - F_theoretical)) < 1e-10, 'Shifting property should hold');
assert(all(abs(abs(F) - abs(F_shifted)) < 1e-10), 'Magnitude should be unchanged');
fprintf('  ✓ Task 3: Shifting property\n');

% Test 3.3: Parseval's theorem
N = 64;
f = sin(2*pi*3*(0:N-1)/N);
F = fft(f);
energy_time = sum(abs(f).^2);
energy_freq = sum(abs(F).^2) / N;
assert(abs(energy_time - energy_freq) < 1e-10, 'Parseval''s theorem should hold');
fprintf('  ✓ Task 3: Parseval''s theorem\n');

% Test 3.4: fftshift_manual
if ~skip_if_missing(sol, {'fftshift_manual'})
    N = 64;
    f = sin(2*pi*3*(0:N-1)/N);
    F = fft(f);
    F_shifted = fftshift(F);
    F_manual = sol.fftshift_manual(F);
    assert(max(abs(F_shifted - F_manual)) < 1e-10, 'Manual fftshift should match built-in');
    fprintf('  ✓ Task 3: fftshift_manual\n');
end

% ============================================================================
% Task 4: Applications (1D and 2D)
% ============================================================================

fprintf('\nTask 4: Applications (1D and 2D)\n');
fprintf('----------------------------------------------------\n');

% Test 4: 2D DFT separability
rng(42);
N = 8;
M = 8;
f_2d = randn(N, M);
F_direct = fft2(f_2d);
F_rows = fft(f_2d, [], 2);
F_separable = fft(F_rows, [], 1);
assert(max(max(abs(F_direct - F_separable))) < 1e-10, '2D DFT should be separable');
fprintf('  ✓ 2D DFT separability\n');

% Test 4: 2D fftshift center
rng(42);
N = 32;
M = 32;
f_2d = randn(N, M);
F_2d = fft2(f_2d);
F_shifted = fftshift(F_2d);
center_val = F_shifted(N/2+1, M/2+1);
assert(abs(center_val) > 0, 'Zero frequency should be at center after fftshift');
fprintf('  ✓ 2D fftshift center\n');

% Progress summary at end (same style as DSP1/DSP2)
implemented_final = {};
not_impl_final = {};
for i = 1:length(required_names)
    if isfield(sol, required_names{i})
        implemented_final{end+1} = required_names{i}; %#ok<AGROW>
    else
        not_impl_final{end+1} = required_names{i}; %#ok<AGROW>
    end
end
n_impl = length(implemented_final);
n_total = length(required_names);
fprintf('\n================================================================\n');
fprintf('Progress: %d/%d functions implemented\n', n_impl, n_total);
if ~isempty(implemented_final)
    fprintf('Implemented: %s\n', strjoin(implemented_final, ', '));
end
if ~isempty(not_impl_final)
    fprintf('Not yet: %s\n', strjoin(not_impl_final, ', '));
end
fprintf('================================================================\n');
fprintf('All tests completed!\n');
fprintf('================================================================\n');
