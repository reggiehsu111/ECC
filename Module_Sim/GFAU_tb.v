`timescale 1ns/10ps
`define CYCLE    10

`define IN_0                  "../sim_data/GFAU_test/in_0.dat"
`define IN_1                  "../sim_data/GFAU_test/in_1.dat"
`define PRIME                 "../sim_data/GFAU_test/prime.dat"
`define OPERATION_SELECT      "../sim_data/GFAU_test/operation_select.dat"
`define RESULT                "../sim_data/GFAU_test/result.dat"
`define DONE_FROM_CONTROL     "../sim_data/GFAU_test/done_from_control.dat"
`define DONE_TO_CONTROL       "../sim_data/GFAU_test/done_to_control.dat"

module GFAU_test();

	parameter DATA_NUM = 40;
	parameter DATA_LENGTH = 1420;
	
	reg           clk, reset;
	reg           done_from_control;
	
	reg  [31:0]      in_0;
	reg  [31:0]      in_1;
	reg  [31:0]      prime;
	reg  [1:0]      operation_select;
	wire             done_to_control;
	wire  [31:0]     result;
	
	// Inputs from files
	reg           done_from_control_mem       [0:DATA_LENGTH-1];
	reg  [31:0]   in_0_mem       [0:DATA_LENGTH-1];
	reg  [31:0]   in_1_mem       [0:DATA_LENGTH-1];
	reg  [31:0]   prime_mem       [0:DATA_LENGTH-1];
	reg  [1:0]   operation_select_mem       [0:DATA_LENGTH-1];
	
	// Outputs from files
	reg           done_to_control_mem       [0:DATA_LENGTH-1];
	reg  [31:0]   result_mem       [0:DATA_LENGTH-1];
	
	// Output goldens
	reg           done_to_control_golden;
	reg  [31:0]   result_golden;
	
	reg           stop, over;
	integer       i, j, out_f, err, pattern_num;
	
	GFAU gfau0(
		.i_clk(clk)
		.i_rst(reset)
		.done_to_control(done_to_control)
		.done_from_control(done_from_control)
		.in_0(in_0)
		.in_1(in_1)
		.prime(prime)
		.operation_select(operation_select)
		.result(result)
	);
	
	//Inputs
	initial $readmemh (`IN_0,  in_0_mem);
	initial $readmemh (`IN_1,  in_1_mem);
	initial $readmemh (`PRIME,  prime_mem);
	initial $readmemh (`OPERATION_SELECT,  operation_select_mem);
	initial $readmemh (`DONE_FROM_CONTROL,  done_from_control_mem);
	
	//Outputs
	initial $readmemh (`RESULT,  result_mem);
	initial $readmemh (`DONE_TO_CONTROL,  done_to_control_mem);
	
	initial begin
		clk         = 1'b1;
		reset       = 1'b1;
		stop        = 1'b0;
		over        = 1'b0;
		pattern_num = 0;
		err         = 0;
		i           = 0;
		j           = 0;
		#2.5 reset=1'b0;
		#2.5 reset=1'b1;
	end
	
	always begin #(`CYCLE/2) clk = ~clk; end
	
	initial begin
		$dumpfile("GFAU.fsdb");
		$dumpvars;
	
		out_f = $fopen("out.dat");
		if (out_f == 0) begin
			$display("Output file open error !");
			$finish;
		end
	end
	
	always @(negedge clk)begin
		if (i<DATA_LENGTH) begin
		// Get Input
			in_0 = in_0_mem[i];
			in_1 = in_1_mem[i];
			prime = prime_mem[i];
			operation_select = operation_select_mem[i];
			done_from_control = done_from_control_mem[i];
		// Get Output
			result = result_mem[i];
			done_to_control = done_to_control_mem[i];
			i = i+1;
		end
		else stop = 1;
	end
	
	always @(posedge clk)begin
		if (done_to_control) begin
			if( result !== result_golden || done_to_control !== done_to_control ) begin
				if( result !== result_golden) begin
					$display("ERROR on Result at %d:output %h !=expect %h ",pattern_num,result , result_golden);
					$display(out_f,"ERROR on Result at %d:output %h !=expect %h ",pattern_num,result , result_golden);
				end
				if( done_to_control !== done_to_control_golden) begin
					$display("ERROR on Result at %d:output %h !=expect %h ",pattern_num,done_to_control , done_to_control_golden);
					$display(out_f,"ERROR on Result at %d:output %h !=expect %h ",pattern_num,done_to_control , done_to_control_golden);
				end
				err = err + 1
			end
			pattern_num = pattern_num + 1;
			if(pattern_num === DATA_NUM)  over = 1'b1;
		end
	end
	
	initial begin
		@(posedge stop)
		if(over) begin
			$display("---------------------------------------------\n");
			if (err == 0)  begin
				$display("All data have been generated successfully!\n");
				$display("-------------------PASS-------------------\n");
			end
			else begin
				$display("There are %d errors!\n", err);
			end
			$display("---------------------------------------------\n");
		end
		else begin
			$display("---------------------------------------------\n");
			$display("Error!!! There is no any data output ...!\n");
			$display("--------------------FAIL---------------------\n");
			$display("---------------------------------------------\n");
		end
		$finish;
	end
	
endmodule
