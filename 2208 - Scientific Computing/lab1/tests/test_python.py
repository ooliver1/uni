"""
Unit tests for Complex Numbers Lab - Python
Run with: pytest test_python.py -v
"""

import pytest
import numpy as np
import cmath
from typing import Tuple

# Import solution functions (students should implement these)
# We try to import from 'my_solution.py' in the parent directory first.
# If not found, we fall back to the reference solution (for internal testing).
import sys
import os

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, parent_dir)

try:
    from my_solution import (
        complex_add, complex_subtract, complex_multiply,
        complex_conjugate, complex_modulus,
        rectangular_to_polar, polar_to_rectangular,
        complex_divide, complex_power_de_moivre,
        roots_of_unity,
        sinusoid_to_phasor, phasor_to_sinusoid,
        add_sinusoids_phasor
    )
    print("Testing student solution: my_solution.py")
except ImportError:
    # Check if we are testing the reference solution
    solutions_dir = os.path.join(parent_dir, 'solutions')
    if os.path.exists(solutions_dir):
        sys.path.insert(0, solutions_dir)
        try:
            from python_solution import (
                complex_add, complex_subtract, complex_multiply,
                complex_conjugate, complex_modulus,
                rectangular_to_polar, polar_to_rectangular,
                complex_divide, complex_power_de_moivre,
                roots_of_unity,
                sinusoid_to_phasor, phasor_to_sinusoid,
                add_sinusoids_phasor
            )
            print("Notice: 'my_solution.py' not found. Testing reference solution 'solutions/python_solution.py'.")
        except ImportError:
            print("Error: Could not find 'my_solution.py' or reference solution.")
            sys.exit(1)
    else:
        print("Error: Could not find 'my_solution.py'. Please create it in the '1-ComplexNumbers/lab' directory.")
        sys.exit(1)


class TestBasicOperations:
    """Tests for Topic 1: Basic Operations"""
    
    def test_complex_add(self):
        """Test Exercise 1.2: Complex addition"""
        z1 = 3 + 4j
        z2 = 1 + 2j
        result = complex_add(z1, z2)
        expected = z1 + z2
        assert abs(result - expected) < 1e-10
    
    def test_complex_subtract(self):
        """Test Exercise 1.2: Complex subtraction"""
        z1 = 3 + 4j
        z2 = 1 + 2j
        result = complex_subtract(z1, z2)
        expected = z1 - z2
        assert abs(result - expected) < 1e-10
    
    def test_complex_multiply(self):
        """Test Exercise 1.2: Complex multiplication"""
        z1 = 3 + 4j
        z2 = 1 + 2j
        result = complex_multiply(z1, z2)
        expected = z1 * z2
        assert abs(result - expected) < 1e-10
    
    def test_complex_conjugate(self):
        """Test Exercise 1.3: Complex conjugate"""
        z = 3 + 4j
        result = complex_conjugate(z)
        expected = z.conjugate()
        assert abs(result - expected) < 1e-10
        
        z2 = 5 - 12j
        result2 = complex_conjugate(z2)
        expected2 = z2.conjugate()
        assert abs(result2 - expected2) < 1e-10
    
    def test_complex_modulus(self):
        """Test Exercise 1.3: Complex modulus"""
        z = 3 + 4j
        result = complex_modulus(z)
        expected = abs(z)
        assert abs(result - expected) < 1e-10
        
        z2 = 5 - 12j
        result2 = complex_modulus(z2)
        expected2 = abs(z2)
        assert abs(result2 - expected2) < 1e-10
    
    def test_conjugate_modulus_relationship(self):
        """Test Exercise 1.3: z * z* = |z|^2"""
        z = 3 + 4j
        z_conj = complex_conjugate(z)
        z_mod = complex_modulus(z)
        assert abs((z * z_conj).real - z_mod**2) < 1e-10


class TestPolarCoordinates:
    """Tests for Topic 2: Polar Coordinates"""
    
    def test_rectangular_to_polar(self):
        """Test Exercise 2.1: Rectangular to polar conversion"""
        test_cases = [
            (3 + 4j, 5.0, 0.927),      # First quadrant
            (-3 + 4j, 5.0, 2.214),     # Second quadrant
            (-3 - 4j, 5.0, -2.214),    # Third quadrant
            (3 - 4j, 5.0, -0.927)      # Fourth quadrant
        ]
        
        for z, expected_r, expected_phi in test_cases:
            r, phi = rectangular_to_polar(z)
            assert abs(r - expected_r) < 0.01
            assert abs(phi - expected_phi) < 0.01
    
    def test_polar_to_rectangular(self):
        """Test Exercise 2.2: Polar to rectangular conversion"""
        test_cases = [
            (5.0, np.pi/4),
            (2.0, np.pi/3),
            (3.0, 2*np.pi/3)
        ]
        
        for r, phi in test_cases:
            z = polar_to_rectangular(r, phi)
            # Verify it's on the correct circle
            assert abs(abs(z) - r) < 1e-10
            assert abs(cmath.phase(z) - phi) < 1e-10 or abs(cmath.phase(z) - phi + 2*np.pi) < 1e-10
    
    def test_polar_rectangular_inverse(self):
        """Test Exercise 2.2: Inverse operations"""
        z_original = 3 + 4j
        r, phi = rectangular_to_polar(z_original)
        z_reconstructed = polar_to_rectangular(r, phi)
        assert abs(z_original - z_reconstructed) < 1e-10
    
    def test_euler_formula(self):
        """Test Exercise 2.3: Euler's formula verification"""
        phi = np.linspace(0, 2*np.pi, 100)
        euler_form = np.cos(phi) + 1j * np.sin(phi)
        exp_form = np.exp(1j * phi)
        max_diff = np.max(np.abs(euler_form - exp_form))
        assert max_diff < 1e-10
    
    def test_euler_identity(self):
        """Test Exercise 2.3: Euler's identity e^(iπ) + 1 = 0"""
        euler_identity = np.exp(1j * np.pi) + 1
        assert abs(euler_identity) < 1e-10


class TestComplexOperations:
    """Tests for Topic 3: Complex Operations"""
    
    def test_complex_divide(self):
        """Test Exercise 3.1: Complex division using conjugate"""
        test_cases = [
            (3 + 4j, 1 + 2j),
            (5 - 3j, 2 + 1j)
        ]
        
        for z1, z2 in test_cases:
            result = complex_divide(z1, z2)
            expected = z1 / z2
            assert abs(result - expected) < 1e-10
    
    def test_complex_divide_by_zero(self):
        """Test Exercise 3.1: Division by zero error handling"""
        z1 = 3 + 4j
        z2 = 0 + 0j
        with pytest.raises(ValueError):
            complex_divide(z1, z2)
    
    def test_complex_power_de_moivre(self):
        """Test Exercise 3.2: Powers using de Moivre's theorem"""
        test_cases = [
            (1 + 1j, 4),
            (1 + np.sqrt(3)*1j, 3),
            (2 + 2j, 5)
        ]
        
        for z, n in test_cases:
            result = complex_power_de_moivre(z, n)
            expected = z**n
            assert abs(result - expected) < 1e-10
    
    def test_roots_of_unity(self):
        """Test Exercise 3.3: Roots of unity"""
        for n in [4, 6, 8]:
            roots = roots_of_unity(n)
            assert len(roots) == n
            
            # Verify each root raised to n-th power equals 1
            for root in roots:
                assert abs(root**n - 1) < 1e-10
            
            # Verify sum equals 0 (for n > 1)
            if n > 1:
                root_sum = sum(roots)
                assert abs(root_sum) < 1e-10


class TestApplications:
    """Tests for Topic 5: Applications"""
    
    def test_sinusoid_to_phasor(self):
        """Test Exercise 5.1: Sinusoid to phasor conversion"""
        test_cases = [
            (5.0, np.pi/4),
            (3.0, np.pi/6),
            (4.0, -np.pi/3)
        ]
        
        for A, phi in test_cases:
            phasor = sinusoid_to_phasor(A, phi)
            assert abs(abs(phasor) - A) < 1e-10
            assert abs(cmath.phase(phasor) - phi) < 1e-10 or abs(cmath.phase(phasor) - phi + 2*np.pi) < 1e-10
    
    def test_phasor_to_sinusoid(self):
        """Test Exercise 5.1: Phasor to sinusoid reconstruction"""
        A = 5.0
        phi = np.pi/4
        omega = 2*np.pi
        t = np.linspace(0, 2, 1000)
        
        phasor = sinusoid_to_phasor(A, phi)
        reconstructed = phasor_to_sinusoid(phasor, omega, t)
        original = A * np.cos(omega * t + phi)
        
        max_diff = np.max(np.abs(reconstructed - original))
        assert max_diff < 1e-10
    
    def test_add_sinusoids_phasor(self):
        """Test Exercise 5.2: Add sinusoids using phasors"""
        A1, phi1 = 3.0, np.pi/6  # 30 degrees
        A2, phi2 = 4.0, np.pi/3  # 60 degrees
        omega = 2*np.pi
        t = np.linspace(0, 2, 1000)
        
        sum_phasor, A3, phi3 = add_sinusoids_phasor(A1, phi1, A2, phi2, omega, t)
        
        # Verify by direct addition
        a_t = A1 * np.cos(omega * t + phi1)
        b_t = A2 * np.cos(omega * t + phi2)
        direct_sum = a_t + b_t
        
        max_diff = np.max(np.abs(sum_phasor - direct_sum))
        assert max_diff < 1e-10
        
        # Verify amplitude and phase are reasonable
        assert A3 > 0
        assert -np.pi <= phi3 <= np.pi


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
