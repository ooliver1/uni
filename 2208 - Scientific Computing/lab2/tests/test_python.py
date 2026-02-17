"""
Unit tests for Linear Transformations and Fourier Transforms Lab - Python
Run with: pytest tests/test_python.py -v -s

Tests only run for functions you have implemented. Missing functions are skipped
with a short message so you can see your progress at any time. Use -s to see
the progress summary (implemented vs not implemented).
"""

import pytest
import numpy as np
import sys
import os
import importlib.util

# Resolve solution module: prefer my_solution first, then fall back to reference
parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, parent_dir)
my_solution_path = os.path.join(parent_dir, 'my_solution.py')
ref_solution_path = os.path.join(parent_dir, 'solutions', 'python_solution.py')

REQUIRED_NAMES = [
    'inner_product', 'fourier_basis', 'fourier_coefficient',
    'dft_manual', 'idft_manual', 'dft_matrix', 'fftshift_manual'
]


def _load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        return None
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


if os.path.isfile(my_solution_path):
    sol = _load_module(my_solution_path, 'lab_solution')
    if sol is None:
        pytest.exit("Could not load my_solution.py (invalid file?).", returncode=1)
    solution_name = 'my_solution.py'
else:
    if not os.path.isfile(ref_solution_path):
        pytest.exit(
            "No my_solution.py found. Create my_solution.py in 2-Transforms/lab/ and implement "
            "the required functions. See lab_exercises.md.",
            returncode=1
        )
    sol = _load_module(ref_solution_path, 'ref_solution')
    if sol is None:
        pytest.exit("Could not load reference solution.", returncode=1)
    solution_name = 'solutions/python_solution.py'


def _has(name):
    return getattr(sol, name, None) is not None


def _skip_if_missing(*names, msg=None):
    for n in names:
        if not _has(n):
            pytest.skip(msg or f"{n} not implemented yet. Add it to your solution file (see lab_exercises.md).")


def _print_implementation_summary():
    """Print which functions are implemented (for verbose runs with -s)."""
    implemented = [n for n in REQUIRED_NAMES if _has(n)]
    not_impl = [n for n in REQUIRED_NAMES if not _has(n)]
    print(f"Testing: {solution_name}")
    print(f"  Implemented: {', '.join(implemented) if implemented else '(none)'}")
    if not_impl:
        print(f"  Not implemented: {', '.join(not_impl)}")
    print()


# Print full summary to stdout when running with -s (no capture)
if hasattr(sys, 'argv') and '-s' in sys.argv:
    _print_implementation_summary()


class TestTask1LinearSpaces:
    """Tests for Task 1: Fourier series toolkit"""

    def test_inner_product_orthogonal(self):
        """Task 1: Inner product of orthogonal functions"""
        _skip_if_missing('inner_product')
        inner_product = getattr(sol, 'inner_product')
        f = lambda t: np.sin(2 * np.pi * t)
        g = lambda t: np.cos(2 * np.pi * t)
        ip = inner_product(f, g, 0, 1, 1000)
        assert abs(ip) < 0.01  # Should be approximately 0

    def test_inner_product_linearity(self):
        """Task 1: Linearity of inner product"""
        _skip_if_missing('inner_product')
        inner_product = getattr(sol, 'inner_product')
        f1 = lambda t: np.sin(2 * np.pi * t)
        f2 = lambda t: np.cos(2 * np.pi * t)
        g = lambda t: t
        a, b = 2.0, 3.0

        left = inner_product(lambda t: a*f1(t) + b*f2(t), g, 0, 1, 1000)
        right = a*inner_product(f1, g, 0, 1, 1000) + b*inner_product(f2, g, 0, 1, 1000)
        assert abs(left - right) < 1e-6

    def test_inner_product_conjugate_symmetry(self):
        """Task 1: Conjugate symmetry <f,g> = conj(<g,f>)"""
        _skip_if_missing('inner_product')
        inner_product = getattr(sol, 'inner_product')
        f = lambda t: np.sin(2 * np.pi * t)
        g = lambda t: np.cos(2 * np.pi * t)
        ip_fg = inner_product(f, g, 0, 1, 1000)
        ip_gf = inner_product(g, f, 0, 1, 1000)
        assert abs(ip_fg - np.conj(ip_gf)) < 1e-10

    def test_fourier_basis_orthonormality(self):
        """Task 1: Orthonormality of Fourier basis"""
        _skip_if_missing('fourier_basis')
        fourier_basis = getattr(sol, 'fourier_basis')
        t = np.linspace(0, 1, 1000)
        dt = 1.0 / 1000

        # Test <e_n, e_n> = 1
        for n in [-2, -1, 0, 1, 2]:
            e_n = fourier_basis(n, t)
            ip = np.sum(e_n * np.conj(e_n)) * dt
            assert abs(ip - 1.0) < 0.01

        # Test <e_n, e_m> = 0 for n != m
        e_0 = fourier_basis(0, t)
        e_1 = fourier_basis(1, t)
        ip = np.sum(e_0 * np.conj(e_1)) * dt
        assert abs(ip) < 0.01

    def test_fourier_coefficient_square_wave(self):
        """Task 1: Fourier coefficient computation"""
        _skip_if_missing('fourier_coefficient')
        fourier_coefficient = getattr(sol, 'fourier_coefficient')
        def square_wave(t):
            return np.where((t % 1) < 0.5, 1, -1)

        # DC component should be 0
        c_0 = fourier_coefficient(square_wave, 0, 0, 1, 1000)
        assert abs(c_0) < 0.01

        # First harmonic should be non-zero
        c_1 = fourier_coefficient(square_wave, 1, 0, 1, 1000)
        assert abs(c_1) > 0.1


class TestTask2DFT:
    """Tests for Task 2: Discrete Fourier Transform"""

    def test_dft_manual(self):
        """Task 2: Manual DFT implementation"""
        _skip_if_missing('dft_manual')
        dft_manual = getattr(sol, 'dft_manual')
        f = np.array([1, 0, 1, 0, 1, 0, 1, 0])
        F_manual = dft_manual(f)
        F_fft = np.fft.fft(f)

        assert np.max(np.abs(F_manual - F_fft)) < 1e-10

    def test_idft_manual(self):
        """Task 2: Manual inverse DFT"""
        _skip_if_missing('dft_manual', 'idft_manual')
        dft_manual = getattr(sol, 'dft_manual')
        idft_manual = getattr(sol, 'idft_manual')
        f = np.array([1, 0, 1, 0, 1, 0, 1, 0])
        F = dft_manual(f)
        f_reconstructed = idft_manual(F)

        assert np.max(np.abs(f - np.real(f_reconstructed))) < 1e-10

    def test_dft_matrix_unitarity(self):
        """Task 2: dft_matrix is unitary W W^H = I"""
        _skip_if_missing('dft_matrix')
        dft_matrix = getattr(sol, 'dft_matrix')
        N = 8
        W = dft_matrix(N)
        I_check = W @ W.conj().T
        assert np.max(np.abs(I_check - np.eye(N))) < 1e-10

    def test_dft_matrix_vs_fft(self):
        """Task 2: W @ f matches fft(f) / sqrt(N)"""
        _skip_if_missing('dft_matrix')
        dft_matrix = getattr(sol, 'dft_matrix')
        N = 8
        f = np.array([1, 0, 1, 0, 1, 0, 1, 0], dtype=float)
        W = dft_matrix(N)
        F_matrix = W @ f
        F_fft_normalized = np.fft.fft(f) / np.sqrt(N)
        assert np.max(np.abs(F_matrix - F_fft_normalized)) < 1e-10


class TestTask3Properties:
    """Tests for Task 3: FFT properties and spectra"""

    def test_linearity(self):
        """Task 3: Linearity of FFT"""
        N = 32
        t = np.arange(N) / N
        f1 = np.sin(2 * np.pi * 3 * t)
        f2 = np.cos(2 * np.pi * 3 * t)
        a, b = 2.0, 3.0

        F_linear = a * np.fft.fft(f1) + b * np.fft.fft(f2)
        F_combined = np.fft.fft(a * f1 + b * f2)

        assert np.max(np.abs(F_linear - F_combined)) < 1e-10

    def test_shifting_property(self):
        """Task 3: Shifting property"""
        N = 64
        t = np.arange(N) / N
        f = np.sin(2 * np.pi * 3 * t)
        shift = 10

        f_shifted = np.roll(f, shift)
        F = np.fft.fft(f)
        F_shifted = np.fft.fft(f_shifted)

        phase_factor = np.exp(-1j * 2 * np.pi * shift * np.arange(N) / N)
        F_theoretical = F * phase_factor

        assert np.max(np.abs(F_shifted - F_theoretical)) < 1e-10
        assert np.allclose(np.abs(F), np.abs(F_shifted), atol=1e-10)

    def test_parseval_theorem(self):
        """Task 3: Parseval's theorem"""
        N = 64
        f = np.sin(2 * np.pi * 3 * np.arange(N) / N)
        F = np.fft.fft(f)

        energy_time = np.sum(np.abs(f)**2)
        energy_freq = np.sum(np.abs(F)**2) / N

        assert abs(energy_time - energy_freq) < 1e-10

    def test_fftshift_manual(self):
        """Task 3: Manual fftshift"""
        _skip_if_missing('fftshift_manual')
        fftshift_manual = getattr(sol, 'fftshift_manual')
        N = 64
        f = np.sin(2 * np.pi * 3 * np.arange(N) / N)
        F = np.fft.fft(f)

        F_shifted = np.fft.fftshift(F)
        F_manual = fftshift_manual(F)

        assert np.max(np.abs(F_shifted - F_manual)) < 1e-10


class TestTask4Applications:
    """Tests for Task 4: 1D and 2D applications (property checks using built-in FFT)"""

    def test_2d_dft_separability(self):
        """Test 2D DFT separability (built-in fft2)"""
        np.random.seed(42)
        N, M = 8, 8
        f_2d = np.random.randn(N, M)

        F_direct = np.fft.fft2(f_2d)
        F_rows = np.fft.fft(f_2d, axis=1)
        F_separable = np.fft.fft(F_rows, axis=0)

        assert np.max(np.abs(F_direct - F_separable)) < 1e-10

    def test_2d_fftshift_center(self):
        """Test 2D fftshift places zero frequency at center"""
        np.random.seed(42)
        N, M = 32, 32
        f_2d = np.random.randn(N, M)

        F_2d = np.fft.fft2(f_2d)
        F_shifted = np.fft.fftshift(F_2d)

        center = (N//2, M//2)
        assert np.abs(F_shifted[center]) > 0


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])
