module Top_ting(
	i_rst,
	i_clk,
	i_start,
	a,
	prime,
	k,
	Px,
	Py,
	kPx,
	kPy,
	raw1);
	
	localparam SIZE = 32;
	localparam IDLE = 0;
	input i_rst, i_clk, i_start;
	input [3 : 0] a, prime, Px, Py, k;

	output [SIZE - 1 : 0] kPx, kPy;
	output [SIZE - 1 : 0] raw1;
	
	//////////GFAU vs. Control//////////
	wire GFAU_done_to_control, GFAU_done_from_control;
	wire [SIZE - 1 : 0] Px_mont, Py_mont;
	wire [SIZE - 1 : 0] GFAU_out;
	wire [1 : 0] operation_select;
	////////////////////////////////////

	//////////key shift vs. Control//////////
	wire key_shift_done_to_control, key_shift_from_control;
	wire key_from_key_shift;
	/////////////////////////////////////////


	//////////Else//////////
	wire [SIZE - 1 : 0] raw1, raw2, raw_prime, raw_a, raw_k;
	wire [SIZE - 1 : 0] final_output_1, final_output_2;
	wire final_done;
	wire load_done;

	reg [3 : 0] state, state_n;
	reg [SIZE - 1 : 0] raw1_r, raw2_r, raw_prime_r, raw_a_r, k_r;
	reg [SIZE - 1 : 0] raw1_r_n, raw2_r_n, raw_prime_r_n, raw_a_r_n, k_r_n;
	reg load_done_r;
	////////////////////////

	assign raw1 = raw1_r;
	assign raw2 = raw2_r;
	assign raw_prime = raw_prime_r;
	assign raw_a = raw_a_r;
	assign raw_k = k_r;
	assign load_done = load_done_r;


	always @(*) begin
		case(state)
			0: begin
				state_n = state;
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				load_done_r = 0;
				if (i_start == 1) begin
					state_n = 1;

					raw1_r_n[3 : 0] = Px;
					raw2_r_n[3 : 0] = Py;
					raw_prime_r_n[3 : 0] = prime;
					raw_a_r_n[3 : 0] = a;
					k_r_n[3 : 0] = k;

					raw1_r_n[31 : 4] = raw1_r[31 : 4];
					raw2_r_n[31 : 4] = raw2_r[31 : 4];
					raw_prime_r_n[31 : 4] = raw_prime_r[31 : 4];
					raw_a_r_n[31 : 4] = raw_a_r[31 : 4];
					k_r_n[31 : 4] = k_r[31 : 4];
				end
			end
			1: begin
				state_n = 2;

				raw1_r_n[3 : 0] = raw1_r[3 : 0];
				raw2_r_n[3 : 0] = raw2_r[3 : 0];
				raw_prime_r_n[3 : 0] = raw_prime_r[3 : 0];
				raw_a_r_n[3 : 0] = raw_a_r[3 : 0];
				k_r_n[3 : 0] = k_r[3 : 0];

				raw1_r_n[7 : 4] = Px;
				raw2_r_n[7 : 4] = Py;
				raw_prime_r_n[7 : 4] = prime;
				raw_a_r_n[7 : 4] = a;
				k_r_n[7 : 4] = k;

				raw1_r_n[31 : 8] = raw1_r[31 : 8];
				raw2_r_n[31 : 8] = raw2_r[31 : 8];
				raw_prime_r_n[31 : 8] = raw_prime_r[31 : 8];
				raw_a_r_n[31 : 8] = raw_a_r[31 : 8];
				k_r_n[31 : 8] = k_r[31 : 8];

				load_done_r = 0;
			end
			2: begin
				state_n = 3;

				raw1_r_n[7 : 0] = raw1_r[7 : 0];
				raw2_r_n[7 : 0] = raw2_r[7 : 0];
				raw_prime_r_n[7 : 0] = raw_prime_r[7 : 0];
				raw_a_r_n[7 : 0] = raw_a_r[7 : 0];
				k_r_n[7 : 0] = k_r[7 : 0];

				raw1_r_n[11 : 8] = Px;
				raw2_r_n[11 : 8] = Py;
				raw_prime_r_n[11 : 8] = prime;
				raw_a_r_n[11 : 8] = a;
				k_r_n[11 : 8] = k;

				raw1_r_n[31 : 12] = raw1_r[31 : 12];
				raw2_r_n[31 : 12] = raw2_r[31 : 12];
				raw_prime_r_n[31 : 12] = raw_prime_r[31 : 12];
				raw_a_r_n[31 : 12] = raw_a_r[31 : 12];
				k_r_n[31 : 12] = k_r[31 : 12];

				load_done_r = 0;
			end
			3: begin
				state_n = 4;

				raw1_r_n[11 : 0] = raw1_r[11 : 0];
				raw2_r_n[11 : 0] = raw2_r[11 : 0];
				raw_prime_r_n[11 : 0] = raw_prime_r[11 : 0];
				raw_a_r_n[11 : 0] = raw_a_r[11 : 0];
				k_r_n[11 : 0] = k_r[11 : 0];

				raw1_r_n[15 : 12] = Px;
				raw2_r_n[15 : 12] = Py;
				raw_prime_r_n[15 : 12] = prime;
				raw_a_r_n[15 : 12] = a;
				k_r_n[15 : 12] = k;

				raw1_r_n[31 : 16] = raw1_r[31 : 16];
				raw2_r_n[31 : 16] = raw2_r[31 : 16];
				raw_prime_r_n[31 : 16] = raw_prime_r[31 : 16];
				raw_a_r_n[31 : 16] = raw_a_r[31 : 16];
				k_r_n[31 : 16] = k_r[31 : 16];

				load_done_r = 0;
			end
			4: begin
				state_n = 5;

				raw1_r_n[15 : 0] = raw1_r[15 : 0];
				raw2_r_n[15 : 0] = raw2_r[15 : 0];
				raw_prime_r_n[15 : 0] = raw_prime_r[15 : 0];
				raw_a_r_n[15 : 0] = raw_a_r[15 : 0];
				k_r_n[15 : 0] = k_r[15 : 0];

				raw1_r_n[19 : 16] = Px;
				raw2_r_n[19 : 16] = Py;
				raw_prime_r_n[19 : 16] = prime;
				raw_a_r_n[19 : 16] = a;
				k_r_n[19 : 16] = k;

				raw1_r_n[31 : 20] = raw1_r[31 : 20];
				raw2_r_n[31 : 20] = raw2_r[31 : 20];
				raw_prime_r_n[31 : 20] = raw_prime_r[31 : 20];
				raw_a_r_n[31 : 20] = raw_a_r[31 : 20];
				k_r_n[31 : 20] = k_r[31 : 20];

				load_done_r = 0;
			end
			5: begin
				state_n = 6;

				raw1_r_n[19 : 0] = raw1_r[19 : 0];
				raw2_r_n[19 : 0] = raw2_r[19 : 0];
				raw_prime_r_n[19 : 0] = raw_prime_r[19 : 0];
				raw_a_r_n[19 : 0] = raw_a_r[19 : 0];
				k_r_n[19 : 0] = k_r[19 : 0];

				raw1_r_n[23 : 20] = Px;
				raw2_r_n[23 : 20] = Py;
				raw_prime_r_n[23 : 20] = prime;
				raw_a_r_n[23 : 20] = a;
				k_r_n[23 : 20] = k;

				raw1_r_n[31 : 24] = raw1_r[31 : 24];
				raw2_r_n[31 : 24] = raw2_r[31 : 24];
				raw_prime_r_n[31 : 24] = raw_prime_r[31 : 24];
				raw_a_r_n[31 : 24] = raw_a_r[31 : 24];
				k_r_n[31 : 24] = k_r[31 : 24];

				load_done_r = 0;
			end
			6: begin
				state_n = 7;

				raw1_r_n[23 : 0] = raw1_r[23 : 0];
				raw2_r_n[23 : 0] = raw2_r[23 : 0];
				raw_prime_r_n[23 : 0] = raw_prime_r[23 : 0];
				raw_a_r_n[23 : 0] = raw_a_r[23 : 0];
				k_r_n[23 : 0] = k_r[23 : 0];

				raw1_r_n[27 : 24] = Px;
				raw2_r_n[27 : 24] = Py;
				raw_prime_r_n[27 : 24] = prime;
				raw_a_r_n[27 : 24] = a;
				k_r_n[27 : 24] = k;

				raw1_r_n[31 : 28] = raw1_r[31 : 28];
				raw2_r_n[31 : 28] = raw2_r[31 : 28];
				raw_prime_r_n[31 : 28] = raw_prime_r[31 : 28];
				raw_a_r_n[31 : 28] = raw_a_r[31 : 28];
				k_r_n[31 : 28] = k_r[31 : 28];

				load_done_r = 0;
			end
			7: begin
				state_n = 8;

				raw1_r_n[27 : 0] = raw1_r[27 : 0];
				raw2_r_n[27 : 0] = raw2_r[27 : 0];
				raw_prime_r_n[27 : 0] = raw_prime_r[27 : 0];
				raw_a_r_n[27 : 0] = raw_a_r[27 : 0];
				k_r_n[27 : 0] = k_r[27 : 0];

				raw1_r_n[31 : 28] = Px;
				raw2_r_n[31 : 28] = Py;
				raw_prime_r_n[31 : 28] = prime;
				raw_a_r_n[31 : 28] = a;
				k_r_n[31 : 28] = k;

				load_done_r = 0;
			end
			8: begin
				state_n = 8;

				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;

				load_done_r = 1;
			end

			default: begin
				state_n = 0;

				raw1_r_n = 0;
				raw2_r_n = 0;
				raw_prime_r_n = 0;
				raw_a_r_n = 0;
				k_r_n = 0;

				load_done_r = 0;
			end
		endcase
	end

	always @(posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			state <= 0;
			raw1_r <= 0;
			raw2_r <= 0;
			raw_prime_r <= 0;
			raw_a_r <= 0;
			k_r <= 0;
		end
		else begin
			state <= state_n;
			raw1_r <= raw1_r_n;
			raw2_r <= raw2_r_n;
			raw_prime_r <= raw_prime_r_n;
			raw_a_r <= raw_a_r_n;
			k_r <= k_r_n;
		end
	end

	

	Control control_0 (.i_clk(i_clk), .i_reset(i_rst), .GFAU_done(GFAU_done_to_control), 
					   .Keyshift_done(key_shift_done_to_control), .PartKey(key_from_key_shift), 
					   .GFAU_result(GFAU_out), .Px_mont(Px_mont), .Py_mont(Py_mont),
					   .operation_select(operation_select), 
					   .done_keyshift(key_shift_done_from_control), 
					   .done_control(GFAU_done_from_control),
					   .raw1(raw1), .raw2(raw2), .raw_prime(raw_prime), .raw_a(raw_a), .load_done(load_done),
					   .output_1(final_output_1), .output_2(final_output_2), 
					   .all_done(final_done));

	GFAU GFAU_0 (.i_clk(i_clk), .i_rst(i_rst), .in_0(Px_mont), .in_1(Py_mont), .prime(raw_prime), 
				 .operation_select(operation_select),
				 .GFAU_done_from_control(GFAU_done_from_control), .result(GFAU_out), 
				 .GFAU_done_to_control(GFAU_done_to_control));

	key_shift key_shift_0 (.i_clk(i_clk), .i_rst(i_rst), .k(raw_k), 
						   .key_shift_done_from_control(key_shift_done_from_control), 
						   .k_out(key_from_key_shift), 
						   .key_shift_done_to_control(key_shift_done_to_control));

endmodule