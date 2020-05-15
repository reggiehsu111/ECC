from Base_Module import *

class TB:
    def __init__(self, input_ports, output_ports, valid_port, done_port, out_dir, data_dir, module_name, data_length, data_num):
        self.input_ports = input_ports
        self.output_ports = output_ports
        self.valid_port = valid_port
        self.done_port = done_port
        self.out_dir = out_dir
        self.data_dir = data_dir
        self.module_name = module_name
        self.data_length = data_length # this is the total length of data
        self.data_num = data_num # this is the actual number of data
        self.output_str_list = []
        return
    
    def gather_strings(self):
        self.output_str_list.extend(self.initial_str())
        self.output_str_list.extend(self.data_str())
        self.output_str_list.extend(self.module_str())
        return
    
    def initial_str(self,timescale_over_10ps=1, cycle_time=10):
        ret = []
        ret.append("`timescale " + str(timescale_over_10ps) +"ns/10ps")
        ret.append("`define CYCLE    " + str(cycle_time))
        ret.append('')
        return ret
    
    def data_str(self):
        ret = []
        max_name_len = 0
        # get max_name_len
        for x in self.input_ports:
            if len(x.name) > max_name_len:
                max_name_len = len(x.name)
        for x in self.output_ports:
            if len(x.name) > max_name_len:
                max_name_len = len(x.name)
        if len(self.valid_port.name) > max_name_len:
            max_name_len = len(self.valid_port.name)
        if len(self.done_port.name) > max_name_len:
            max_name_len = len(self.done_port.name)
        length = max_name_len + 5

        for x in self.input_ports:
            spaces = length - len(x.name)
            ret.append("`define " + x.name.upper() + ' '*spaces + '\"' + self.data_dir + '/' + x.name + ".dat\"")
        for x in self.output_ports:
            spaces = length - len(x.name)
            ret.append("`define " + x.name.upper() + ' '*spaces + '\"' + self.data_dir + '/' + x.name + ".dat\"")
        x = self.valid_port
        spaces = length - len(x.name)
        ret.append("`define " + x.name.upper() + ' '*spaces + '\"' + self.data_dir + '/' + x.name + ".dat\"")
        x = self.done_port
        spaces = length - len(x.name)
        ret.append("`define " + x.name.upper() + ' '*spaces + '\"' + self.data_dir + '/' + x.name + ".dat\"")
        ret.append('')
        return ret
    
    def module_str(self):
        ret = []
        ret.append("module "+self.module_name+"_test();")
        ret.append('')
        # All strings inside this module should be indented
        ret.extend(self.module_front_str())
        ret.extend(self.module_instance_str())
        ret.extend(self.readmem_str())
        ret.extend(self.initial_begin_str())
        ret.extend(self.load_data_str())
        ret.extend(self.err_block_str())
        ret.extend(self.success_block_str())
        ret.append("endmodule")
        return ret
    
    def success_block_str(self):
        ret = []
        ret.append(("initial begin", 1))
        ret.append(("@(posedge stop)", 2))
        ret.append(("if(over) begin", 2))
        ret.append(("$display(\"---------------------------------------------\\n\");", 3))
        ret.append(("if (err == 0)  begin", 3))
        ret.append(("$display(\"All data have been generated successfully!\\n\");", 4))
        ret.append(("$display(\"-------------------PASS-------------------\\n\");", 4))
        ret.append(("end", 3))
        ret.append(("else begin", 3))
        ret.append(("$display(\"There are %d errors!\\n\", err);", 4))
        ret.append(("end", 3))
        ret.append(("$display(\"---------------------------------------------\\n\");", 3))
        ret.append(("end", 2))
        ret.append(("else begin", 2))
        ret.append(("$display(\"---------------------------------------------\\n\");", 3))
        ret.append(("$display(\"Error!!! There is no any data output ...!\\n\");", 3))
        ret.append(("$display(\"--------------------FAIL---------------------\\n\");", 3))
        ret.append(("$display(\"---------------------------------------------\\n\");", 3))
        ret.append(("end", 2))
        ret.append(("$finish;", 2))
        ret.append(("end", 1))
        ret.append(("", 1))
        

        # start indent
        ret = self.indent_strings(ret)
        return ret
    
    def err_block_str(self):
        ret = []
        ret.append(("always @(posedge clk)begin", 1))
        ret.append(("if ("+ self.done_port.name + ") begin", 2))
        str_if = "if( "
        for x in self.output_ports:
            str_if += x.name + " !== " + x.name + "_golden || "
        str_if += self.done_port.name + " !== " + self.done_port.name + " ) begin"
        ret.append((str_if, 3))
        for x in self.output_ports:
            ret.append(("if( " + x.name + " !== " + x.name + "_golden) begin", 4))
            ret.append(("$display(\"ERROR on Result at %d:output %h !=expect %h \",pattern_num,"+ x.name +" , "+ x.name +"_golden);", 5))
            ret.append(("$display(out_f,\"ERROR on Result at %d:output %h !=expect %h \",pattern_num,"+ x.name +" , "+ x.name +"_golden);", 5))
            ret.append(("end", 4))
        x = self.done_port
        ret.append(("if( " + x.name + " !== " + x.name + "_golden) begin", 4))
        ret.append(("$display(\"ERROR on Result at %d:output %h !=expect %h \",pattern_num,"+ x.name +" , "+ x.name +"_golden);", 5))
        ret.append(("$display(out_f,\"ERROR on Result at %d:output %h !=expect %h \",pattern_num,"+ x.name +" , "+ x.name +"_golden);", 5))
        ret.append(("end", 4))
        ret.append(("err = err + 1", 4))
        ret.append(("end", 3))
        ret.append(("pattern_num = pattern_num + 1;", 3))
        ret.append(("if(pattern_num === DATA_NUM)  over = 1'b1;", 3))
        ret.append(("end", 2))
        ret.append(("end", 1))
        ret.append(("", 1))

        # start indent
        ret = self.indent_strings(ret)
        return ret
    
    def load_data_str(self):
        ret = []
        ret.append(("always @(negedge clk)begin", 1))
        ret.append(("if (i<DATA_LENGTH) begin", 2))
        ret.append(("// Get Input", 2))
        for x in self.input_ports:
            ret.append((x.name+" = "+x.name+"_mem[i];", 3))
        ret.append((self.valid_port.name+" = "+self.valid_port.name+"_mem[i];", 3))
        ret.append(("// Get Output", 2))
        for x in self.output_ports:
            ret.append((x.name+" = "+x.name+"_mem[i];", 3))
        ret.append((self.done_port.name+" = "+self.done_port.name+"_mem[i];", 3))
        ret.append(("i = i+1;", 3))
        ret.append(("end", 2))
        ret.append(("else stop = 1;", 2))
        ret.append(("end", 1))
        ret.append(("", 1))

        # start indent
        ret = self.indent_strings(ret)
        return ret
    
    def initial_begin_str(self):
        ret = []
        _ret = []

        _ret.append(("initial begin", 1))
        ret.append("clk         = 1'b1;")
        ret.append("reset       = 1'b1;")
        ret.append("stop        = 1'b0;")
        ret.append("over        = 1'b0;")
        ret.append("pattern_num = 0;")
        ret.append("err         = 0;")
        ret.append("i           = 0;")
        ret.append("j           = 0;")
        ret.append("#2.5 reset=1'b0;")
        ret.append("#2.5 reset=1'b1;")
        # add depth info
        for x in ret:
            _ret.append((x, 2))
        _ret.append(("end", 1))
        _ret.append(("", 1))
        _ret.append(("always begin #(`CYCLE/2) clk = ~clk; end", 1))
        _ret.append(("", 1))
        _ret.append(("initial begin", 1))
        _ret.append(("$dumpfile(\"" + self.module_name.upper() + ".fsdb\");", 2))
        _ret.append(("$dumpvars;", 2))
        _ret.append(("", 1))
        _ret.append(("out_f = $fopen(\"out.dat\");", 2))
        _ret.append(("if (out_f == 0) begin", 2))
        _ret.append(("$display(\"Output file open error !\");", 3))
        _ret.append(("$finish;", 3))
        _ret.append(("end", 2))
        _ret.append(("end", 1))
        _ret.append(("", 1))

        # start indent
        ret = self.indent_strings(_ret)
        return ret
    
    def readmem_str(self):
        ret = []
        ret.append("//Inputs")
        for x in self.input_ports:
            ret.append("initial $readmemh (`" + x.name.upper() + ",  " + x.name + "_mem);")
        ret.append("initial $readmemh (`" + self.valid_port.name.upper() + ",  " + self.valid_port.name + "_mem);")
        ret.append('')
        ret.append("//Outputs")
        for x in self.output_ports:
            ret.append("initial $readmemh (`" + x.name.upper() + ",  " + x.name + "_mem);")
        ret.append("initial $readmemh (`" + self.done_port.name.upper() + ",  " + self.done_port.name + "_mem);")
        ret.append('')

        # add depth info
        _ret = []
        for x in ret:
            _ret.append((x, 1))

        # start indent
        ret = self.indent_strings(_ret)
        return ret


    def module_instance_str(self):
        ret = []
        _ret = []
        _ret.append((self.module_name + " "+ self.module_name.lower()+"0(", 1))
        ret.append(".i_clk(clk)")
        ret.append(".i_rst(reset)")
        ret.append('.'+self.done_port.name+"("+self.done_port.name+")")
        ret.append('.'+self.valid_port.name+"("+self.valid_port.name+")")
        for x in self.input_ports:
            ret.append('.'+x.name+"("+x.name+")")
        for x in self.output_ports:
            ret.append('.'+x.name+"("+x.name+")")

        # add depth info
        for x in ret:
            _ret.append((x, 2))
        
        _ret.append((");", 1))
        _ret.append(('', 1))

        # start indent
        ret = self.indent_strings(_ret)
        return ret


    def module_front_str(self):
        # Original strings
        ret = []
        ret.append("parameter DATA_NUM = " + str(self.data_num) +";")
        ret.append("parameter DATA_LENGTH = " + str(self.data_length) +";")
        ret.append("")
        ret.append("reg           clk, reset;")
        ret.append("reg           "+ self.valid_port.name + ";")
        ret.append('')
        for inputs in self.input_ports:
            if inputs.bits != 1:
                ret.append("reg  [" + str(inputs.bits-1) +":0]      "+ inputs.name+";")
            else:
                ret.append("reg           "+inputs.name+";")
        ret.append("wire             " + self.done_port.name + ";")
        for outputs in self.output_ports:
            if outputs.bits != 1:
                ret.append("wire  [" + str(outputs.bits-1) +":0]     "+ outputs.name+";")
            else:
                ret.append("wire             "+outputs.name+";")
        ret.append('')
        ret.append("// Inputs from files")
        ret.append("reg           " + self.valid_port.name+"_mem       [0:DATA_LENGTH-1];")
        for inputs in self.input_ports:
            if inputs.bits != 1:
                ret.append("reg  [" + str(inputs.bits-1) +":0]   "+ inputs.name+"_mem       [0:DATA_LENGTH-1];")
            else:
                ret.append("reg           " + inputs.name+"_mem       [0:DATA_LENGTH-1];")
        ret.append('')
        ret.append("// Outputs from files")
        ret.append("reg           " + self.done_port.name+"_mem       [0:DATA_LENGTH-1];")
        for outputs in self.output_ports:
            if outputs.bits != 1:
                ret.append("reg  [" + str(outputs.bits-1) +":0]   "+ outputs.name+"_mem       [0:DATA_LENGTH-1];")
            else:
                ret.append("reg           " + outputs.name+"_mem       [0:DATA_LENGTH-1];")
        ret.append('')
        # Output goldens
        ret.append("// Output goldens")
        ret.append("reg           " + self.done_port.name+"_golden;")
        for outputs in self.output_ports:
            if outputs.bits != 1:
                ret.append("reg  [" + str(outputs.bits-1) +":0]   "+ outputs.name+"_golden;")
            else:
                ret.append("reg           " + outputs.name+"_golden;")
        ret.append('')
        ret.append("reg           stop, over;")
        ret.append("integer       i, j, out_f, err, pattern_num;")
        ret.append('')

        # add depth info
        _ret = []
        for x in ret:
            _ret.append((x, 1))

        # start indent
        ret = self.indent_strings(_ret)
        return ret
    
    def indent_strings(self, str_list):
        ret = []
        for strings, depth in str_list:
            ret.append('\t'*depth + strings)
        return ret

    def write_tb(self):
        self.gather_strings()
        with open(self.out_dir+'/'+self.module_name+'_tb.v', 'w') as f:
            for item in self.output_str_list:
                f.write("%s\n" % item)
        return

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
        Output_port("result", 32)
    ]

    done_port = Done_port("done_to_control", 1)

    valid_port = Valid_port("done_from_control", 1)

    # Initialize TB
    tb = TB(input_ports, output_ports, valid_port, done_port, ".", "../sim_data/GFAU_test", "GFAU", 1390, 40)

    tb.write_tb()
    return

if __name__ == '__main__':
    main()
