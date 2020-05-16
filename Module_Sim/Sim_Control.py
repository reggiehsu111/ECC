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

class Control:
    def __init__(self, input_ports, output_ports):
        self.input_ports = input_ports
        self.output_ports = output_ports
        self.results = []
        self.r1 = []
        self.r2 = []
        return
    
    def operate(self, in_x):
        gfau_done, k_done, partkey, gfau_result, raw1, raw2, a = in_x
        


    
    def operate_fn(self, in_x):
        # function to calculate cycles and results
        gfau_done, k_done, partkey, gfau_result, raw1, raw2, a = in_x

        # output result
        self.update_inputs(in_x)
        self.update_outputs(out)
        self.results.append(result)
        return result
    
    def update_inputs(self, in_x):
        if in_x == 0:
            # inputs are all 0 if in_x == 0
            for x in range(len(self.input_ports)):
                self.input_ports[x].update(0)
        else:
            # in_x should have the same order as input ports
            for x in range(len(self.input_ports)):
                self.input_ports[x].update(in_x[x])
        return
    
    def update_outputs(self, out_x):
        if out_x == 0:
            # outputs are all 0 if out_x == 0
            for x in range(len(self.output_ports)):
                self.output_ports[x].update(0)
        else:
            # out_x should have the same order as output ports
            for x in range(len(self.output_ports)):
                self.output_ports[x].update(out_x[x])
        return
    
def gfau(inputs):
    in_0, in_1, prime, ops = inputs
    result = 0
        if ops == 0:
            # add
            result = (in_0 + in_1) % prime
        elif ops == 1:
            # sub
            result = (in_0 - in_1) % prime
        elif ops == 2:
            # mult
            result = MonMul(in_0, in_1, prime, 32)
        else:
            # div
            result, c = MonDiv(in_0, in_1, prime, 32)
    return result

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
        Input_port("raw_prime", 32),
        Input_port("a", 32)
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

    control = Control(input_ports, output_ports)

    # Create Inputs
    inputs = []

    # Create inputs for addition

    prime = num.getPrime(32)
    Px = randint(0, 2**32)
    Py = randint(0, 2**32)
    a = randint(0,2**32)
    Px = Px%prime
    Py = Py%prime
    a = a%prime


    # get raw inputs
    result = control.operate_fn([0,0,0,0,Px,Py,prime,a])

    # get part key
    result = control.operate_fn([0,0,1,0,Px,Py,prime,a])
    control.operate([0,0,1,0,Px,Py,prime,a])
    
    # gfau done
    result = gfau(result)
    result = control.operate_fn(1,0,1,result,Px,Py,prime,a])


    # 
    inputs.append([1,0,1,0,Px,Py,prime,a])
    
    gfau.operate(inputs)

    gfau.write_out_data()

    gfau.create_test_bench()
    return

if __name__ == '__main__':
    main()
