from Base_Module import *
from montmult import *
from random import randint
import Crypto.Util.number as num
from test_DT import *
import Crypto
"""
module Top_ting(
    i_rst,
    i_clk,
    i_start,
    a,
    prime,
    Px,
    Py,
    k,
    kP);
"""
NUM_DATA = 10

class Top(Base_Module):
    def operate(self, inputs):
        # inputs array is a buffer for all inputs
        # read input only when valid
        for in_x in inputs:
            a, prime, Px, Py, key = in_x
            # for the first 8 cycles, read in a, prime, px, py, key 4 bits at a time
            a_bits = [(a>>(4*x))&15 for x in range(8)]
            prime_bits = [(prime>>(4*x))&15 for x in range(8)]
            Px_bits = [(Px>>(4*x))&15 for x in range(8)]
            Py_bits = [(Py>>(4*x))&15 for x in range(8)]
            key_bits = [(key>>(4*x))&15 for x in range(8)]
            # a = self.to_mont(a, prime)
            # Px = self.to_mont(Px, prime)
            # Py = self.to_mont(Py, prime)
            # print("To mont:")
            # print("    a:", a, hex(a)[2:])
            # print("   Px:", Px, hex(Px)[2:])
            # print("   Py:", Py, hex(Py)[2:])
            result_x, result_y = self.get_output(prime, Px, Py, a, key)
            print(result_x, result_y)
            for x in range(8):
                self.update_inputs([a_bits[x], prime_bits[x], Px_bits[x], Py_bits[x], key_bits[x]])
                self.update_outputs([result_x, result_y])
                self.update_done(0)
            self.update_valid(1)
            for x in range(7):
                self.update_valid(0)
            # 1 cycle of all input 0s and outputs
            self.update_valid(0)
            self.update_inputs(0)
            self.update_done(0)
            self.update_outputs([result_x, result_y])
        return
    def operate_fn(self):
        return

    def get_output(self, prime, Px, Py, a, key):
        result_x = 0
        result_y = 0
        # print(bin(key))
        for x in range(31,-1,-1):
            k_bit = (key>>x) & 1
            # print(x, k_bit)
            if k_bit == 0:
                if result_x == 0 and result_y == 0:
                    continue
                else:
                    result_x, result_y = self.double(result_x, result_y, a, prime)
            if k_bit == 1:
                if result_x == 0 and result_y == 0:
                    result_x = Px
                    result_y = Py
                else:
                    result_x, result_y = self.double(result_x, result_y, a, prime)
                    result_x, result_y = self.add(Px, Py, result_x, result_y, prime)
            # print(result_x, result_y)
            # print("")
        # from montgomery field to regular
        # print("In Mont field:", result_x, result_y)
        result_x = int(result_x)
        result_y = int(result_y)
        # result_x = self.to_reg(int(result_x), prime)
        # result_y = self.to_reg(int(result_y), prime)
        return result_x, result_y

    def add(self, P1_x, P1_y, P2_x, P2_y, prime):
        lam = ModDiv((P2_y - P1_y)%prime, (P2_x - P1_x)%prime, prime, 32)
        # print(P2_y - P1_y, (P2_y - P1_y)%prime)
        # print(P2_x - P1_x, (P2_x - P1_x)%prime)
        # lam, _ = MonDiv((P2_y - P1_y)%prime, (P2_x - P1_x)%prime, prime, 32)
        lam = lam % prime
        # print("lam:", lam)
        x3 = ((lam*lam)%prime - P1_x - P2_x) % prime
        y3 = ((lam*(P1_x - x3)) - P1_y) % prime
        # print("x3:", x3, "y3:", y3)
        return x3, y3
    
    def double(self, P1_x, P1_y, a, prime):
        lam = ModDiv((3*P1_x*P1_x + a)%prime, (2*P1_y)%prime, prime, 32)
        # lam, _ = MonDiv((3*P1_x*P1_x + a)%prime, (2*P1_y)%prime, prime, 32)
        lam = lam % prime
        # print("lam:", lam)
        x3 = ((lam*lam) - 2*P1_x)%prime
        y3 = ((lam*(P1_x - x3)) - P1_y)%prime
        # print("x3:", x3, "y3:", y3)
        return x3, y3
    
    def to_reg(self, P, prime):
        for i in range(32):
            if P & 1:
                P = (P + prime) >> 1
            else:
                P = P >> 1
        return P


    def to_mont(self, P, prime):
        r = 2**32
        P_mont = (r * P) % prime 
        return P_mont

    
    
def main():
    # declare input and output ports except clock and reset
    # sequential always block should be negative dege reset (reset == 0)
    input_ports = [
        Input_port("a", 4),
        Input_port("prime", 4),
        Input_port("px", 4),
        Input_port("py", 4),
        Input_port("key", 4),
    ]

    output_ports = [
        Output_port("result_x", 32),
        Output_port("result_y", 32)
    ]

    done_port = Done_port("done", 1)

    valid_port = Valid_port("start", 1)

    # Initialize GFAU
    top = Top(input_ports, output_ports, valid_port, done_port, "../sim_data/top", "Top")

    # Create Inputs
    inputs = []
    Px_list = []
    Py_list = []
    a_list = []
    key_list = []
    prime_list = []
    double_list = []
    triple_list = []

    for i in range(NUM_DATA):
        prime = num.getPrime(32)
        Px = randint(0, 2**32)
        Py = randint(0, 2**32)
        a = randint(0, 2**32)
        key = randint(2**31, 2**32)
        Px_list.append(Px)
        Py_list.append(Py)
        a_list.append(a)
        key_list.append(key)
        prime_list.append(prime)
        # prime = 3309607849
        # Px = 2544538276
        # Py = 2425451850
        # a = 1069626724
        # key = 1093670752
        print("prime:", prime, hex(prime)[2:])
        print("a:", a, hex(a)[2:])
        print("px:", Px, hex(Px)[2:])
        print("py:", Py, hex(Py)[2:])
        print("key:",key, hex(key)[2:])
        """
        result_x = 2421997543
        result_y = 611281146
        """
        double_x, double_y = double(Px, Py, a, prime, False)
        double_list.append((double_x, double_y))
        triple_x, triple_y = add(double_x, double_y, Px, Py, prime, False)
        triple_list.append((triple_x, triple_y))
        Px = Px%prime
        Py = Py%prime
        a = a%prime
        inputs.append((a, prime, Px, Py, key))
    
    with open("../sim_data/top/save.txt", 'w') as f:
        for x in range(NUM_DATA):
            
            f.write(str(x)+':\n')
            f.write("Px: "+ str(hex(Px_list[x])[2:])+ " // "+str(Px_list[x])+'\n')
            f.write("Py: "+str(hex(Py_list[x])[2:])+ " // "+str(Py_list[x])+'\n')
            f.write("prime: "+ str(hex(prime_list[x])[2:])+ " // "+ str(prime_list[x])+'\n')
            f.write("a: "+ str(hex(a_list[x])[2:])+" // "+ str(a_list[x])+'\n')
            f.write("key: "+ str(hex(key_list[x])[2:])+" // "+ str(key_list[x])+'\n')
            f.write("Double Px: "+ str(hex(double_list[x][0])[2:])+' // '+str(double_list[x][0])+'\n')
            f.write("Double Py: "+ str(hex(double_list[x][1])[2:])+' // '+str(double_list[x][1])+'\n')
            f.write("Triple Px: "+ str(hex(triple_list[x][0])[2:])+' // '+str(triple_list[x][0])+'\n')
            f.write("Triple Py: "+ str(hex(triple_list[x][1])[2:])+' // '+str(triple_list[x][1])+'\n')
            f.write("\n")
    
    
    top.operate(inputs)

    top.write_out_data()
    return

if __name__ == '__main__':
    main()
