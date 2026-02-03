# Unit tests for Complex Numbers Lab - Julia
# Run with: julia test_julia.jl

using Test
using LinearAlgebra

# Include solution functions (students should implement these)
# We try to include 'my_solution.jl' from the parent directory first.
# If not found, we fall back to the reference solution.
student_solution = joinpath(@__DIR__, "..", "my_solution.jl")
ref_solution = joinpath(@__DIR__, "..", "solutions", "julia_solution.jl")

if isfile(student_solution)
    println("Testing student solution: my_solution.jl")
    include(student_solution)
elseif isfile(ref_solution)
    println("Notice: 'my_solution.jl' not found. Testing reference solution 'solutions/julia_solution.jl'.")
    include(ref_solution)
else
    error("Could not find 'my_solution.jl' or reference solution.")
end

@testset "Basic Operations" begin
    @testset "Exercise 1.2: Complex Arithmetic" begin
        z1 = 3 + 4im
        z2 = 1 + 2im
        
        # Test addition
        result = complex_add(z1, z2)
        expected = z1 + z2
        @test abs(result - expected) < 1e-10
        
        # Test subtraction
        result = complex_subtract(z1, z2)
        expected = z1 - z2
        @test abs(result - expected) < 1e-10
        
        # Test multiplication
        result = complex_multiply(z1, z2)
        expected = z1 * z2
        @test abs(result - expected) < 1e-10
    end
    
    @testset "Exercise 1.3: Conjugate and Modulus" begin
        z = 3 + 4im
        
        # Test conjugate
        result = complex_conjugate(z)
        expected = conj(z)
        @test abs(result - expected) < 1e-10
        
        # Test modulus
        result = complex_modulus(z)
        expected = abs(z)
        @test abs(result - expected) < 1e-10
        
        # Test relationship: z * z* = |z|^2
        z_conj = complex_conjugate(z)
        z_mod = complex_modulus(z)
        @test abs(real(z * z_conj) - z_mod^2) < 1e-10
        
        # Test with another number
        z2 = 5 - 12im
        result2 = complex_conjugate(z2)
        expected2 = conj(z2)
        @test abs(result2 - expected2) < 1e-10
        
        result2_mod = complex_modulus(z2)
        expected2_mod = abs(z2)
        @test abs(result2_mod - expected2_mod) < 1e-10
    end
end

@testset "Polar Coordinates" begin
    @testset "Exercise 2.1: Rectangular to Polar" begin
        test_cases = [
            (3 + 4im, 5.0, 0.927),      # First quadrant
            (-3 + 4im, 5.0, 2.214),     # Second quadrant
            (-3 - 4im, 5.0, -2.214),    # Third quadrant
            (3 - 4im, 5.0, -0.927)      # Fourth quadrant
        ]
        
        for (z, expected_r, expected_phi) in test_cases
            r, phi = rectangular_to_polar(z)
            @test abs(r - expected_r) < 0.01
            @test abs(phi - expected_phi) < 0.01
        end
    end
    
    @testset "Exercise 2.2: Polar to Rectangular" begin
        test_cases = [
            (5.0, π/4),
            (2.0, π/3),
            (3.0, 2π/3)
        ]
        
        for (r, phi) in test_cases
            z = polar_to_rectangular(r, phi)
            # Verify it's on the correct circle
            @test abs(abs(z) - r) < 1e-10
            angle_diff = abs(angle(z) - phi)
            @test angle_diff < 1e-10 || abs(angle_diff - 2π) < 1e-10
        end
    end
    
    @testset "Exercise 2.2: Inverse Operations" begin
        z_original = 3 + 4im
        r, phi = rectangular_to_polar(z_original)
        z_reconstructed = polar_to_rectangular(r, phi)
        @test abs(z_original - z_reconstructed) < 1e-10
    end
    
    @testset "Exercise 2.3: Euler's Formula" begin
        phi = range(0, 2π, length=100)
        euler_form = cos.(phi) .+ im .* sin.(phi)
        exp_form = exp.(im .* phi)
        max_diff = maximum(abs.(euler_form .- exp_form))
        @test max_diff < 1e-10
    end
    
    @testset "Exercise 2.3: Euler's Identity" begin
        euler_identity = exp(im * π) + 1
        @test abs(euler_identity) < 1e-10
    end
end

@testset "Complex Operations" begin
    @testset "Exercise 3.1: Complex Division" begin
        test_cases = [
            (3 + 4im, 1 + 2im),
            (5 - 3im, 2 + 1im)
        ]
        
        for (z1, z2) in test_cases
            result = complex_divide(z1, z2)
            expected = z1 / z2
            @test abs(result - expected) < 1e-10
        end
    end
    
    @testset "Exercise 3.1: Division by Zero" begin
        z1 = 3 + 4im
        z2 = 0 + 0im
        @test_throws ArgumentError complex_divide(z1, z2)
    end
    
    @testset "Exercise 3.2: Powers using de Moivre" begin
        test_cases = [
            (1 + 1im, 4),
            (1 + sqrt(3)*im, 3),
            (2 + 2im, 5)
        ]
        
        for (z, n) in test_cases
            result = complex_power_de_moivre(z, n)
            expected = z^n
            @test abs(result - expected) < 1e-10
        end
    end
    
    @testset "Exercise 3.3: Roots of Unity" begin
        for n in [4, 6, 8]
            roots = roots_of_unity(n)
            @test length(roots) == n
            
            # Verify each root raised to n-th power equals 1
            for root in roots
                @test abs(root^n - 1) < 1e-10
            end
            
            # Verify sum equals 0 (for n > 1)
            if n > 1
                root_sum = sum(roots)
                @test abs(root_sum) < 1e-10
            end
        end
    end
end

@testset "Applications" begin
    @testset "Exercise 5.1: Sinusoid to Phasor" begin
        test_cases = [
            (5.0, π/4),
            (3.0, π/6),
            (4.0, -π/3)
        ]
        
        for (A, phi) in test_cases
            phasor = sinusoid_to_phasor(A, phi)
            @test abs(abs(phasor) - A) < 1e-10
            angle_diff = abs(angle(phasor) - phi)
            @test angle_diff < 1e-10 || abs(angle_diff - 2π) < 1e-10
        end
    end
    
    @testset "Exercise 5.1: Phasor to Sinusoid" begin
        A = 5.0
        phi = π/4
        omega = 2π
        t = collect(range(0, 2, length=1000))
        
        phasor = sinusoid_to_phasor(A, phi)
        reconstructed = phasor_to_sinusoid(phasor, omega, t)
        original = A .* cos.(omega .* t .+ phi)
        
        max_diff = maximum(abs.(reconstructed .- original))
        @test max_diff < 1e-10
    end
    
    @testset "Exercise 5.2: Add Sinusoids using Phasors" begin
        A1, phi1 = 3.0, π/6  # 30 degrees
        A2, phi2 = 4.0, π/3  # 60 degrees
        omega = 2π
        t = collect(range(0, 2, length=1000))
        
        sum_phasor, A3, phi3 = add_sinusoids_phasor(A1, phi1, A2, phi2, omega, t)
        
        # Verify by direct addition
        a_t = A1 .* cos.(omega .* t .+ phi1)
        b_t = A2 .* cos.(omega .* t .+ phi2)
        direct_sum = a_t .+ b_t
        
        max_diff = maximum(abs.(sum_phasor .- direct_sum))
        @test max_diff < 1e-10
        
        # Verify amplitude and phase are reasonable
        @test A3 > 0
        @test -π <= phi3 <= π
    end
end

println("\n" * "="^60)
println("All tests completed!")
println("="^60)
