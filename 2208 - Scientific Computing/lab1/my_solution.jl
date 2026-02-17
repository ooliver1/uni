using LinearAlgebra
using Plots

# - $z_1 = 3 + 4i$
# - $z_2 = -2 + 5i$
# - $z_3 = 1 - 3i$
# - $z_4 = -4 - 2i$

function exercise1_1()
    z1 = 3 + 4im
    z2 = -2 + 5im
    z3 = 1 - 3im
    z4 = -4 - 2im

    numbers = [z1, z2, z3, z4]
    names = ["z1", "z2", "z3", "z4"]

    #z1 = 3+4i, Re(z1) = 3, Im(z1) = 4
    for (number, name) in zip(numbers, names)
        println("$name = $number, Re($name) = $(number.re), Im($name) = $(number.im)")
    end
end

function complex_add(z1::Complex, z2::Complex)::Complex
    return Complex(real(z1) + real(z2), imag(z1) + imag(z2))
end

function complex_subtract(z1::Complex, z2::Complex)::Complex
    return Complex(real(z1) - real(z2), imag(z1) - imag(z2))
end

function complex_multiply(z1::Complex, z2::Complex)::Complex
    return Complex(
        real(z1) * real(z2) - imag(z1) * imag(z2),
        real(z1) * imag(z2) + imag(z1) * real(z2)
    )
end

function exercise_1_2()
    z1 = 3 + 4im
    z2 = 1 + 2im

    # Test addition
    manual_sum = complex_add(z1, z2)
    builtin_sum = z1 + z2
    println("Addition: $z1 + $z2")
    println("  Manual: $manual_sum")
    println("  Built-in: $builtin_sum")
    println("  Match: $(abs(manual_sum - builtin_sum) < 1e-10)")

    # Test subtraction
    manual_diff = complex_subtract(z1, z2)
    builtin_diff = z1 - z2
    println("\nSubtraction: $z1 - $z2")
    println("  Manual: $manual_diff")
    println("  Built-in: $builtin_diff")
    println("  Match: $(abs(manual_diff - builtin_diff) < 1e-10)")

    # Test multiplication
    manual_prod = complex_multiply(z1, z2)
    builtin_prod = z1 * z2
    println("\nMultiplication: $z1 * $z2")
    println("  Manual: $manual_prod")
    println("  Built-in: $builtin_prod")
    println("  Match: $(abs(manual_prod - builtin_prod) < 1e-10)")
end

function complex_conjugate(z::Complex)::Complex
    return Complex(real(z), -imag(z))
end

function complex_modulus(z::Complex)::Complex
    return sqrt(real(z)^2 + imag(z)^2)
end

function exercise_1_3()
    # Test with z = 3 + 4i
    z = 3 + 4im
    z_conj = complex_conjugate(z)
    z_mod = complex_modulus(z)

    println("z = $z")
    println("  Conjugate z* = $z_conj (built-in: $(conj(z)))")
    println("  Modulus |z| = $(round(z_mod, digits=3)) (built-in: $(round(abs(z), digits=3)))")
    println("  z * z* = $(z * z_conj)")
    println("  |z|^2 = $(round(z_mod^2, digits=1))")
    println("  Verification: $(abs(real(z * z_conj) - z_mod^2) < 1e-10)")

    # Test with z = 5 - 12i
    z2 = 5 - 12im
    z2_conj = complex_conjugate(z2)
    z2_mod = complex_modulus(z2)

    println("\nz2 = $z2")
    println("  Conjugate z2* = $z2_conj (built-in: $(conj(z2)))")
    println("  Modulus |z2| = $(round(z2_mod, digits=3)) (built-in: $(round(abs(z2), digits=3)))")
    println("  z2 * z2* = $(z2 * z2_conj)")
    println("  |z2|^2 = $(round(z2_mod^2, digits=1))")
    println("  Verification: $(abs(real(z2 * z2_conj) - z2_mod^2) < 1e-10)")
end

