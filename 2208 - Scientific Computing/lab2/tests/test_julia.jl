# Unit tests for Linear Transformations and Fourier Transforms Lab - Julia
# Run with: julia tests/test_julia.jl
#
# Tests only run for functions you have implemented. Missing functions are skipped
# with a short message so you can see your progress at any time.

using Test
using FFTW
using LinearAlgebra
using Random

const REQUIRED_NAMES = [
    :inner_product, :fourier_basis, :fourier_coefficient,
    :dft_manual, :idft_manual, :dft_matrix, :fftshift_manual
]

function _has(name::Symbol)
    return isdefined(Main, name)
end

function _skip_if_missing(names::Vector{Symbol})
    for n in names
        if !_has(n)
            println("Skipping: $n not implemented yet. Add it to your solution file (see lab_exercises.md).")
            @test_skip true
            return true
        end
    end
    return false
end

# Include solution: try my_solution first, then reference solution
student_solution = joinpath(@__DIR__, "..", "my_solution.jl")
ref_solution = joinpath(@__DIR__, "..", "solutions", "julia_solution.jl")

function _try_include(path, label)
    try
        include(path)
        return true
    catch e
        println(stderr, "Could not load ", label, ": ", e)
        println(stderr, "Check syntax and dependencies (FFTW, LinearAlgebra, QuadGK). See lab_exercises.md.")
        rethrow(e)
    end
end

if isfile(student_solution)
    println("Testing student solution: my_solution.jl")
    _try_include(student_solution, "my_solution.jl")
    solution_name = "my_solution.jl"
elseif isfile(ref_solution)
    println("Notice: 'my_solution.jl' not found. Testing reference solution 'solutions/julia_solution.jl'.")
    _try_include(ref_solution, "solutions/julia_solution.jl")
    solution_name = "solutions/julia_solution.jl"
else
    error("Could not find 'my_solution.jl' or reference solution.")
end

# Summary: implemented vs not implemented
implemented = [n for n in REQUIRED_NAMES if _has(n)]
not_impl = [n for n in REQUIRED_NAMES if !_has(n)]
println("Implemented: ", isempty(implemented) ? "(none)" : join(implemented, ", "))
if !isempty(not_impl)
    println("Not implemented: ", join(not_impl, ", "))
end
println()

@testset "Task 1: Functions as Linear Spaces and Fourier Basis" begin
    @testset "Task 1: Inner Product" begin
        _skip_if_missing([:inner_product]) && return
        f(t) = sin(2π * t)
        g(t) = cos(2π * t)
        ip = inner_product(f, g, 0, 1, 1000)
        @test abs(ip) < 0.01  # Should be approximately 0
    end

    @testset "Task 1: Linearity of inner product" begin
        _skip_if_missing([:inner_product]) && return
        f1(t) = sin(2π * t)
        f2(t) = cos(2π * t)
        g(t) = t
        a, b = 2.0, 3.0
        left = inner_product(t -> a*f1(t) + b*f2(t), g, 0, 1, 1000)
        right = a*inner_product(f1, g, 0, 1, 1000) + b*inner_product(f2, g, 0, 1, 1000)
        @test abs(left - right) < 1e-6
    end

    @testset "Task 1: Conjugate symmetry" begin
        _skip_if_missing([:inner_product]) && return
        f(t) = sin(2π * t)
        g(t) = cos(2π * t)
        ip_fg = inner_product(f, g, 0, 1, 1000)
        ip_gf = inner_product(g, f, 0, 1, 1000)
        @test abs(ip_fg - conj(ip_gf)) < 1e-10
    end

    @testset "Task 1: Fourier Basis Orthonormality" begin
        _skip_if_missing([:fourier_basis]) && return
        t = range(0, 1, length=1000)
        dt = 1.0 / 1000

        # Test <e_n, e_n> = 1
        for n in [-2, -1, 0, 1, 2]
            e_n = fourier_basis(n, t)
            ip = sum(e_n .* conj.(e_n)) * dt
            @test abs(ip - 1.0) < 0.01
        end

        # Test <e_n, e_m> = 0 for n != m
        e_0 = fourier_basis(0, t)
        e_1 = fourier_basis(1, t)
        ip = sum(e_0 .* conj.(e_1)) * dt
        @test abs(ip) < 0.01
    end

    @testset "Task 1: Fourier Coefficient" begin
        _skip_if_missing([:fourier_coefficient]) && return
        square_wave(t) = (mod.(t, 1) .< 0.5) .* 2 .- 1

        # DC component should be 0
        c_0 = fourier_coefficient(square_wave, 0, 0, 1, 1000)
        @test abs(c_0) < 0.01

        # First harmonic should be non-zero
        c_1 = fourier_coefficient(square_wave, 1, 0, 1, 1000)
        @test abs(c_1) > 0.1
    end
end

@testset "Task 2: Fourier Series, DFT, and FFT" begin
    @testset "Task 2: Manual DFT" begin
        _skip_if_missing([:dft_manual]) && return
        f = [1, 0, 1, 0, 1, 0, 1, 0]
        F_manual = dft_manual(f)
        F_fft = fft(f)

        @test maximum(abs.(F_manual - F_fft)) < 1e-10
    end

    @testset "Task 2: Manual IDFT" begin
        _skip_if_missing([:dft_manual, :idft_manual]) && return
        f = [1, 0, 1, 0, 1, 0, 1, 0]
        F = dft_manual(f)
        f_reconstructed = idft_manual(F)

        @test maximum(abs.(f - real.(f_reconstructed))) < 1e-10
    end

    @testset "Task 2: dft_matrix unitarity" begin
        _skip_if_missing([:dft_matrix]) && return
        N = 8
        W = dft_matrix(N)
        I_check = W * W'
        @test maximum(abs.(I_check - I(N))) < 1e-10
    end

    @testset "Task 2: dft_matrix vs FFT" begin
        _skip_if_missing([:dft_matrix]) && return
        N = 8
        f = [1.0, 0, 1, 0, 1, 0, 1, 0]
        W = dft_matrix(N)
        F_matrix = W * f
        F_fft_normalized = fft(f) / sqrt(N)
        @test maximum(abs.(F_matrix - F_fft_normalized)) < 1e-10
    end
end

@testset "Task 3: Properties of the Fourier Transform" begin
    @testset "Task 3: Linearity" begin
        N = 32
        t = (0:N-1) / N
        f1 = sin.(2π * 3 * t)
        f2 = cos.(2π * 3 * t)
        a, b = 2.0, 3.0

        F_linear = a * fft(f1) + b * fft(f2)
        F_combined = fft(a * f1 + b * f2)

        @test maximum(abs.(F_linear - F_combined)) < 1e-10
    end

    @testset "Task 3: Shifting Property" begin
        N = 64
        t = (0:N-1) / N
        f = sin.(2π * 3 * t)
        shift = 10

        f_shifted = circshift(f, shift)
        F = fft(f)
        F_shifted = fft(f_shifted)

        phase_factor = exp.(-2π * im * shift * (0:N-1) / N)
        F_theoretical = F .* phase_factor

        @test maximum(abs.(F_shifted - F_theoretical)) < 1e-10
        @test all(isapprox.(abs.(F), abs.(F_shifted), atol=1e-10))
    end

    @testset "Task 3: Parseval's Theorem" begin
        N = 64
        f = sin.(2π * 3 * (0:N-1) / N)
        F = fft(f)

        energy_time = sum(abs2.(f))
        energy_freq = sum(abs2.(F)) / N

        @test abs(energy_time - energy_freq) < 1e-10
    end

    @testset "Task 3: fftshift_manual" begin
        _skip_if_missing([:fftshift_manual]) && return
        N = 64
        f = sin.(2π * 3 * (0:N-1) / N)
        F = fft(f)

        F_shifted = fftshift(F)
        F_manual = fftshift_manual(F)

        @test maximum(abs.(F_shifted - F_manual)) < 1e-10
    end
end

@testset "Task 4: Applications (1D and 2D)" begin
    @testset "2D DFT separability" begin
        Random.seed!(42)
        N, M = 8, 8
        f_2d = randn(N, M)

        # In Julia FFTW, fft(A) on a matrix is the 2D FFT
        F_direct = fft(f_2d)
        F_rows = fft(f_2d, 1)
        F_separable = fft(F_rows, 2)

        @test maximum(abs.(F_direct - F_separable)) < 1e-10
    end

    @testset "2D fftshift center" begin
        Random.seed!(42)
        N, M = 32, 32
        f_2d = randn(N, M)

        F_2d = fft(f_2d)
        F_shifted = fftshift(F_2d)

        center = (N÷2 + 1, M÷2 + 1)
        @test abs(F_shifted[center[1], center[2]]) > 0
    end
end

# Progress summary at end (same style as DSP1/DSP2)
implemented = [n for n in REQUIRED_NAMES if _has(n)]
not_impl = [n for n in REQUIRED_NAMES if !_has(n)]
n_impl, n_total = length(implemented), length(REQUIRED_NAMES)
println("\n================================================")
println("Progress: $n_impl/$n_total functions implemented in $solution_name")
if !isempty(implemented)
    println("Implemented: ", join(implemented, ", "))
end
if !isempty(not_impl)
    println("Not yet: ", join(not_impl, ", "))
end
println("================================================")
println("\nAll tests completed!")
