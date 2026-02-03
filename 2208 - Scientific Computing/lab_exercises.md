# Complex Numbers - Lab Exercises

**Languages:** Python, Julia, or MATLAB (choose one or explore multiple)

This lab provides hands-on practice with complex numbers, covering basic operations, conversions, visualizations, and applications. Exercises are organized by topic with progressive difficulty within each section.

---

## Setup

### Python
```python
import numpy as np
import matplotlib.pyplot as plt
import cmath
```

### Julia
```julia
using LinearAlgebra
using Plots
```

### MATLAB
```matlab
% All complex number operations are built-in
```

---

## Topic 1: Basic Operations (20 minutes)

### Exercise 1.1: Create Complex Numbers (Easy - 5 min)

Create the following complex numbers in your chosen language:
- $z_1 = 3 + 4i$
- $z_2 = -2 + 5i$
- $z_3 = 1 - 3i$
- $z_4 = -4 - 2i$

**Tasks:**
1. Create each number using the standard notation for your language
2. Print each number
3. Extract and print the real and imaginary parts of each number

**Expected output format:**
```
z1 = 3+4i, Re(z1) = 3, Im(z1) = 4
```

---

### Exercise 1.2: Implement Basic Arithmetic Functions (Medium - 10 min)

Implement functions to perform basic arithmetic operations on complex numbers. While your language likely has built-in operations, implement these manually to understand the underlying mathematics.

**Tasks:**
1. Implement `complex_add(z1, z2)` that returns $z_1 + z_2$ using the formula:
   $$z_1 + z_2 = (x_1 + x_2) + (y_1 + y_2)i$$
   
2. Implement `complex_subtract(z1, z2)` that returns $z_1 - z_2$

3. Implement `complex_multiply(z1, z2)` that returns $z_1 \times z_2$ using the formula:
   $$z_1 z_2 = (x_1x_2 - y_1y_2) + (x_1y_2 + y_1x_2)i$$

4. Test your functions with:
   - $z_1 = 3 + 4i$, $z_2 = 1 + 2i$
   - Compare your results with built-in operations

**Verification:**
- Your manual implementations should match the built-in operations (within floating-point precision)

---

### Exercise 1.3: Complex Conjugate and Modulus (Easy - 5 min)

**Tasks:**
1. For $z = 3 + 4i$:
   - Compute the conjugate $\overline{z} = z^*$
   - Compute the modulus $|z| = \sqrt{x^2 + y^2}$
   - Verify that $z \cdot z^* = |z|^2$

2. For $z = 5 - 12i$:
   - Compute the conjugate and modulus
   - Verify the relationship $z \cdot z^* = |z|^2$

3. Create a function `complex_conjugate(z)` that returns the conjugate
4. Create a function `complex_modulus(z)` that returns the modulus

**Note:** Use built-in functions to verify your results, but also implement manually to understand the operations.

---

## Topic 2: Polar Coordinates (25 minutes)

### Exercise 2.1: Convert Rectangular to Polar (Medium - 10 min)

**Tasks:**
1. Implement a function `rectangular_to_polar(z)` that:
   - Takes a complex number in rectangular form $z = x + yi$
   - Returns the modulus $r = |z|$ and argument $\phi = \arg(z)$
   - Handles all four quadrants correctly

2. Test with the following numbers:
   - $z_1 = 3 + 4i$ (first quadrant)
   - $z_2 = -3 + 4i$ (second quadrant)
   - $z_3 = -3 - 4i$ (third quadrant)
   - $z_4 = 3 - 4i$ (fourth quadrant)

3. Print results in both radians and degrees

**Expected output format:**
```
z = 3+4i: r = 5.000, φ = 0.927 rad (53.1°)
```

**Hint:** Use `atan2(y, x)` or your language's equivalent to handle quadrants correctly.

---

### Exercise 2.2: Convert Polar to Rectangular (Medium - 8 min)

**Tasks:**
1. Implement a function `polar_to_rectangular(r, phi)` that:
   - Takes modulus $r$ and argument $\phi$ (in radians)
   - Returns the complex number in rectangular form: $z = r(\cos\phi + i\sin\phi)$

2. Test with:
   - $r = 5$, $\phi = \pi/4$ (45°)
   - $r = 2$, $\phi = \pi/3$ (60°)
   - $r = 3$, $\phi = 2\pi/3$ (120°)

3. Verify that `polar_to_rectangular` and `rectangular_to_polar` are inverse operations:
   - Start with a complex number
   - Convert to polar
   - Convert back to rectangular
   - Check that the result matches the original (within numerical precision)

---

### Exercise 2.3: Verify Euler's Formula Numerically (Medium - 7 min)

**Tasks:**
1. For angles $\phi$ from $0$ to $2\pi$ (use at least 100 points):
   - Compute $e^{i\phi}$ using Euler's formula: $e^{i\phi} = \cos\phi + i\sin\phi$
   - Compute $e^{i\phi}$ using the exponential function
   - Compare the two results

2. Calculate the maximum difference between the two methods

3. Verify Euler's identity: $e^{i\pi} + 1 = 0$
   - Compute $e^{i\pi}$
   - Add 1
   - Check if the result is close to 0 (within numerical precision)

4. Plot $e^{i\phi}$ for $\phi \in [0, 2\pi]$ on the complex plane (should be a unit circle)

**Expected result:** Maximum difference should be on the order of machine precision ($\sim 10^{-15}$ or smaller).

---

## Topic 3: Complex Operations (30 minutes)

### Exercise 3.1: Implement Division Using Conjugate (Medium - 10 min)

**Tasks:**
1. Implement a function `complex_divide(z1, z2)` that performs division using the conjugate method:
   $$\frac{z_1}{z_2} = \frac{z_1 \overline{z_2}}{z_2 \overline{z_2}} = \frac{z_1 \overline{z_2}}{|z_2|^2}$$

2. Test with:
   - $z_1 = 3 + 4i$, $z_2 = 1 + 2i$
   - $z_1 = 5 - 3i$, $z_2 = 2 + i$

3. Compare your results with built-in division

4. Handle the edge case: what happens when $z_2 = 0$? (Add appropriate error handling)

5. **Polar Division**:
   - Compute $r_1, \phi_1$ and $r_2, \phi_2$
   - Compute result $r = r_1/r_2$ and $\phi = \phi_1 - \phi_2$
   - Convert back to rectangular and compare with the previous result


---

### Exercise 3.2: Powers Using de Moivre's Theorem (Hard - 12 min)

**Tasks:**
1. Implement a function `complex_power_de_moivre(z, n)` that computes $z^n$ using de Moivre's theorem:
   - Convert $z$ to polar form: $z = r e^{i\phi}$
   - Compute $z^n = r^n e^{in\phi} = r^n(\cos(n\phi) + i\sin(n\phi))$

2. Test with:
   - $(1 + i)^4$ (should equal $-4$)
   - $(1 + \sqrt{3}i)^3$ (should equal $-8$)
   - $(2 + 2i)^5$

3. Compare results with direct computation $z^n$ using built-in operations

4. Verify de Moivre's theorem for fractional powers (roots):
   - Compute the $n$-th roots of unity: $z^n = 1$
   - For $n = 4$, find all 4 roots

**Hint:** For $n$-th roots, use: $z_k = \sqrt[n]{r} e^{i(\phi + 2\pi k)/n}$ for $k = 0, 1, \ldots, n-1$

---

### Exercise 3.3: Roots of Unity (Hard - 8 min)

**Tasks:**
1. Implement a function `roots_of_unity(n)` that returns all $n$-th roots of unity:
   $$z_k = e^{2\pi ik/n} = \cos\left(\frac{2\pi k}{n}\right) + i\sin\left(\frac{2\pi k}{n}\right)$$
   for $k = 0, 1, \ldots, n-1$

2. Compute and print:
   - 4th roots of unity
   - 6th roots of unity
   - 8th roots of unity

3. Verify that:
   - Each root raised to the $n$-th power equals 1
   - The sum of all roots equals 0 (for $n > 1$)

4. Plot the roots on the complex plane (they should form a regular $n$-gon on the unit circle)

---

## Topic 4: Visualization (25 minutes)

### Exercise 4.1: Plot Complex Numbers on Argand Diagram (Medium - 8 min)

**Tasks:**
1. Create a function `plot_argand_diagram(complex_numbers, labels)` that:
   - Takes a list/array of complex numbers
   - Plots them on an Argand diagram (complex plane)
   - Labels each point
   - Draws axes and grid

2. Plot the following numbers:
   - $z_1 = 3 + 4i$
   - $z_2 = -2 + 3i$
   - $z_3 = -1 - 2i$
   - $z_4 = 2 - 3i$

3. Add vectors from the origin to each point

4. Use different colors for each point

---

### Exercise 4.2: Scalar Product and Angles (Medium - 10 min)

The scalar product of two complex numbers (treated as vectors) is defined as:
$$\langle z_1, z_2 \rangle = \text{Re}(z_1 \overline{z_2})$$

This relates to the angle $\theta$ between them: $\langle z_1, z_2 \rangle = |z_1| |z_2| \cos \theta$.

**Tasks:**
1. Implement `complex_scalar_product(z1, z2)`.
2. Calculate the scalar product of $z_1 = 3+4i$ and $z_2 = 1+2i$.
3. Use the result to find the angle between these vectors in degrees.
4. Verify this matches the difference between their arguments ($\text{angle}(z_1) - \text{angle}(z_2)$).

---

### Exercise 4.3: Visualize Multiplication as Rotation (Medium - 10 min)

**Tasks:**
1. Start with a complex number $z = 2 + i$

2. Visualize the effect of multiplying by:
   - $i$ (rotation by $\pi/2$)
   - $-i$ (rotation by $-\pi/2$)
   - $e^{i\pi/4}$ (rotation by $\pi/4$)
   - $2$ (scaling by 2)

3. Create a plot showing:
   - The original vector $z$
   - Each transformed vector
   - Use different colors and labels

4. Verify that:
   - Multiplying by $i$ rotates by 90° counterclockwise
   - Multiplying by a real number scales the vector
   - Multiplying by $e^{i\phi}$ rotates by angle $\phi$

**Tip:** If using Jupyter/Python, try to animate this rotation using a loop and `plt.pause(0.1)` to see the vector spinning!

---

### Exercise 4.4: Plot Roots of Unity (Medium - 7 min)

**Tasks:**
1. Use your `roots_of_unity(n)` function from Exercise 3.3

2. Create a visualization that shows:
   - The unit circle
   - All $n$-th roots of unity for $n = 3, 4, 5, 6$
   - Each set of roots in a different color
   - Lines connecting consecutive roots (forming regular polygons)

3. Add labels showing the angle (in degrees) for each root

4. Verify visually that:
   - All roots lie on the unit circle
   - They form regular $n$-gons
   - They are evenly spaced

---

## Topic 5: Applications (20 minutes)

### Exercise 5.1: Represent Sinusoid as Phasor (Medium - 10 min)

**Tasks:**
1. Given a sinusoid $f(t) = A\cos(\omega t + \phi)$:
   - Represent it as a phasor: $F = A e^{i\phi}$
   - Implement a function `sinusoid_to_phasor(A, phi)` that returns the phasor

2. For the following sinusoids, find their phasor representation:
   - $f_1(t) = 5\cos(2\pi t + \pi/4)$
   - $f_2(t) = 3\cos(2\pi t + \pi/6)$
   - $f_3(t) = 4\cos(2\pi t - \pi/3)$

3. Reconstruct the sinusoids from the phasors:
   - Implement `phasor_to_sinusoid(phasor, omega, t)` that computes $\text{Re}(F e^{i\omega t})$
   - Plot the original and reconstructed sinusoids to verify they match

4. Plot the phasors on the complex plane (Argand diagram)

---

### Exercise 5.2: Add Two Sinusoids Using Phasors (Hard - 10 min)

**Tasks:**
1. Given two sinusoids with the same frequency:
   - $a(t) = A_1\cos(\omega t + \phi_1)$
   - $b(t) = A_2\cos(\omega t + \phi_2)$

2. Implement a function `add_sinusoids_phasor(A1, phi1, A2, phi2, omega, t)` that:
   - Converts each sinusoid to a phasor
   - Adds the phasors
   - Converts the result back to a sinusoid
   - Returns the sum: $c(t) = A_3\cos(\omega t + \phi_3)$

3. Test with:
   - $A_1 = 3$, $\phi_1 = \pi/6$ (30°), $A_2 = 4$, $\phi_2 = \pi/3$ (60°)
   - Frequency $\omega = 2\pi$ (1 Hz)

4. Verify your result by:
   - Plotting $a(t)$, $b(t)$, and their sum $a(t) + b(t)$
   - Plotting the result from phasor addition
   - Comparing the two (they should match)

5. Print the amplitude $A_3$ and phase $\phi_3$ of the resulting sinusoid

**Expected output:**
```
Sum: A = X.XX, φ = Y.YY° (or Y.YY rad)
```

---

## Testing Your Solutions
   
To verify your work, you can run the provided test suite. The tests check your implementations against expected results.

### 1. Setup
Ensure your solution file is named correctly and located in the `1-ComplexNumbers/lab/` folder (same level as this `lab_exercises.md` file):
- **Python:** `my_solution.py`
- **Julia:** `my_solution.jl`
- **MATLAB:** `my_solution.m`

### 2. Running Tests

#### Python
Run `pytest` from the terminal:
```bash
# Navigate to the lab directory
cd 1-ComplexNumbers/lab

# Run the tests
pytest tests/test_python.py -v
```

#### Julia
Run the test script using Julia:
```bash
# Navigate to the lab directory
cd 1-ComplexNumbers/lab

# Run the tests
julia tests/test_julia.jl
```

#### MATLAB
Run the test script from the MATLAB command window or terminal:
```matlab
% Run this command in the MATLAB console (assuming you are in the lab directory)
run('tests/test_matlab.m')
```

### 3. Understanding Output
- **Pass:** All checks succeeded. Great job!
- **Fail:** The output will show which function failed and the difference between your result and the expected one. Use this to debug your code.
- **Import Error:** If the tests complain about missing functions, check that:
  - Your file is named `my_solution.[py/jl/m]`
  - Your function names match *exactly* with the exercise instructions (e.g., `complex_add`, `sinusoid_to_phasor`).


---

## Additional Challenges (Optional)

If you finish early, try these:

1. **Complex Polynomial Roots:** Find all roots of $z^4 + 1 = 0$ and plot them
2. **Complex Exponential:** Visualize $e^z$ for $z$ in a rectangular region
3. **Mandelbrot Set:** Implement a simple Mandelbrot set visualization (iterating $z_{n+1} = z_n^2 + c$)
4. **Complex Functions:** Plot the real and imaginary parts of $f(z) = z^2$ or $f(z) = \sin(z)$
5. **Quaternions:** Implement a `Quaternion` class/struct ($q = a + bi + cj + dk$).
   - Define multiplication rules: $i^2=j^2=k^2=ijk=-1$.
   - Verify that multiplication is **not commutative** by showing $ij \neq ji$.
   - (Bonus) Show that $q \cdot q^{-1} = 1$.
