from abc import ABC, abstractmethod
from TestBench import TB
import math

class Port:
    def __init__(self, name, bits):
        self.name = name
        self.all_data = []
        self.bits = bits
        self.current_data = 0

    def update(self, bit_pattern):
        self.current_data = bit_pattern
        self.all_data.append(bit_pattern)
        return
    
    def curr(self):
        return self.current_data

class Input_port(Port):
    def __init__(self, name, bits):
        super().__init__(name, bits)
        
class Output_port(Port):
    def __init__(self, name, bits):
        super().__init__(name, bits)

class Valid_port(Port):
    def __init__(self, name, bits):
        super().__init__(name, bits)

class Done_port(Port):
    def __init__(self, name, bits):
        super().__init__(name, bits)



class Base_Module(ABC):
    def __init__(self, input_ports, output_ports, valid_port, done_port, out_dir, module_name):
        self.input_ports = input_ports
        self.output_ports = output_ports
        self.valid_port = valid_port
        self.done_port = done_port
        self.out_dir = out_dir
        self.module_name = module_name
        self.operate_cycles = []
        return
    
    @abstractmethod
    def operate(self, inputs):
        """
        Function interface to read all inputs
        """
        return

    @abstractmethod
    def operate_fn(self):
        """
        Function to operate each input
        """
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
    
    def update_valid(self, valid):
        self.valid_port.update(valid)
        return
    
    def update_done(self, done):
        self.done_port.update(done)
        return
    
    def update_allzero(self):
        self.update_valid(0)
        self.update_done(0)
        self.update_inputs(0)
        self.update_outputs(0)
        return
    
    def get_ready(self):
        # valid to 1
        self.update_valid(1)
        self.update_inputs(0)
        self.update_outputs(0)
        self.update_valid(0)
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
        
        with open(self.out_dir+'/'+ self.done_port.name+'.dat', 'w') as f:
            for x in self.done_port.all_data:
                hex_x = str(hex(x))[2:].upper().zfill(math.ceil(self.done_port.bits/4))
                f.write("{}\t\t\t//{}\n".format(hex_x,x))
        
        with open(self.out_dir+'/'+ self.valid_port.name+'.dat', 'w') as f:
            for x in self.valid_port.all_data:
                hex_x = str(hex(x))[2:].upper().zfill(math.ceil(self.valid_port.bits/4))
                f.write("{}\t\t\t//{}\n".format(hex_x,x))
        
        with open('./log/cycles.txt', 'w') as f:
            for x in self.operate_cycles:
                f.write(str(x)+'\n')
            f.write("Total cycles: "+str(len(self.valid_port.all_data)))
        print("Total cycles: "+str(len(self.valid_port.all_data)))
    
    def create_test_bench(self):
        self.data_length = len(self.done_port.all_data)
        self.data_num = len(self.operate_cycles)
        tb = TB(self.input_ports,self.output_ports, self.valid_port, self.done_port, ".", self.out_dir, self.module_name, self.data_length, self.data_num)
        tb.write_tb()
        return