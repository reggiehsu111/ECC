from Base_Module import *
from montmult import *
from random import randint
import Crypto.Util.number as num
import Crypto

"""
module Control(
                i_clk,
                i_reset,
                GFAU_done,
                Keyshift_done,
                PartKey,
                GFAU_result,
                Px_mont, Py_mont,
                operation_select,
                done_keyshift,
                done_control,
                raw1, raw2, raw_prime,
                output_1, output_2
                );
"""

class Control(Base_Module):
    def operate(self, inputs):
        # inputs array is a buffer for all inputs
        # read input only when valid
        for in_x in inputs:
            _, _, _, ops = in_x
            # read input and calculate cycles
            result, cycles = self.operate_fn(in_x)
            self.operate_cycles.append(cycles)

            # all zeros for following cycles
            for c in range(cycles-1):
                self.update_allzero()

            out = [result, 0,0,0,0]
            out[ops+1] = 1
            
            # output result
            self.update_inputs(0)
            self.update_outputs(out)
            self.update_done(1)
            self.update_valid(0)

        return
    
    def operate_fn(self, in_x):
        # function to calculate cycles and results
        # initialize cycles to 0
        cycles = 0

        return result, cycles
    

def main():
    # declare input and output ports except clock and reset
    # sequential always block should be negative dege reset (reset == 0)
    input_ports = [
        Input_port("GFAU_done", 1),
        Input_port("Keyshift_done", 1),
        Input_port("PartKey", 1),
        Input_port("GFAU_result", 32),
        Input_port("raw1", 32),
        Input_port("raw2", 32),
        Input_port("raw_prime", 32)
    ]

    output_ports = [
        Output_port("Px_mont", 32), 
        Output_port("Py_mont", 32),
        Output_port("operation_select", 2),
        Output_port("done_keyshift", 1),
        Output_port("done_control", 1),
        Output_port("Py_mont", 32),
        Output_port("Py_mont", 32),
    ]

    done_port = Done_port("done", 1)

    valid_port = Valid_port("valid", 1)

    # Initialize GFAU
    gfau = GFAU(input_ports, output_ports, valid_port, done_port, "../sim_data/GFAU_test", "GFAU")
    control = Control(input_ports, output_ports, valid_port, done_port, "../sim_data/Control", "Control")

    # Create Inputs
    inputs = []

    num_data = 40

    for i in range(num_data):
        prime = num.getPrime(32)
        Px = randint(0, 2**32)
        Py = randint(0, 2**32)
        Px = Px%prime
        Py = Py%prime
        
    
    
    gfau.operate(inputs)

    gfau.write_out_data()

    gfau.create_test_bench()
    return

if __name__ == '__main__':
    main()
