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

	parameter DATA_LENGTH = 9;
	parameter SIZE = 32;
	
    // Input registers
	reg           clk, reset, i_start;
	reg  [3:0]    a, prime, Px, Py, k;

    // Output wires
	wire [SIZE - 1:0]    kPx, kPy;
    wire [31:0]   raw1;


	
	// Inputs from files
	reg           start_mem           [0:DATA_LENGTH-1];
    reg  [3:0]    a_mem               [0:DATA_LENGTH-1];
    reg  [3:0]    prime_mem           [0:DATA_LENGTH-1];
    reg  [3:0]    px_mem              [0:DATA_LENGTH-1];
    reg  [3:0]    py_mem              [0:DATA_LENGTH-1];
    reg  [3:0]    k_mem               [0:DATA_LENGTH-1];


    // Outputs from files
    reg  [3:0]    kP_mem              [0:DATA_LENGTH-1];

    // correct results
    reg [31:0]    result_x_mem        [0:DATA_LENGTH-1];
    reg [31:0]    result_y_mem        [0:DATA_LENGTH-1];

	
	// correct results 
    reg  [31:0]    result_x_golden, result_y_golden;
	
	reg           stop, over;
	integer       i, j, out_f, err, pattern_num;
	
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
		// Get Input
			i_start = start_mem[i];
            a = a_mem[i];
            prime = prime_mem[i];
            Px = px_mem[i];
            Py = py_mem[i];
            k = k_mem[i];

		// Get correct results
			result_x_golden = result_x_mem[i];
            result_y_golden = result_y_mem[i];
		end
		else begin
            if (i == 10000) stop = 1;
            else stop = 0;
            // Input remain
			i_start = 0;
            a = a_mem[DATA_LENGTH-1];
            prime = prime_mem[DATA_LENGTH-1];
            Px = px_mem[DATA_LENGTH-1];
            Py = py_mem[DATA_LENGTH-1];
            k = k_mem[DATA_LENGTH-1];

		    // Get correct results
			result_x_golden = result_x_mem[DATA_LENGTH-1];
            result_y_golden = result_y_mem[DATA_LENGTH-1];
        end
        i = i+1;
	end
	
    initial begin
		@(posedge stop)
        $display("---------------------------------------------\n");
        $display("--------------------END----------------------\n");
        $display("---------------------------------------------\n");
		$finish;
	end
	
	
endmodule
