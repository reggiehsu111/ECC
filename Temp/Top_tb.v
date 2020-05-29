`timescale 1ns/10ps
`define CYCLE    100
//`define SDFFILE    "./top_alu.sdf"	

// Files for input ports
`define START                      "sim_data/top/start.dat"
`define IN_A                       "sim_data/top/a.dat"
`define PRIME                      "sim_data/top/prime.dat"
`define PX                         "sim_data/top/px.dat"
`define PY                         "sim_data/top/py.dat"
`define KEY                        "sim_data/top/key.dat"


// correct results
`define RESULT_X                   "sim_data/top/result_x.dat"
`define RESULT_Y                   "sim_data/top/result_y.dat"


module Top_test();

	parameter DATA_LENGTH = 10;
	parameter DATA_CYCLES = 9;
	parameter TOTAL_LENGTH = DATA_LENGTH * DATA_CYCLES;
	parameter SIZE = 32;
	
    // Input registers
	reg           clk, reset, i_start;
	reg  [3:0]    a, prime, Px, Py, k;

    // Output wires
	wire [SIZE - 1:0]    kPx, kPy, final_output_1, final_output_2;
    wire [31:0]   raw1;
	wire final_done;


	
	// Inputs from files
	reg           start_mem           [0:TOTAL_LENGTH-1];
    reg  [3:0]    a_mem               [0:TOTAL_LENGTH-1];
    reg  [3:0]    prime_mem           [0:TOTAL_LENGTH-1];
    reg  [3:0]    px_mem              [0:TOTAL_LENGTH-1];
    reg  [3:0]    py_mem              [0:TOTAL_LENGTH-1];
    reg  [3:0]    k_mem               [0:TOTAL_LENGTH-1];


    // Outputs from files
    reg  [3:0]    kP_mem              [0:TOTAL_LENGTH-1];

    // correct results
    reg [31:0]    result_x_mem        [0:TOTAL_LENGTH-1];
    reg [31:0]    result_y_mem        [0:TOTAL_LENGTH-1];

	
	// correct results 
    reg  [31:0]    result_x_golden, result_y_golden;
	
	reg           stop, over;
	integer       i, j, out_f, err, pattern_num, data_num;
	
	Top_ting top0(
		.i_clk(clk),
		.i_rst(reset),
        .i_start(i_start),
        .a(a),
        .prime(prime),
        .k(k),
        .Px(Px),
        .Py(Py),
        .kPx(kPx),
        .kPy(kPy),
		.final_output_1(final_output_1),
		.final_output_2(final_output_2),
		.final_done(final_done),
        .raw1(raw1)
	);
	
	//Inputs
	initial $readmemh (`START,  start_mem);
    initial $readmemh (`IN_A, a_mem);
    initial $readmemh (`PRIME, prime_mem);
    initial $readmemh (`PX, px_mem);
    initial $readmemh (`PY, py_mem);
    initial $readmemh (`KEY, k_mem);

	
	//Correct results
	initial $readmemh (`RESULT_X, result_x_mem);
    initial $readmemh (`RESULT_Y, result_y_mem);

	
	/*`ifdef SDF
    initial $sdf_annotate(`SDFFILE, top0);
	`endif*/	
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
		$dumpfile("Top_final.fsdb");
		$dumpvars;
	
		out_f = $fopen("out.dat");
		if (out_f == 0) begin
			$display("Output file open error !");
			$finish;
		end
	end
	
	always @(posedge clk)begin
		if (i<DATA_LENGTH) begin
			// $display(i, j);
			if (j<DATA_CYCLES) begin
				if (reset == 1) reset = 0;
				data_num = i*DATA_CYCLES + j;
			// Get Input
				i_start = start_mem[data_num];
				a = a_mem[data_num];
				prime = prime_mem[data_num];
				Px = px_mem[data_num];
				Py = py_mem[data_num];
				k = k_mem[data_num];

			// Get correct results
				result_x_golden = result_x_mem[data_num];
				result_y_golden = result_y_mem[data_num];

				j = j + 1;
				if (final_done) begin
					j = 0;
					i = i + 1;
					reset = 1;
				end
			end
			else begin
				// Get Input
				i_start = start_mem[data_num];
				a = a_mem[data_num];
				prime = prime_mem[data_num];
				Px = px_mem[data_num];
				Py = py_mem[data_num];
				k = k_mem[data_num];
				j = j + 1;

			// Get correct results
				result_x_golden = result_x_mem[data_num];
				result_y_golden = result_y_mem[data_num];
				if (final_done || j == 15000) begin
					j = 0;
					i = i + 1;
					reset = 1;
				end
			end
		end
		else begin
            stop = 1;
        end
	end
	always @(posedge clk)begin
		if (final_done) begin
			if( result_x_golden !== final_output_1 || result_y_golden !== final_output_2 ) begin
				if( result_x_golden !== final_output_1) begin
					$display("ERROR on Px output at %d:output %h !=expect %h ",pattern_num,final_output_1 , result_x_golden);
					$display(out_f,"ERROR on Px output at %d:output %h !=expect %h ",pattern_num,final_output_1 , result_x_golden);
				end
				if( result_y_golden !== final_output_2) begin
					$display("ERROR on Py output at %d:output %h !=expect %h ",pattern_num, final_output_2 , result_y_golden);
					$display(out_f,"ERROR on Py output at %d:output %h !=expect %h ",pattern_num, final_output_2 , result_y_golden);
				end
				err = err + 1;
			end
			pattern_num = pattern_num + 1;
			if(pattern_num === 1)  over = 1'b1;
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
            $display("-------------------FAIL-------------------\n");
            $display("---------------------------------------------\n");
          end
          $finish;
    end
	
	
endmodule
