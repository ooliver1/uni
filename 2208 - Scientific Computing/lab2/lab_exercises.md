# Linear Transformations and Fourier Transforms - Lab Exercises

**Languages:** Python, Julia, or MATLAB (choose one or explore multiple)

This lab provides hands-on practice with linear transformations in functional spaces, focusing on Fourier transforms. The lab is organized into four tasks aligned with the lecture, each taking about 20–25 minutes.

---

## For a 2h lab session

- **Core (aim to complete):** Implement the four tasks below. The test suite checks: `inner_product`, `fourier_basis`, `fourier_coefficient`, `dft_manual`, `idft_manual`, `dft_matrix`, `fftshift_manual`. Run the tests often to see your progress.
- **Suggested order:** Task 1 → Task 2 → Task 3 → Task 4.
- **Deliverable:** By the end of the lab, aim for all tests passing.

---

## Setup

These instructions use UTF-8; if symbols like φ, ω, Σ don't display correctly, set your editor or terminal to UTF-8.

### Python
```python
import numpy as np
import matplotlib.pyplot as plt
```

### Julia
```julia
using FFTW
using LinearAlgebra
using Plots
using QuadGK
```

### MATLAB
```matlab
% All FFT operations are built-in (fft, ifft, fft2, ifft2, fftshift, fftfreq)
```

---

## Task 1 (20–25 min): Fourier series toolkit

*Aligns with Lecture Section 1 and start of Section 2.*

Build a small toolkit to treat functions as vectors: inner product, Fourier basis, and Fourier coefficients. You will use it to analyse the square wave.

**Step-by-step instructions:**

1. Implement `inner_product(f, g, a, b, n)` that computes ⟨f, g⟩ = ∫ₐᵇ f(t) ḡ(t) dt numerically (e.g. Riemann sum with `n` points). Use the conjugate of g.

2. Test with f(t) = sin(2πt), g(t) = cos(2πt) on [0, 1]; the result should be approximately 0 (orthogonal). Optionally test f(t) = t, g(t) = t² on [0, 1] and verify linearity and conjugate symmetry of the inner product.

3. Implement `fourier_basis(n, t)` returning eₙ(t) = e^(i2πnt) for a vector of t values.

4. Using your inner product, verify orthonormality ⟨eₙ, eₘ⟩ = δₙₘ for n, m ∈ {−2, −1, 0, 1, 2} on [0, 1]. Expected: ⟨e₀, e₀⟩ = 1, ⟨e₁, e₁⟩ = 1, ⟨e₀, e₁⟩ ≈ 0.

5. Implement `fourier_coefficient(f, n, a, b, n_points)` computing cₙ = ⟨f, eₙ⟩ = ∫ₐᵇ f(t) e^(−i2πnt) dt. For the square wave on [0, 1] (1 for t mod 1 < 0.5, −1 otherwise), compute c₋₂, c₋₁, c₀, c₁, c₂ and check c₋ₙ = c̄ₙ for real f. Expected: c₀ ≈ 0, c₁ ≈ −0.637i (i.e. −2i/π), c₋₁ ≈ 0.637i (i.e. 2i/π).

*If time:* Implement `differentiation_matrix(degree)` (optional; not tested).

---

## Task 2 (20–25 min): Discrete Fourier Transform

*Aligns with Lecture Section 2.*

Implement the DFT and inverse DFT by hand, express the DFT as a unitary matrix, and compare with the built-in FFT.

**Step-by-step instructions:**

1. Implement `dft_manual(f)` that computes the Discrete Fourier Transform:
   F(k) = Σₗ₌₀^(N−1) fₗ e^(−i2πlk/N)
   for k = 0, 1, …, N−1 where N is the length of f.

2. Implement `idft_manual(F)` that computes the inverse DFT:
   f(l) = (1/N) Σₖ₌₀^(N−1) Fₖ e^(i2πlk/N)

3. Test with f = [1, 0, 1, 0, 1, 0, 1, 0]. Compare `dft_manual(f)` with the built-in FFT (e.g. `np.fft.fft(f)`). Verify that `idft_manual(dft_manual(f))` recovers the original signal.

4. Implement `dft_matrix(N)` that returns the N×N unitary matrix W with Wₖₗ = (1/√N) e^(−i2πkl/N) (so W W^H = I). For a real signal f of length N=8, compute F_matrix = W f and compare with `fft(f) / sqrt(N)`. Verify unitarity: W W^H ≈ I.

*If time:* Compare runtimes of manual DFT vs FFT for N = 8, 16, 32, 64, 128 (you should see O(N²) vs O(N log N)).

---

## Task 3 (20–25 min): FFT properties and spectra

*Aligns with Lecture Section 3.*

Verify linearity, shifting, and Parseval's theorem using the built-in FFT, and implement fftshift so the zero frequency is at the centre.

**Step-by-step instructions:**

1. Verify numerically that FFT(a f₁ + b f₂) = a·FFT(f₁) + b·FFT(f₂) using f₁ = sin(2π·3·t), f₂ = cos(2π·3·t) with 64 samples and a = 2, b = 3; the maximum absolute difference should be near machine precision.

2. Create a test signal f(t) = sin(2π·3·t) with 64 samples. Shift it in time (e.g. circular shift by τ = 10). Compute the FFT of original and shifted signals and verify the shifting property: ℱ{f_shifted}(k) = e^(−i2πkτ/N) ℱ{f}(k). Magnitude |F| should be unchanged; phase differs by the phase factor.

3. For a real signal f of length N, verify Parseval's theorem: Σₗ |fₗ|² = (1/N) Σₖ |Fₖ|² where F = FFT(f). Use e.g. f = sin(2π·3·t) with 64 samples.

4. Implement `fftshift_manual(F)` that centres the zero frequency: for 1D, swap the left and right halves of the array F. Test with f = sin(2π·3·t) (64 samples), F = FFT(f); compare `fftshift_manual(F)` with the built-in `fftshift(F)`. Optionally plot |F| before and after fftshift (zero frequency at centre).

---

## Task 4 (20–25 min): 1D and 2D applications

*Aligns with Lecture Section 4.*

Plot a 1D signal in time and frequency, and create a 2D pattern and view its 2D FFT.

**Step-by-step instructions:**

1. Create a 1D signal with a clear frequency, e.g. f(t) = sin(2π·3·t) with 64 samples on [0, 1). Compute the FFT and use `fftfreq` (or equivalent) to get the frequency axis. Apply fftshift to both the FFT result and the frequency axis so zero frequency is at the centre.

2. Plot time domain: f vs sample index (or t). Plot frequency domain: |F| vs frequency (after fftshift). Confirm the peak appears at the expected frequency (e.g. 3 for the above signal).

3. Create a simple 2D pattern (e.g. 64×64 checkerboard: alternating black/white blocks). Compute the 2D FFT with the built-in function (`fft2` or equivalent). Apply fftshift to the result for display.

4. Display the spatial domain (the 2D pattern, e.g. `imshow` or heatmap) and the frequency domain (magnitude of the 2D FFT after fftshift). Briefly interpret: checkerboard has sharp edges, so you expect energy at higher spatial frequencies.

*If time:* Reconstruct the Fourier series from coefficients (e.g. square wave with N=5 and N=10 harmonics) and plot vs the original; or apply a simple low-pass filter in the frequency domain and visualize the smoothed result.

---

## Testing Your Solutions

To verify your work, run the provided test suite. The tests check your implementations against expected results.

### 1. Setup

Stub files are in `stubs/` (`my_solution.py`, `my_solution.jl`, `my_solution.m`). Copy the stub for your language into the lab folder (same level as `tests/`) and name it `my_solution.[py|jl|m]`, then implement the functions.

Ensure your solution file is in the `2-Transforms/lab/` folder:
- **Python:** `my_solution.py`
- **Julia:** `my_solution.jl`
- **MATLAB:** One file `my_solution.m` that defines `sol = my_solution()` returning a struct of function handles (e.g. `sol.inner_product`, `sol.dft_manual`, …). You can return only the fields you have implemented; tests will skip the rest.

### 2. Running Tests

#### Python
```bash
cd 2-Transforms/lab
pytest tests/test_python.py -v -s
```

#### Julia
```bash
cd 2-Transforms/lab
julia tests/test_julia.jl
```

#### MATLAB
```matlab
cd('path/to/2-Transforms/lab')
run('tests/test_matlab.m')
```

### 3. Understanding Output

- **Pass:** All checks succeeded.
- **Fail:** The output shows which function failed and the difference from the expected result.
- **Skipped:** Tests for functions not yet implemented are skipped.
- **Function names and signatures** must match exactly (e.g. `inner_product(f, g, a, b, n)`, `fourier_basis(n, t)`, `fourier_coefficient(f, n, a, b, n_points)`, `dft_manual(f)`, `idft_manual(F)`, `dft_matrix(N)`, `fftshift_manual(F)`).

---

## Common pitfalls

- **inner_product / fourier_coefficient:** Integrate over [a,b] with enough points (e.g. Riemann sum with `n` points); use the conjugate in ⟨f, g⟩ = ∫ f ḡ and in cₙ = ⟨f, eₙ⟩ (so e^(−i2πnt) in the coefficient).
- **dft_matrix:** Use the **unitary** convention: Wₖₗ = (1/√N) e^(−i2πkl/N) so that W W^H = I. The test compares W f with `fft(f) / sqrt(N)`.
- **fftshift_manual:** For 1D, swap the left and right halves of the array (zero frequency moves to the centre). Match your language's built-in `fftshift` for the test.

---

## Additional Challenges (Optional)

1. **Gibbs phenomenon:** Compute the Fourier series for the square wave with N = 1, 3, 5, 10 harmonics and plot; observe the overshoot near discontinuities.
2. **Differentiation via FFT:** Use ℱ{f′} = iω ℱ{f} to compute the derivative of a smooth function via FFT and compare with finite-difference or analytical derivative.
3. **Uncertainty principle:** Show that a narrow Gaussian in time has a wide spectrum in frequency.
4. **Parseval on noise:** Verify energy conservation (Parseval) for a random noise signal.
5. **Simple recursive FFT** (for N = 2ᵏ) or **2D low-pass filtering** (zero high frequencies in 2D FFT, inverse FFT, visualize).
