from Base_Module import *
from montmult import *
from random import randint
import Crypto.Util.number as num
import Crypto

"""
module GFAU(
    // inputs
	i_clk,
	i_rst,
	in_0,
	in_1,
	prime,
	operation_select,
	done_from_control,

    // outputs
	result,
	done_to_control,
	done_add,
	done_sub,
	done_mult,
	done_div,
	state,
	div_out
	);
"""

NUM_DATA = [10,10,10,10]

class GFAU(Base_Module):
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

        # get individual inputs and update to input ports
        in_0, in_1, prime, ops = in_x
        self.update_inputs(in_x)
        self.update_outputs(0)
        self.update_valid(1)
        self.update_done(0)

        result = 0
        if ops == 0:
            # add
            result = (in_0 + in_1) % prime
            cycles += 1
        elif ops == 1:
            # sub
            result = (in_0 - in_1) % prime
            cycles += 1
        elif ops == 2:
            # mult
            result = MonMul(in_0, in_1, prime, 32)
            cycles += 33
        else:
            # div
            result, c = MonDiv(in_0, in_1, prime, 32)
            cycles += c


        return result, cycles
    

    
    

def main():
    # declare input and output ports except clock and reset
    # sequential always block should be negative dege reset (reset == 0)
    input_ports = [
        Input_port("in_0", 32),
        Input_port("in_1", 32),
        Input_port("prime", 32),
        Input_port("operation_select", 2),
    ]

    output_ports = [
        Output_port("result", 32), 
        Output_port("done_add", 1),
        Output_port("done_sub", 1),
        Output_port("done_mult", 1),
        Output_port("done_div", 1)
    ]

    done_port = Done_port("done_to_control", 1)

    valid_port = Valid_port("done_from_control", 1)

    # Initialize GFAU
    gfau = GFAU(input_ports, output_ports, valid_port, done_port, "../sim_data/GFAU_test", "GFAU")

    # Create Inputs
    inputs = []

    op_type = -1
    for i in NUM_DATA:
        op_type += 1
        for j in range(i):
            prime = num.getPrime(32)
            Px = randint(0, 2**32)
            Py = randint(0, 2**32)
            Px = Px%prime
            Py = Py%prime
            inputs.append((Px, Py, prime, op_type))
    
    
    gfau.operate(inputs)

    gfau.write_out_data()

    gfau.create_test_bench()
    return

if __name__ == '__main__':
    main()
