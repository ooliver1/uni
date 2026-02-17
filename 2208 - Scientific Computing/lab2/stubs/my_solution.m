% Linear Transformations and Fourier Transforms Lab - MATLAB solution stub
% Copy this file to the lab folder (same level as tests/) and name it my_solution.m.
% Implement the functions below. The primary function must return a struct of
% function handles. See lab_exercises.md for instructions.
% Lab has 4 tasks: 1 Fourier series toolkit, 2 Discrete Fourier Transform, 3 FFT properties and spectra, 4 1D and 2D applications.

function sol = my_solution()
    sol.inner_product = @inner_product;
    sol.fourier_basis = @fourier_basis;
    sol.fourier_coefficient = @fourier_coefficient;
    sol.dft_manual = @dft_manual;
    sol.idft_manual = @idft_manual;
    sol.dft_matrix = @dft_matrix;
    sol.fftshift_manual = @fftshift_manual;
end

% Task 1: ⟨f,g⟩; eₙ(t)=e^(i2πnt); cₙ=⟨f,eₙ⟩
function out = inner_product(f, g, a, b, n)
    error('Not implemented: inner_product.');
end
function out = fourier_basis(n, t)
    error('Not implemented: fourier_basis.');
end
function out = fourier_coefficient(f, n, a, b, n_points)
    error('Not implemented: fourier_coefficient.');
end
% Task 2: F(k)=Σₗ fₗ e^(−i2πlk/N); idft; Wₖₗ=(1/√N)e^(−i2πkl/N)
function out = dft_manual(f)
    error('Not implemented: dft_manual.');
end
function out = idft_manual(F)
    error('Not implemented: idft_manual.');
end
function out = dft_matrix(N)
    error('Not implemented: dft_matrix.');
end
% Task 3: fftshift: centre zero frequency (swap halves)
function out = fftshift_manual(F)
    error('Not implemented: fftshift_manual.');
end
