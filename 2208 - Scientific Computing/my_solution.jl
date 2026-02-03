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