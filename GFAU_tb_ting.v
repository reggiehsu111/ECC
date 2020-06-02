`timescale 1ns/10ps
`define CYCLE  10
`define HCYCLE  5
//`define SDFFILE "GFAU_syn.sdf"

module GFAU_tb;

    localparam SIZE = 32;

    reg i_rst, i_clk;
    reg [SIZE - 1 : 0] in_0, in_1, prime;
    reg [1 : 0] operation_select;
    reg done_from_control;
    wire [SIZE - 1 : 0] result;
    wire done_to_control;
    wire done_add, done_sub, done_mult, done_div;
    wire [SIZE - 1 : 0] mult_out, div_out;


	GFAU GFAU_test(
		i_clk,
        i_rst,
        in_0,
        in_1,
        prime,
        operation_select,
        done_from_control,
        result,
        done_to_control,
        done_add,
        done_sub,
        done_mult,
        done_div
    );

/*    `ifdef SDF
        initial $sdf_annotate(`SDFFILE, test);
    `endif*/

	initial begin
        $fsdbDumpfile("GFAU_test_IC_lab.fsdb");
        $fsdbDumpvars;
    end
    initial begin
    	i_rst = 0;
    	i_clk = 1;
        in_0 = 86;
        in_1 = 53;
        prime = 97;
    	
        #(`CYCLE);
    	i_rst = 1; 

        #(`CYCLE);
        i_rst = 0;
        #(`CYCLE);
        operation_select = 0;
        done_from_control = 1;
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        /*if (u_out == 1 && v_out == 0) begin
            $display("        *****************************************************              ");
            $display("        **                                                 **      /|__/|");
            $display("        **               Congratulations !!                **     / O,O  \\");
            $display("        **                                                 **    /_____   \\");
            $display("        **          All test results are right !!          **   /^ ^ ^ \\  |");
            $display("        **                                                 **  |^ ^ ^ ^ |w|");
            $display("        *****************************************************   \\m___m__|_|");
            $display("\n");
            $display("============================================================================");
        end
        else begin
            $display ("FAIL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        end*/
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        //i_rst = 1;
        #(`CYCLE);
        i_rst = 0;
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE);
        #(`CYCLE); 
        #(`CYCLE * 100); 	   	
        $finish;
    end
    always #(`CYCLE*0.5) i_clk = ~i_clk;
endmodule
