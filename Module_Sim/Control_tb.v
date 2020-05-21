`timescale 1ns/10ps
`define CYCLE    10

// Files for input ports
`define GFAU_DONE                  "sim_data/control/GFAU_done.dat"
`define KEYSHIFT_DONE              "sim_data/control/Keyshift_done.dat"
`define PARTKEY                    "sim_data/control/PartKey.dat"
`define GFAU_RESULT                "sim_data/control/GFAU_result.dat"
`define RAW1                       "sim_data/control/raw1.dat"
`define RAW2                       "sim_data/control/raw2.dat"
`define RAW_PRIME                  "sim_data/control/raw_prime.dat"
`define IN_A                       "sim_data/control/a.dat"

// Files for output ports
`define PX_MONT                    "sim_data/control/Px_mont.dat"
`define PY_MONT                    "sim_data/control/Py_mont.dat"
`define OP_S                       "sim_data/control/operation_select.dat"
`define DONE_KEYSHIFT              "sim_data/control/done_keyshift.dat"
`define DONE_CONTROL               "sim_data/control/done_control.dat"
`define OUTPUT_1                   "sim_data/control/output_1.dat"
`define OUTPUT_2                   "sim_data/control/output_2.dat"
`define ALL_DONE                   "sim_data/control/all_done.dat"

// Files for registers
`define R1                         "sim_data/control/r1.dat"
`define R2                         "sim_data/control/r2.dat"
`define X1                         "sim_data/control/x1.dat"
`define Y1                         "sim_data/control/y1.dat"
`define X2                         "sim_data/control/x2.dat"
`define Y2                         "sim_data/control/y2.dat"
`define X3                         "sim_data/control/x3.dat"
`define Y3                         "sim_data/control/y3.dat"

module Control_test();

    parameter DATA_NUM = 3; // need to be adjusted
	parameter DATA_LENGTH = 40;
	
    // Input registers
	reg           clk, reset;
	reg           gfau_done, keyshift_done, partkey;
	reg  [31:0]      gfau_result, raw1, raw2, raw_prime, in_a;

    // Output wires
	wire             done_keyshift, done_control, all_done;
    wire  [1:0]      op_s;
	wire  [31:0]     px_mont, py_mont, output_1, output_2;

    // Reg registers
    reg  [31:0]     r1, r2, x1, x2, x3, y1, y2, y3;
	
	// Inputs from files
	reg           gfau_done_mem       [0:DATA_LENGTH-1];
    reg           keyshift_done_mem   [0:DATA_LENGTH-1];
    reg           partkey_mem         [0:DATA_LENGTH-1];
	reg  [31:0]   gfau_result_mem     [0:DATA_LENGTH-1];
	reg  [31:0]   raw1_mem            [0:DATA_LENGTH-1];
	reg  [31:0]   raw2_mem            [0:DATA_LENGTH-1];
	reg  [31:0]   raw_prime_mem       [0:DATA_LENGTH-1];
    reg  [31:0]   in_a_mem               [0:DATA_LENGTH-1];

    // Outputs from files
    reg           done_keyshift_mem   [0:DATA_LENGTH-1];
    reg           done_control_mem    [0:DATA_LENGTH-1];
    reg           all_done_mem        [0:DATA_LENGTH-1];
    reg  [1:0]    op_s_mem            [0:DATA_LENGTH-1];
	reg  [31:0]   px_mont_mem         [0:DATA_LENGTH-1];
    reg  [31:0]   py_mont_mem         [0:DATA_LENGTH-1];
    reg  [31:0]   output_1_mem        [0:DATA_LENGTH-1];
    reg  [31:0]   output_2_mem        [0:DATA_LENGTH-1];

    // Reg from files
    reg  [31:0]   r1_mem              [0:DATA_LENGTH-1];
    reg  [31:0]   r2_mem              [0:DATA_LENGTH-1];
    reg  [31:0]   x1_mem              [0:DATA_LENGTH-1];
    reg  [31:0]   y1_mem              [0:DATA_LENGTH-1];
    reg  [31:0]   x2_mem              [0:DATA_LENGTH-1];
    reg  [31:0]   y2_mem              [0:DATA_LENGTH-1];
    reg  [31:0]   x3_mem              [0:DATA_LENGTH-1];
    reg  [31:0]   y3_mem              [0:DATA_LENGTH-1];

	
	// Output goldens
	reg           done_keyshift_golden, done_control_golden, all_done_golden;
    reg  [1:0]    op_s_golden;
	reg  [31:0]   px_mont_golden, py_mont_golden, output_1_golden, output_2_golden;
	
	reg           stop, over;
	integer       i, j, out_f, err, pattern_num;
	
	Control control0(
		.i_clk(clk),
		.i_reset(reset),
        .GFAU_done(gfau_done),
        .Keyshift_done(keyshift_done),
        .PartKey(partkey),
        .GFAU_result(gfau_result),
        .Px_mont(px_mont),
        .Py_mont(py_mont),
        .operation_select(op_s),
        .done_keyshift(done_keyshift),
        .done_control(done_control),
        .raw1(raw1),
        .raw2(raw2),
        .raw_prime(raw_prime),
        .raw_a(in_a),
        .output_1(output_1),
        .output_2(output_2),
        .all_done(all_done)
	);
	
	//Inputs
	initial $readmemh (`GFAU_DONE,  gfau_done_mem);
	initial $readmemh (`KEYSHIFT_DONE,  keyshift_done_mem);
	initial $readmemh (`PARTKEY,  partkey_mem);
	initial $readmemh (`GFAU_RESULT,  gfau_result_mem);
	initial $readmemh (`RAW1, raw1_mem);
    initial $readmemh (`RAW2, raw2_mem);
    initial $readmemh (`RAW_PRIME, raw_prime_mem);
    initial $readmemh (`IN_A, in_a_mem);

	
	//Outputs
	initial $readmemh (`DONE_KEYSHIFT, done_keyshift_mem);
	initial $readmemh (`DONE_CONTROL, done_control_mem);
    initial $readmemh (`ALL_DONE, all_done_mem);
    initial $readmemh (`OP_S, op_s_mem);
    initial $readmemh (`PX_MONT, px_mont_mem);
    initial $readmemh (`PY_MONT, py_mont_mem);
    initial $readmemh (`OUTPUT_1, output_1_mem);
    initial $readmemh (`OUTPUT_2, output_2_mem);

    //Registers
    initial $readmemh (`R1, r1_mem);
    initial $readmemh (`R2, r2_mem);
    initial $readmemh (`X1, x1_mem);
    initial $readmemh (`Y1, y1_mem);
    initial $readmemh (`X2, x2_mem);
    initial $readmemh (`Y2, y2_mem);
    initial $readmemh (`X3, x3_mem);
    initial $readmemh (`Y3, y3_mem);
    
	
	initial begin
		clk         = 1'b1;
		reset       = 1'b0;
		stop        = 1'b0;
		over        = 1'b0;
		pattern_num = 0;
		err         = 0;
		i           = 0;
		j           = 0;
		#2.5 reset=1'b1;
		#2.5 reset=1'b0;
	end
	
	always begin #(`CYCLE/2) clk = ~clk; end
	
	initial begin
		$dumpfile("Control.fsdb");
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
			gfau_done = gfau_done_mem[i];
			keyshift_done = keyshift_done_mem[i];
            partkey = partkey_mem[i];
            gfau_result = gfau_result_mem[i];
            raw1 = raw1_mem[i];
            raw2 = raw2_mem[i];
            raw_prime = raw_prime_mem[i];
            in_a = in_a_mem[i];

		// Get Output
			done_keyshift_golden = done_keyshift_mem[i];
            done_control_golden = done_control_mem[i];
            all_done_golden = all_done_mem[i];
            op_s_golden = op_s_mem[i];
            px_mont_golden = px_mont_mem[i];
            py_mont_golden = py_mont_mem[i];
            output_1_golden = output_1_mem[i];
            output_2_golden = output_2_mem[i];
        
        // Get registers
            r1 = r1_mem[i];
            r2 = r2_mem[i];
            x1 = x1_mem[i];
            x2 = x2_mem[i];
            x3 = x3_mem[i];
            y1 = y1_mem[i];
            y2 = y2_mem[i];
            y3 = y3_mem[i];

			i = i+1;
		end
		else stop = 1;
	end
	
	always @(posedge clk)begin
		if (done_control || done_keyshift || all_done) begin
			if( op_s !== op_s_golden || px_mont !== px_mont_golden || py_mont !== py_mont_golden ) begin
				if( op_s !== op_s_golden) begin
					$display("ERROR on Operation Select at %d:output %h !=expect %h ",pattern_num,op_s , op_s_golden);
					$display(out_f,"ERROR on Operation Select at %d:output %h !=expect %h ",pattern_num,op_s , op_s_golden);
				end
				if( px_mont !== px_mont_golden) begin
					$display("ERROR on Px_mont at %d:output %h !=expect %h ",pattern_num, px_mont , px_mont_golden);
					$display(out_f,"ERROR on Px_mont at %d:output %h !=expect %h ",pattern_num, px_mont , px_mont_golden);
				end
                if( py_mont !== py_mont_golden) begin
					$display("ERROR on Py_mont at %d:output %h !=expect %h ",pattern_num, py_mont , py_mont_golden);
					$display(out_f,"ERROR on Py_mont at %d:output %h !=expect %h ",pattern_num, py_mont , py_mont_golden);
				end
				err = err + 1;
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
