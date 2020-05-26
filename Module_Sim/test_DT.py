from montmult import *

def add(P1_x, P1_y, P2_x, P2_y, prime, mont):
    if not mont:
        lam = ModDiv((P2_y - P1_y)%prime, (P2_x - P1_x)%prime, prime, 32)
    else:
        lam, _ = MonDiv((P2_y - P1_y)%prime, (P2_x - P1_x)%prime, prime, 32)
    lam = lam % prime
    # print("lam:", lam)
    x3 = ((lam*lam)%prime - P1_x - P2_x) % prime
    y3 = ((lam*(P1_x - x3)) - P1_y) % prime
    # print("x3:", x3, "y3:", y3)
    return x3, y3

def double(P1_x, P1_y, a, prime, mont):
    print('')
    if not mont:
        lam = ModDiv((3*P1_x*P1_x + a)%prime, (2*P1_y)%prime, prime, 32)
        print("s:", (3*P1_x*P1_x)%prime)
    else:
        mont_3 = to_mont(3, prime)
        s = MonMul(P1_x, P1_x, prime, 32)
        s = MonMul(mont_3, s, prime, 32)
        mont_2 = to_mont(2, prime)
        s2 = MonMul(mont_2, P1_y, prime, 32)
        lam, _ = MonDiv((s + a)%prime, s2%prime, prime, 32)
    lam = lam % prime

    if mont:
        mont_2 = to_mont(2, prime)
        s = MonMul(lam, lam, prime, 32)
        s1 = MonMul(mont_2, P1_x, prime, 32)
        x3 = (s - s1)%prime
    else:
        x3 = ((lam*lam) - 2*P1_x)%prime
    # if mont:
        # print((lam*lam)%prime - 2*P1_x)
    if mont:
        s = (P1_x - x3)%prime
        s = MonMul(lam, s, prime, 32)
        y3 = (s - P1_y)%prime
    else:
        y3 = ((lam*(P1_x - x3)) - P1_y)%prime
    # print("x3:", x3, "y3:", y3)
    return x3, y3

def to_reg(P, prime):
    for i in range(32):
        if P & 1:
            P = (P + prime) >> 1
        else:
            P = P >> 1
    return P


def to_mont(P, prime):
    r = 2**32
    P_mont = (r * P) % prime 
    return P_mont

def main():
    prime = 2735389841
    a = 154459229
    px = 1272457263
    py = 2351779975
    a_mont = to_mont(a, prime)
    px_mont = to_mont(px, prime)
    py_mont = to_mont(py, prime)

    div = ModDiv(a, py, prime, 32)
    mont_div, _ = MonDiv(a_mont,py_mont,prime,32)
    mont_to_reg_div = to_reg(mont_div, prime)
    print("div:", div)
    print("mont_div:", mont_div)
    print("mont_to_reg_div:", mont_to_reg_div)

    double_px_mont, double_py_mont = double(px_mont, py_mont, a_mont, prime, True)
    double_px, double_py = double(px, py, a, prime, False)
    double_px_reg = to_reg(double_px_mont, prime)
    double_py_reg = to_reg(double_py_mont, prime)
    print("Mont:")
    print("    double_px_mont:", double_px_mont)
    print("    double_py_mont:", double_py_mont)
    print('')
    print("Reg:")
    print("    double_px", double_px)
    print("    double_py", double_py)
    print('')
    print("Mont to reg:")
    print("    double_px_reg:", double_px_reg)
    print("    double_py_reg:", double_py_reg)

if __name__ == '__main__':
    main()