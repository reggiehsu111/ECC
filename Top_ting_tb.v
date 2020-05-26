`timescale 1ns/10ps
`define CYCLE  10
`define HCYCLE  5
//`define SDFFILE "GFAU_syn.sdf"

module Top_ting_tb;

    localparam SIZE = 32;

    reg i_rst, i_clk, i_start;
    reg [3 : 0] a, prime, Px, Py, k;

    wire [3 : 0] kP;
    wire [31 : 0] raw1;

    Top_ting Top_ting_0(
    i_rst,
    i_clk,
    i_start,
    a,
    prime,
    Px,
    Py,
    k,
    kP,
    raw1);
	

/*    `ifdef SDF
        initial $sdf_annotate(`SDFFILE, test);
    `endif*/

	initial begin
        $fsdbDumpfile("Top_ting.fsdb");
        $fsdbDumpvars;
    end
    initial begin
    	i_rst = 0;
    	i_clk = 1;
        a = 4'b1000;
        prime = 4'b1011;
        Px = 4'b1001;
        Py = 4'b1010;
        k = 4'b1011;
        i_start = 0;
    	
        #(`CYCLE);
    	i_rst = 1; 

        #(`CYCLE);
        i_rst = 0;
        #(`CYCLE);
        #(`CYCLE);
        i_start = 1;
        #(`CYCLE);
        i_start = 0;
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
