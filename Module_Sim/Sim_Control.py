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
    def __init__(self, input_ports, output_ports, reg_ports, out_dir, module_name):
        self.input_ports = input_ports
        self.output_ports = output_ports
        self.reg_ports = reg_ports
        self.out_dir = out_dir
        self.module_name = module_name
        self.current_reg = {}
        # create dict for current reg
        for x in self.reg_ports:
            self.current_reg[x.name] = 0
        return
    
    def operate(self, in_x):
        gfau_done, k_done, partkey, gfau_result, raw1, raw2, raw_prime, a = in_x

        """
            Input_port("GFAU_done", 1),
            Input_port("Keyshift_done", 1),
            Input_port("PartKey", 1),
            Input_port("GFAU_result", 32),
            Input_port("raw1", 32),
            Input_port("raw2", 32),
            Input_port("raw_prime", 32),
            Input_port("a", 32)

            output_ports = [
                Output_port("Px_mont", 32), 
                Output_port("Py_mont", 32),
                Output_port("operation_select", 2),
                Output_port("done_keyshift", 1),
                Output_port("done_control", 1),
                Output_port("output_1", 32),
                Output_port("output_2", 32),
            ]
        """

        # get raw inputs for 2 cycles
        self.operate_fn([0,0,0,0,raw1,raw2,raw_prime,a])
        self.operate_fn([0,0,0,0,raw1,raw2,raw_prime,a])
        # Call domain transfer
        self.Px_mont = self.to_mont(raw1, raw_prime)
        self.Py_mont = self.to_mont(raw2, raw_prime)
        self.a_mont = self.to_mont(a, raw_prime)
        print(self.a_mont)
        for x in range(31):
            self.update_inputs([0,0,0,0,raw1, raw2, raw_prime,a])
            self.update_reg(0)
            self.update_outputs(0)
        # output done_keyshift
        self.update_inputs([0,0,0,0,raw1, raw2, raw_prime,a])
        self.update_reg([self.Px_mont, self.Py_mont, 0,0,0,0,0,0])
        self.update_outputs([0,0,0,1,0,0,0,0])
        # # keyshift done, partkey = 1
        self.update_inputs([0,1,1,0,raw1, raw2, raw_prime,a])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['r1'],self.current_reg['r2'],self.current_reg['r1'],self.current_reg['r2'],self.current_reg['r1'],self.current_reg['r2']])
        self.update_outputs(0)

        # state 1
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x1'], self.current_reg['x1'],2,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # GFAU done
        # get GFAU result
        # in_0,in_1, prime, ops
        result = gfau([self.current_reg['x1'], self.current_reg['x1'],raw_prime, 2])
        print("state 1 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x1'], self.current_reg['x1'],2,0,0,0,0,0])
        self.update_reg([result,self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])


        # state 2
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r1'],0,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r1'], self.current_reg['r1'],raw_prime, 0])
        print("state 2 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r1'],0,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # state 3
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r2'],0,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r1'], self.current_reg['r2'],raw_prime, 0])
        print("state 3 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r2'],0,0,0,0,0,0])
        self.update_reg([result,self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # state 4
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,self.a_mont])
        self.update_outputs([self.current_reg['r1'], self.a_mont,0,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r1'], self.a_mont,raw_prime, 0])
        print("state 4 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.a_mont,0,0,0,0,0,0])
        self.update_reg([result,self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # state 5
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r1'],0,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r1'], self.current_reg['r1'],raw_prime, 0])
        print("state 5 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r1'],0,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # state 6
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r2'],3,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r1'], self.current_reg['r2'],raw_prime, 3])
        print("state 6 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r2'],3,0,0,0,0,0])
        self.update_reg([result,self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # state 7
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r1'],2,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r1'], self.current_reg['r1'],raw_prime, 2])
        print("state 7 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'], self.current_reg['r1'],2,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # state 8
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'], self.current_reg['x1'],1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r2'], self.current_reg['x1'],raw_prime, 1])
        print("state 8 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'], self.current_reg['x1'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        # state 9
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'], self.current_reg['x1'],1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],0,0])

        result = gfau([self.current_reg['r2'], self.current_reg['x1'],raw_prime, 1])
        print("state 9 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'], self.current_reg['x1'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],result,0])

        # state 10
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x1'],self.current_reg['r2'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],0])

        result = gfau([self.current_reg['x1'],self.current_reg['r2'], raw_prime, 1])
        print("state 10 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x1'],self.current_reg['r2'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],0])

        # state 11
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['r2'], 2,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],0])

        result = gfau([self.current_reg['r1'],self.current_reg['r2'], raw_prime, 2])
        print("state 11 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['r2'],2,0,0,0,0,0])
        self.update_reg([result,self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],0])

        # state 12
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['y1'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],0])

        result = gfau([self.current_reg['r1'],self.current_reg['y1'], raw_prime, 1])
        print("state 12 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['y1'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x3'],result,self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],result])

        # state 13
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x2'],self.current_reg['x1'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['x2'],self.current_reg['x1'], raw_prime, 1])
        print("state 13 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x2'],self.current_reg['x1'],1,0,0,0,0,0])
        self.update_reg([result,self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        # state 14
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['y2'],self.current_reg['y1'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['y2'],self.current_reg['y1'], raw_prime, 1])
        print("state 14 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['y2'],self.current_reg['y1'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        # state 15
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['r1'], 3,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['r2'],self.current_reg['r1'], raw_prime, 3])
        print("state 15 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['r1'],3,0,0,0,0,0])
        self.update_reg([result,self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        # state 16
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['r1'], 2,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['r1'],self.current_reg['r1'], raw_prime, 2])
        print("state 16 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['r1'],2,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        # state 17
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['x1'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['r2'],self.current_reg['x1'], raw_prime, 1])
        print("state 17 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['x1'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        # state 18
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['x2'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['r2'],self.current_reg['x2'], raw_prime, 1])
        print("state 18 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['x2'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],result,self.current_reg['y3']])

        # state 19
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x1'],self.current_reg['r2'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['x1'],self.current_reg['r2'], raw_prime, 1])
        print("state 19 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['x1'],self.current_reg['r2'],1,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        # state 20
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['r2'], 2,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['r1'],self.current_reg['r2'], raw_prime, 2])
        print("state 20 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r1'],self.current_reg['r2'],2,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        # state 21
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['y1'], 1,0,1,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        result = gfau([self.current_reg['r2'],self.current_reg['y1'], raw_prime, 1])
        print("state 21 result:", result)
        self.update_inputs([1,0,1,result,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['y1'],1,1,0,0,0,0])
        self.update_reg([self.current_reg['r1'],result,self.current_reg['x1'],self.current_reg['y1'], self.current_reg['x2'],self.current_reg['y2'],self.current_reg['x3'],result])

        # state 22
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['y1'], 0,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['y1'], 0,0,0,0,0,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])

        x3_trans = self.to_reg(self.current_reg['x3'], raw_prime)
        y3_trans = self.to_reg(self.current_reg['y3'], raw_prime)
        for x in range(32):
            self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
            self.update_outputs([self.current_reg['r2'],self.current_reg['y1'], 0,0,0,0,0,0])
            self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])
        self.update_inputs([0,0,1,0,raw1, raw2, raw_prime,a])
        self.update_outputs([self.current_reg['r2'],self.current_reg['y1'], 0,0,0,x3_trans,y3_trans,0])
        self.update_reg([self.current_reg['r1'],self.current_reg['r2'],self.current_reg['x1'],self.current_reg['y1'],self.current_reg['x2'], self.current_reg['y2'],self.current_reg['x3'],self.current_reg['y3']])



    
    def operate_fn(self, in_x):
        # function to calculate cycles and results
        gfau_done, k_done, partkey, gfau_result, raw1, raw2, raw_prime, a = in_x

        # output result
        self.update_inputs(in_x)
        self.update_reg(0)
        self.update_outputs(0)
        return
    
    def update_curr_reg(self,reg_nxt):
        if reg_nxt == 0:
            for x in self.reg_ports:
                self.current_reg[x.name] = 0
        else:
            for x in range(len(self.reg_ports)):
                self.current_reg[self.reg_ports[x].name] = reg_nxt[x]
        return

    
    def update_reg(self, reg_nxt):
        """
        r1, r2, x1, y1, x2, y2, x3, y3 = reg_nxt
        """
        if reg_nxt == 0:
            for x in range(len(self.reg_ports)):
                self.reg_ports[x].update(0)
        else:
            # in_x should have the same order as input ports
            for x in range(len(self.reg_ports)):
                self.reg_ports[x].update(reg_nxt[x])
        self.update_curr_reg(reg_nxt)
        return
    
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
    
    def write_out_data(self):
        for inputs in self.input_ports:
            with open(self.out_dir+'/'+inputs.name+'.dat', 'w') as f:
                for x in inputs.all_data:
                    hex_x = str(hex(x))[2:].upper().zfill(math.ceil(inputs.bits/4))
                    f.write("{}\t\t\t//{}\n".format(hex_x,x))
        for outputs in self.output_ports:
            with open(self.out_dir+'/'+outputs.name+'.dat', 'w') as f:
                for x in outputs.all_data:
                    hex_x = str(hex(x))[2:].upper().zfill(math.ceil(outputs.bits/4))
                    f.write("{}\t\t\t//{}\n".format(hex_x,x))
        
        for reg in self.reg_ports:
            with open(self.out_dir+'/'+reg.name+'.dat', 'w') as f:
                for x in reg.all_data:
                    hex_x = str(hex(x))[2:].upper().zfill(math.ceil(reg.bits/4))
                    f.write("{}\t\t\t//{}\n".format(hex_x,x))
        
        print("Total cycles: "+str(len(self.input_ports[0].all_data)))
    
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
        if P >= prime:
            P -= prime
        for i in range(32):
            P = P << 1
            if P >= prime:
                P -= prime
        assert P == P_mont
        return P_mont

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
        Output_port("output_1", 32),
        Output_port("output_2", 32),
        Output_port("all_done", 1)
    ]

    reg_ports = [
        Reg_port("r1", 32),
        Reg_port("r2", 32),
        Reg_port("x1", 32),
        Reg_port("y1", 32),
        Reg_port("x2", 32),
        Reg_port("y2", 32),
        Reg_port("x3", 32),
        Reg_port("y3", 32)
    ]

    control = Control(input_ports, output_ports, reg_ports, "../sim_data/control", "Control")


    # Create inputs for addition

    prime = num.getPrime(32)
    Px = randint(0, 2**32)
    Py = randint(0, 2**32)
    a = randint(0,2**32)
    Px = Px%prime
    Py = Py%prime
    a = a%prime


    # get raw inputs for 2 cycles
    control.operate([0,0,0,0,Px,Py,prime,a])

    control.write_out_data()


    return

if __name__ == '__main__':
    main()
