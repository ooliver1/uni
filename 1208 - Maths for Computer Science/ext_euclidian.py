def extended_euclidian(a: int, b: int) -> tuple[int, int, int]:
    """Returns (d,s,t) such that d = gcd(a,b) and d = sa + tb."""

    if b == 0:
        return (a, 1, 0)

    d, s, t = extended_euclidian(b, a % b)
    return (d, t, s - (a // b) * t)


def multiplicative_inverse(a: int, b: int) -> int:
    """The multiplicative inverse of a mod b such that (a * x) mod b = 1."""

    d, s, _ = extended_euclidian(a, b)
    if d != 1:
        raise ValueError(f"{a} and {b} are not coprime.")
    # s may be negative so we need to return the positive remainder
    return s % b


if __name__ == "__main__":
    print(extended_euclidian(a=10, b=7))
    print(multiplicative_inverse(a=10, b=7))
    print(multiplicative_inverse(a=7, b=880))

    inv = multiplicative_inverse(a=7, b=880)
    print("(7 * x) mod 880 = 1:", (7 * inv) % 880 == 1)
