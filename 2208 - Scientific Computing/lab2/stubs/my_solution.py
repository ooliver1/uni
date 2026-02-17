"""
Linear Transformations and Fourier Transforms Lab - Python solution stub
Copy this file to the lab folder (same level as tests/) and name it my_solution.py.
Implement the functions below. See lab_exercises.md for instructions.
Lab has 4 tasks: 1 Fourier series toolkit, 2 Discrete Fourier Transform, 3 FFT properties and spectra, 4 1D and 2D applications.
"""

import numpy as np


# Task 1: Fourier series toolkit
def inner_product(f, g, a, b, n=1000):
    """⟨f, g⟩ = ∫ f ḡ dt on [a,b] (e.g. Riemann sum with n points)."""
    raise NotImplementedError("Implement inner_product (see lab_exercises.md).")


def fourier_basis(n, t):
    raise NotImplementedError("Implement fourier_basis (see lab_exercises.md).")


def fourier_coefficient(f, n, a=0, b=1, n_points=1000):
    """cₙ = ⟨f, eₙ⟩ = ∫ f(t) e^(−i2πnt) dt on [a,b]."""
    raise NotImplementedError("Implement fourier_coefficient (see lab_exercises.md).")


# Task 2: Discrete Fourier Transform
def dft_manual(f):
    """F(k) = Σₗ fₗ e^(−i2πlk/N), k = 0, …, N−1."""
    raise NotImplementedError("Implement dft_manual (see lab_exercises.md).")


def idft_manual(F):
    """f(l) = (1/N) Σₖ Fₖ e^(i2πlk/N)."""
    raise NotImplementedError("Implement idft_manual (see lab_exercises.md).")


def dft_matrix(N):
    """Return W with Wₖₗ = (1/√N) e^(−i2πkl/N), W W^H = I."""
    raise NotImplementedError("Implement dft_matrix (see lab_exercises.md).")


# Task 3: FFT properties and spectra
def fftshift_manual(F):
    """Centre zero frequency: swap left and right halves of F."""
    raise NotImplementedError("Implement fftshift_manual (see lab_exercises.md).")
