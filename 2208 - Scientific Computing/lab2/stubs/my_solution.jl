# Linear Transformations and Fourier Transforms Lab - Julia solution stub
# Copy this file to the lab folder (same level as tests/) and name it my_solution.jl.
# Implement the functions below. See lab_exercises.md for instructions.
# Lab has 4 tasks: 1 Fourier series toolkit, 2 Discrete Fourier Transform, 3 FFT properties and spectra, 4 1D and 2D applications.

using FFTW
using LinearAlgebra
using Plots
using QuadGK

# Task 1: Fourier series toolkit. ⟨f,g⟩, eₙ(t)=e^(i2πnt), cₙ=⟨f,eₙ⟩
function inner_product(f, g, a, b, n=1000)
    error("Implement inner_product (see lab_exercises.md).")
end

function fourier_basis(n, t)
    error("Implement fourier_basis (see lab_exercises.md).")
end

function fourier_coefficient(f, n, a=0, b=1, n_points=1000)
    error("Implement fourier_coefficient (see lab_exercises.md).")
end

# Task 2: DFT. F(k)=Σₗ fₗ e^(−i2πlk/N), idft, Wₖₗ=(1/√N)e^(−i2πkl/N)
function dft_manual(f)
    error("Implement dft_manual (see lab_exercises.md).")
end

function idft_manual(F)
    error("Implement idft_manual (see lab_exercises.md).")
end

function dft_matrix(N)
    error("Implement dft_matrix (see lab_exercises.md).")
end

# Task 3: fftshift: centre zero frequency (swap halves)
function fftshift_manual(F)
    error("Implement fftshift_manual (see lab_exercises.md).")
end
