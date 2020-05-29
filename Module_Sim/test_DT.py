from montmult import *

def add(P1_x, P1_y, P2_x, P2_y, prime, mont):
    if not mont:
        lam = ModDiv((P2_y - P1_y)%prime, (P2_x - P1_x)%prime, prime, 32)
        lam = lam % prime
        # print("lam:", lam)
    else:
        lam, _ = MonDiv((P2_y - P1_y)%prime, (P2_x - P1_x)%prime, prime, 32)
        lam = lam % prime
        # print("lam_mont:", lam)
        # print("lam:", to_reg(lam, prime))
    
    # print("lam:", lam)
    if not mont:
        x3 = ((lam*lam)%prime - P1_x - P2_x) % prime
        y3 = ((lam*((P1_x - x3)%prime))%prime - P1_y) % prime
    else:
        s = MonMul(lam, lam, prime, 32)
        x3 = (s-P1_x-P2_x) %prime
        s = MonMul(lam, (P1_x - x3)%prime, prime, 32)
        y3 = (s-P1_y)%prime
    # print("x3:", x3, "y3:", y3)
    return x3, y3

def double(P1_x, P1_y, a, prime, mont):
    # print('')
    if not mont:
        lam = ModDiv((3*P1_x*P1_x + a)%prime, (2*P1_y)%prime, prime, 32)
        # print("s:", (3*P1_x*P1_x)%prime)
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
    prime = 3309607849
    px = 2544538276
    py = 2425451850
    a = 1069626724
    key = 1093670752
    print("prime:", prime)
    print("px:", px)
    print("py:", py)
    print("a:", a)
    print("key:",key)
    a_mont = to_mont(a, prime)
    px_mont = to_mont(px, prime)
    py_mont = to_mont(py, prime)
    print("px mont:", px_mont, hex(px_mont)[2:])
    print("py_mont:", py_mont, hex(py_mont)[2:])
    print("a mont:", a_mont, hex(a_mont)[2:])
    print("key binary:", bin(key)[2:])
    result_x_mont = 0
    result_y_mont = 0
    key_arr = []
    while key is not 0:
        key_arr.append(key&1)
        key = key >> 1
    # print(key_arr)
    # print(len(key_arr))
    for x in range(len(key_arr)-1, -1, -1):
        print("key array x:", key_arr[x])
        if key_arr[x] == 1:
            if result_x_mont == 0 and result_y_mont == 0:
                result_x_mont = px_mont
                result_y_mont = py_mont
            else:
                double_x, double_y = double(result_x_mont, result_y_mont, a_mont, prime, True)
                # print("double_x_mont:", double_x)
                # print("double y_mont:", double_y)
                # print("double_x:", to_reg(double_x, prime))
                # print("double_y:", to_reg(double_y, prime))
                result_x_mont, result_y_mont = add(double_x, double_y, px_mont, py_mont, prime, True)
        else:
            result_x_mont, result_y_mont = double(result_x_mont, result_y_mont, a_mont, prime, True)
        print("result x_mont:", result_x_mont, "   hex:", hex(result_x_mont)[2:])
        print("result y_mont:", result_y_mont, "   hex:", hex(result_y_mont)[2:])
        temp_x = to_reg(result_x_mont, prime)
        temp_y = to_reg(result_y_mont, prime)
        print("result_x", temp_x, "   hex:", hex(temp_x)[2:])
        print("result_y", temp_y, "   hex:", hex(temp_y)[2:])
        print("")

    result_x = to_reg(result_x_mont, prime)
    result_y = to_reg(result_y_mont, prime)
    print("result_x", result_x, "   hex:", hex(result_x)[2:])
    print("result_y", result_y, "   hex:", hex(result_y)[2:])

def test():
    prime = 3309607849
    Px = 2544538276
    Py = 2425451850
    a = 1069626724
    key = 1093670752
    a_mont = to_mont(a, prime)
    px_mont = to_mont(Px, prime)
    py_mont = to_mont(Py, prime)
    print("px mont:", px_mont, hex(px_mont)[2:])
    print("py_mont:", py_mont, hex(py_mont)[2:])
    print("a mont:", a_mont, hex(a_mont)[2:])
    print("")

    double_x, double_y = double(Px, Py, a, prime, False)
    print("double_x:", double_x)
    print("double_y:", double_y)
    print('')

    double_x_mont, double_y_mont = double(px_mont, py_mont, a_mont, prime, True)
    print("double_x_mont:", double_x_mont)
    print("double_y_mont:", double_y_mont)
    print("")

    trans_x = to_reg(double_x_mont, prime)
    trans_y = to_reg(double_y_mont, prime)
    print("trans_double_x:", trans_x)
    print("trans_double_y:", trans_y)
    print("")

    triple_x_mont, triple_y_mont = add( px_mont, py_mont, double_x_mont, double_y_mont, prime, True)
    print("triple_x_mont:", triple_x_mont)
    print("triple_y_mont:", triple_y_mont)
    print("")

    triple_x_mont, triple_y_mont = add(double_x_mont, double_y_mont, px_mont, py_mont, prime, True)
    print("triple_x_mont:", triple_x_mont)
    print("triple_y_mont:", triple_y_mont)
    print("")

    trans_x = to_reg(triple_x_mont, prime)
    trans_y = to_reg(triple_y_mont, prime)
    print("triple_trans_x:", trans_x)
    print("triple_trans_y:", trans_y)
    print('')

    triple_x, triple_y = add(double_x, double_y, Px, Py, prime, False)
    print("triple_x:", triple_x)
    print("triple_y:", triple_y)

if __name__ == '__main__':
    main()