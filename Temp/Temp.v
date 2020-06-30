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
    done
    );
	
	localparam SIZE = 32;
	localparam IDLE = 0;
	input i_rst, i_clk, i_start;
	input [3 : 0] a, prime, Px, Py, k;

	output reg [3 : 0] kPx, kPy;
    output done;
	

	//////////GFAU vs. Control//////////
	wire GFAU_done_to_control, GFAU_done_from_control;
	wire [SIZE - 1 : 0] Px_mont, Py_mont, final_output_1, final_output_2;
	wire [SIZE - 1 : 0] GFAU_out;
	wire [1 : 0] operation_select;
    wire final_done;
	////////////////////////////////////

	//////////key shift vs. Control//////////
	wire key_shift_done_to_control, key_shift_done_from_control;
	wire key_from_key_shift;
	/////////////////////////////////////////


	//////////Else//////////
	wire [SIZE - 1 : 0] raw1, raw2, raw_prime, raw_a, raw_k;
	wire load_done;

	reg [4 : 0] state, state_n;
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
    assign done = final_done;


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
				kPx = 0;
				kPy = 0;
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
				kPx = 0;
				kPy = 0;
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
				kPx = 0;
				kPy = 0;
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
				kPx = 0;
				kPy = 0;
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
				kPx = 0;
				kPy = 0;
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
				kPx = 0;
				kPy = 0;
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
				kPx = 0;
				kPy = 0;
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
				kPx = 0;
				kPy = 0;
			end
			8: begin
				state_n = 8;

				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;

				load_done_r = 1;
				kPx = 0;
				kPy = 0;
				if (final_done == 1) begin
					state_n = 9;
				end
			end
			9: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 10;
				load_done_r = 0;
				kPx = final_output_1[3 : 0];
				kPy = final_output_2[3 : 0];
			end
			10: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 11;
				load_done_r = 0;
				kPx = final_output_1[7 : 4];
				kPy = final_output_2[7 : 4];
			end

			11: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 12;
				load_done_r = 0;
				kPx = final_output_1[11 : 8];
				kPy = final_output_2[11 : 8];
			end

			12: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 13;
				load_done_r = 0;
				kPx = final_output_1[15 : 12];
				kPy = final_output_2[15 : 12];
			end

			13: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 14;
				load_done_r = 0;
				kPx = final_output_1[19 : 16];
				kPy = final_output_2[19 : 16];
			end

			14: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 15;
				load_done_r = 0;
				kPx = final_output_1[23 : 20];
				kPy = final_output_2[23 : 20];
			end

			15: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 16;
				load_done_r = 0;
				kPx = final_output_1[27 : 24];
				kPy = final_output_2[27 : 24];
			end
			16: begin
				raw1_r_n = raw1_r;
				raw2_r_n = raw2_r;
				raw_prime_r_n = raw_prime_r;
				raw_a_r_n = raw_a_r;
				k_r_n = k_r;
				state_n = 0;
				load_done_r = 0;
				kPx = final_output_1[31 : 28];
				kPy = final_output_2[31 : 28];
			end
			default: begin
				state_n = 0;

				raw1_r_n = 0;
				raw2_r_n = 0;
				raw_prime_r_n = 0;
				raw_a_r_n = 0;
				k_r_n = 0;
				kPx = 0;
				kPy = 0;
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

module Control(i_clk, i_reset,
                GFAU_done, Keyshift_done,
                PartKey, GFAU_result,
                Px_mont, Py_mont, operation_select,
                done_keyshift, done_control,
                raw1, raw2, raw_prime, raw_a, load_done,
                output_1, output_2, all_done
                );
  /*========================IO declaration============================ */	 
    input i_clk;
    input i_reset;

    input GFAU_done;                        // done signal from GFAU
    input Keyshift_done;                    // done signal from  key shifter

    input PartKey;                          // single bit for key
    input [31:0] GFAU_result;               // Result from GFAU

    input [31:0] raw1, raw2, raw_prime, raw_a;     // non-transferred input and prime

    input load_done;

    output [31:0] Px_mont, Py_mont;         // transferred inputs To GFAU
    output [1:0] operation_select;          // 00, 01, 10, 11 add, subtract, multiple, divide
    output done_keyshift;                   // done signal to key shifter for completion of add or double
    output done_control;                    // done signal to GFAU for finishing saving the return value to register

    output [31:0] output_1, output_2;       // final output to Top(be inverse transferred)
    output all_done;                        // kP is finally computed singal to Top

  /*========================Wire and Reg======================== */	  
     
    reg all_done_r;
    reg all_done_rn;
    reg in_sig;    
    reg in_sig_n;                         

    wire [31:0] i1_w, i2_w;
    wire Transfer_done_w0, Transfer_done_w1;
    wire in_sig_w;

    reg [31:0] x1, y1, x2, y2;
    reg [31:0] x1_n, y1_n, x2_n, y2_n;              // inputs for Add and Double
    reg [4:0] state;                        // state machine
    reg [4:0] next_state;

    reg [31:0] Px_mont_r;
    reg [31:0] Py_mont_r;
    
    reg [1:0] instruction;
    reg [31:0] r1, r2;
    reg [31:0] r1_n, r2_n;

    reg [31:0] x3,y3;
    reg [31:0] x3_n, y3_n;
    
    wire [31:0] x3_w, y3_w;

    reg done_control_r;                     //connect to output wire
    reg done_keyshift_r;                    // connect to output wire
    
    reg [4:0] key_counter;                  // counter for keyshifter is whether finish
    reg [4:0] key_counter_n;

    reg [31:0] a, a_n;

    wire [31:0] transferred_a_w0, transferred_a_w1;

    Domain_Transfer d0(i_clk, i_reset, 1'b1, in_sig_w, raw1, raw2, raw_a, raw_prime, i1_w, i2_w, transferred_a_w0, Transfer_done_w0);
    Domain_Transfer d1(i_clk, i_reset, 1'b0, in_sig_w, x3_w, y3_w, raw_a, raw_prime, output_1, output_2, transferred_a_w1, Transfer_done_w1);

/*====================assign output wires to the register=========================*/

    assign x3_w = x3;
    assign y3_w = y3;
    assign Px_mont = Px_mont_r;
    assign Py_mont = Py_mont_r;
    assign operation_select = instruction;
    assign done_control = done_control_r;
    assign done_keyshift = done_keyshift_r;
    assign in_sig_w = in_sig;
    assign all_done = all_done_r;
/*==========================next state logic=========================*/
    
    always@(*)
    begin
        case(state)
            0: begin
                done_control_r = 0;
                done_keyshift_r = 0;
                in_sig_n = 0;
                a_n = a;
                Px_mont_r = 0;
                Py_mont_r = 0;
                instruction = 0;                    
                if(Transfer_done_w0 == 1 || Transfer_done_w1 == 1) begin                    
                    if(key_counter == 31) begin   // this will be changed to the length of Key                     
                        all_done_rn = 1;
                        r1_n = r1; 
                        r2_n = r2; 
                        x1_n = x1; 
                        y1_n = y1; 
                        x2_n = x2; 
                        y2_n = y2; 
                        x3_n = x3; 
                        y3_n = y3;
                        next_state = 0;
                        key_counter_n = 0;
                        a_n = a;
                    end
                    else begin                            
                        all_done_rn = 0;
                        a_n = transferred_a_w0;
                        r1_n = i1_w; 
                        r2_n = i2_w;
                        x1_n = x1; 
                        y1_n = y1; 
                        x2_n = i1_w; 
                        y2_n = i2_w; 
                        x3_n = x3; 
                        y3_n = y3;
                        done_keyshift_r = 1;
                        next_state = 0;
                        key_counter_n = key_counter;
                    end                        
                end

                else begin                
                    all_done_rn = 0;
                    a_n = a;
                    if(key_counter == 31) begin// this will be change to the length of Key                        
                        next_state = 0;
                        r1_n = r1; 
                        r2_n = r2; 
                        x1_n = x1; 
                        y1_n = y1; 
                        x2_n = x2; 
                        y2_n = y2; 
                        x3_n = x3; 
                        y3_n = y3;
                        key_counter_n = key_counter;
                        if (in_sig == 0) begin
                            in_sig_n = 1;
                        end
                        else begin 
                            in_sig_n = 0;
                        end
                    end
                    else begin                         
                        if(Keyshift_done == 1) begin                            
                            in_sig_n = in_sig;
                            r1_n = r1; 
                            r2_n = r2; 
                            x1_n = r1; 
                            y1_n = r2; 
                            x2_n = x2; 
                            y2_n = y2; 
                            x3_n = x3; 
                            y3_n = y3;
                            key_counter_n = key_counter;
                            /*if(key_counter == 0)begin
                                next_state = 0;
                                done_keyshift_r = 1;
                                key_counter_n = ; 
                                x3_n = r1;
                                y3_n = r2;
                            end*/
                            //else begin
                            next_state = 1;
                            //end  
                        end
                        else begin                            
                            in_sig_n = in_sig;
                            r1_n = r1; 
                            r2_n = r2; 
                            x1_n = x1; 
                            y1_n = y1; 
                            x2_n = x2; 
                            y2_n = y2; 
                            x3_n = x3; 
                            y3_n = y3;
                            next_state = 0;
                            key_counter_n = key_counter;
                        end
                    end
                end              
            end
            1:
                begin
                    Px_mont_r = x1;
                    Py_mont_r = x1;
                    instruction = 2'b10; //multi
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 2; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            2:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r1;
                    instruction = 2'b00; // add
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 3; 
                            r1_n = r1;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            3:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b00;//add
                    done_control_r = 1; 
                    done_keyshift_r = 0;
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 4; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            4:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = a;
                    instruction = 2'b00;//add
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 5; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            5:
                 begin
                    Px_mont_r = y1;
                    Py_mont_r = y1;
                    instruction = 2'b00;//add
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 6; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            6:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b11;//divide
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 7; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            7:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = r1;
                    instruction = 2'b10;//multi
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 8; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            8:
                 begin
                    Px_mont_r = r2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 9; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            9:
                 begin
                    Px_mont_r = r2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 10; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                            x3_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                           x3_n = x3;
                       end
                end
            10:
                 begin
                    Px_mont_r = x1;
                    Py_mont_r = r2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 11; 
                            r1_n = r1;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            11:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b10;//multi
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 12; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            12: begin                
                Px_mont_r = r1;
                Py_mont_r = y1;
                instruction = 2'b01;//minus
                done_control_r = 1; 
                done_keyshift_r = 0; 
                in_sig_n = in_sig; 
                all_done_rn = 0; 
                a_n = a;
                if(GFAU_done == 1) begin
                    done_control_r = 0;
                    y3_n = GFAU_result;
                    if(PartKey == 1) begin                        
                        next_state = 13;
                        r2_n = GFAU_result;//it's not correct but next state will reset
                        r1_n = r1;// it's not correct but next state will reset
                        x1_n = x3; 
                        y1_n = GFAU_result;
                        x2_n = x2; 
                        y2_n = y2; 
                        x3_n = x3;
                        key_counter_n = key_counter;
                    end
                    else begin
                        r1_n = x3;
                        r2_n = GFAU_result;
                        x1_n = x1; 
                        y1_n = y1; 
                        x2_n = x2; 
                        y2_n = y2; 
                        x3_n = x3;
                        done_keyshift_r = 1;
                        key_counter_n = key_counter + 1;
                        next_state = 0;
                    end
                end
                else begin                   
                   next_state = state;
                   r1_n = r1;
                   r2_n = r2;
                   x1_n = x1; 
                   y1_n = y1; 
                   x2_n = x2; 
                   y2_n = y2; 
                   x3_n = x3; 
                   y3_n = y3;
                   key_counter_n = key_counter;
                end
            end
/*===========================addition control================================*/                            
            13:
                begin
                    Px_mont_r = x2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 14; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
               
            14:
                begin
                    Px_mont_r = y2;
                    Py_mont_r = y1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 15; 
                            r1_n = r1;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            15:
                begin
                    Px_mont_r = r2;
                    Py_mont_r = r1;
                    instruction = 2'b11;//multi
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 16; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            16:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r1;
                    instruction = 2'b10;//multi
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 17; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            17:
                begin
                    Px_mont_r = r2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 18; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            18:
                begin
                    Px_mont_r = r2;
                    Py_mont_r = x2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2;  
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 19; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                            x3_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                           x3_n = x3;
                       end
                end
            19:
                begin
                    Px_mont_r = x1;
                    Py_mont_r = r2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 20; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            20:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b10;//multi
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3;
                    y3_n = y3; 
                    a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 21; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            21:
               begin
                    Px_mont_r = r2;
                    Py_mont_r = y1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; 
                    done_keyshift_r = 0; 
                    in_sig_n = in_sig; 
                    all_done_rn = 0;
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    a_n = a;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 0; 
                            done_keyshift_r = 1;
                            key_counter_n = key_counter + 1;
                            y3_n = GFAU_result;
                            r1_n = x3;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                           y3_n = y3;
                           key_counter_n = key_counter;
                       end
                end
            22:
                begin
                    key_counter_n = 0;
                    r1_n = r1; 
                    r2_n = r2; 
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    Px_mont_r = 0; 
                    Py_mont_r = 0;
                    all_done_rn = 0;
                    done_control_r = 0; 
                    done_keyshift_r = 0;
                    in_sig_n = 1;
                    next_state = 0;
                    instruction = 0;
                    if (load_done == 0) begin
                        in_sig_n = 0;
                        next_state = 22;
                    end
                end
               	default: begin
               		r1_n = r1; 
                    r2_n = r2; 
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3;
                    a_n = a;
                    next_state = 0;
                    key_counter_n = key_counter;
                    in_sig_n = in_sig;
                    all_done_rn = all_done_r;
                    Px_mont_r = 0;
                    Py_mont_r = 0;
                    done_keyshift_r = 0;
                    done_control_r = 0;
                    instruction = 0;

               	end
        endcase
    end

/* ====================Sequential Part=================== */

always@(posedge  i_clk or posedge i_reset)
    begin
        if (i_reset)
            begin
                r1              <= 0;
                r2              <= 0;
                state           <= 22;
                key_counter     <= key_counter_n;
                in_sig          <= 0;
                key_counter     <= 5'b00000;
                all_done_r      <= 0;
                x1              <= 0;
                x2              <= 0;
                y1              <= 0;
                y2              <= 0;
                x3              <= 0;
                y3              <= 0;
                a               <= 0; 
            end
        else
            begin
                r1              <= r1_n;
                r2              <= r2_n;
                state           <= next_state;  
                key_counter     <= key_counter_n;
                in_sig          <= in_sig_n;
                all_done_r      <= all_done_rn;
                x1              <= x1_n;
                x2              <= x2_n;
                y1              <= y1_n;
                y2              <= y2_n;
                x3              <= x3_n;
                y3              <= y3_n;
                a               <= a_n;    
            end
    end

endmodule

module Domain_Transfer(clk, reset, ToMont, in_sig, Px_i, Py_i, A_i, Prime, Px_out, Py_out, A_out, done);      
    input clk, reset, ToMont, in_sig;
    input [31:0] Px_i, Py_i, Prime, A_i; 
    output [31:0] Px_out, Py_out, A_out;
    output done;

    reg [31:0] Px, Py, A, Px_nxt, Py_nxt, A_nxt;
    reg [1:0] state, state_nxt;
    reg [4:0] counter, counter_nxt;
    reg done_reg;

    wire [32:0] Px_shift, Py_shift, A_shift;
    wire [32:0] Px_add, Py_add, A_add;

    parameter IDLE = 2'b00;
    parameter TO_MONT = 2'b01;
    parameter TO_REGULAR = 2'b10;
    parameter OUT = 2'b11;

    assign A_out = A;
    assign Px_out = Px;
    assign Py_out = Py;

    assign Px_shift = Px << 1;
    assign Py_shift = Py << 1;
    assign A_shift = A << 1;
    assign done = done_reg;
    assign Px_add = Px + Prime;
    assign Py_add = Py + Prime;
    assign A_add = A + Prime;

    always @(*) begin
      case(state)
          IDLE: begin
            if(in_sig) begin
              if(ToMont) state_nxt = TO_MONT;
              else state_nxt = TO_REGULAR;
            end
            else state_nxt = IDLE;
          end
          TO_MONT: begin
            if (counter != 5'b11111) state_nxt = TO_MONT;
                else state_nxt = OUT;
          end
          TO_REGULAR: begin
            if (counter != 5'b11111) state_nxt = TO_REGULAR;
                else state_nxt = OUT;
          end
          OUT: state_nxt = IDLE;
      endcase
    end

    always @(*) begin
        case(state)
            TO_MONT: counter_nxt = counter + 1;
            TO_REGULAR: counter_nxt = counter + 1;
            OUT: counter_nxt = counter;
            default: counter_nxt = 0;
        endcase
    end

    always @(*) begin
        case(state)
          IDLE: begin
            done_reg = 0;
            if(in_sig) begin
              if(Px_i >= Prime) Px_nxt = Px_i - Prime;
              else Px_nxt = Px_i;
              if(Py_i >= Prime) Py_nxt = Py_i - Prime;
              else Py_nxt = Py_i;
              if (A_i >= Prime) A_nxt = A_i - Prime;
              else A_nxt = A_i;
            end
            else begin
              Px_nxt = Px;
              Py_nxt = Py;
              A_nxt = A;
            end
          end
          TO_MONT: begin
            done_reg = 0;
            if (Px_shift >= Prime) Px_nxt = Px_shift - Prime;
            else Px_nxt = Px_shift;
            if(Py_shift >= Prime) Py_nxt = Py_shift - Prime;
            else Py_nxt = Py_shift;
            if(A_shift >= Prime) A_nxt = A_shift - Prime;
            else A_nxt = A_shift;
          end
          TO_REGULAR: begin
            done_reg = 0;
            if (Px[0]) Px_nxt = Px_add >> 1;
            else Px_nxt = Px >> 1;
            if (Py[0]) Py_nxt = Py_add >> 1;
            else Py_nxt = Py >> 1;
            if (A[0]) A_nxt = A_add >> 1;
            else A_nxt = A >> 1;
          end
          OUT: begin
            Px_nxt = Px;
            Py_nxt = Py;
            A_nxt = A;
            done_reg = 1;
          end
        endcase
            /*if (counter == 5'b11111) done_reg <= 1'b1;
            else done_reg <= 1'b0;*/
    end

      /* ====================Sequential Part=================== */
    always@(posedge clk or posedge reset)
    begin
        if (reset)
        begin
              Px <= 32'b0;
              Py <= 32'b0;
              A <= 32'b0;
              counter <= 5'b0;
              state <= 1'b0;
        end
        else
        begin
          Px <= Px_nxt;
          Py <= Py_nxt;
          A <= A_nxt;
          counter <= counter_nxt;
          state <= state_nxt;
        end
    end
  /* ====================================================== */
endmodule

module key_shift(
	i_clk,
	i_rst,
	k,
	key_shift_done_from_control,
	k_out,
	key_shift_done_to_control);
	localparam SH_NUM = 1;
	localparam SIZE = 32;
	localparam OUT_SIZE = 1;

	input i_clk, i_rst; 
	input [SIZE - 1 : 0] k;
	input key_shift_done_from_control;


	output k_out;
	output key_shift_done_to_control;

	reg [6:0] i, i_n;
	reg state, state_n;
	reg key_shift_done_to_control;

	assign k_out = k[i];
	//assign k_out = 0;
	//assign key_shift_done_to_control = key_shift_done_to_control; //key_shift_done_to_control_r;

	always @(*) begin
		case(state)
			0: begin
				state_n = 0;
				i_n = i;
				key_shift_done_to_control = 0;
				if (key_shift_done_from_control == 1) begin
					state_n = 1;
					i_n = i - 1;
				end
			end
			1: begin
				state_n = 0;
				i_n = i;
				key_shift_done_to_control = 1;
				/*if (key_shift_done_from_control == 1) begin
					state_n = 1;
				end*/
			end
		endcase
	end
	always@ (posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			i <= SIZE - 1;
			state <= 0;
		end
		else begin
			i <= i_n;
			state <= state_n;
		end
	end
endmodule 
module GFAU(
	i_clk,
	i_rst,
	in_0,
	in_1,
	prime,
	operation_select,
	GFAU_done_from_control,
	result,
	GFAU_done_to_control
	/*done_add,
	done_sub,
	done_mult,
	done_div,
	div_out
	R*/
	);

	localparam SIZE = 32;

	input i_clk, i_rst;
	input [SIZE - 1 : 0] in_0, in_1;
	input [SIZE - 1 : 0] prime;
    input [1 : 0] operation_select;
    input GFAU_done_from_control;

    output[SIZE - 1 : 0] result;
    output GFAU_done_to_control;
    //output done_add, done_sub, done_mult, done_div;
    //output [SIZE - 1 : 0] div_out;
    //output [SIZE : 0] R;
    //output [10 : 0] i;
    //output [SIZE - 1 : 0] mult_out;

    wire sel_add, sel_sub, sel_mult, sel_div;
    wire [SIZE - 1 : 0] add_out, sub_out, mult_out, div_out;
    wire done_add, done_sub, done_mult, done_div;
    

    assign sel_add = (operation_select == 2'd0 && GFAU_done_from_control == 1) ? 1 : 0;
    assign sel_sub = (operation_select == 2'd1 && GFAU_done_from_control == 1) ? 1 : 0;
    assign sel_mult = (operation_select == 2'd2 && GFAU_done_from_control == 1) ? 1 : 0;
    assign sel_div = (operation_select == 2'd3 && GFAU_done_from_control == 1) ? 1 : 0;

    add add_0 (.i_clk(i_clk), .i_rst(i_rst), .add_in_0(in_0), .add_in_1(in_1), .prime(prime),
    		   .sel_add(sel_add), .add_out(add_out), .done_add(done_add));
    sub sub_0 (.i_clk(i_clk), .i_rst(i_rst), .sub_in_0(in_0), .sub_in_1(in_1), .prime(prime),
    		   .sel_sub(sel_sub), .sub_out(sub_out), .done_sub(done_sub));
    mult mult_0 (.i_clk(i_clk), .i_rst(i_rst), .mult_in_0(in_0), .mult_in_1(in_1), .prime(prime),
    			 .sel_mult(sel_mult), .mult_out(mult_out), .done_mult(done_mult));
    div div_0 (.i_clk(i_clk), .i_rst(i_rst), .div_in_0(in_0), .div_in_1(in_1), .prime(prime),
			   .sel_div(sel_div), .div_out(div_out), .done_div(done_div));
    assign GFAU_done_to_control = (done_add | done_sub | done_mult | done_div);
    assign result = (done_add == 1) ? add_out :
    				(done_sub == 1) ? sub_out :
    				(done_mult == 1) ? mult_out :
    				(done_div == 1) ? div_out : 0 ;
endmodule


module add(
	i_clk,
	i_rst,
	add_in_0,
	add_in_1,
	prime,
	sel_add,
	add_out,
	done_add);
	localparam SIZE = 32;

	input i_clk, i_rst;
	input [SIZE - 1 : 0] add_in_0, add_in_1;
	input [SIZE - 1 : 0] prime;
	input sel_add;

	output reg [SIZE - 1 : 0] add_out;
	output done_add;

	reg done_add;
	reg state, state_n;
	wire [SIZE : 0] add_out_ext_0, add_out_ext_1;
	reg [SIZE - 1 : 0] add_out_n;

	assign add_out_ext_0 = add_in_0 + add_in_1;
	assign add_out_ext_1 = add_out_ext_0 - prime;

	always@(*) begin
		case(state)
		0: begin
			done_add = 0;
			state_n = 0;
			if (sel_add == 1) begin
				state_n = 1;
				if (add_out_ext_0 > prime) begin
					add_out_n = add_out_ext_1[SIZE - 1 : 0];
				end
				else begin
					add_out_n = add_out_ext_0[SIZE - 1 : 0];
				end
			end
			else begin
				state_n = 0;
				add_out_n = 0;
			end
			
		end
		1: begin
			done_add = 1;
			state_n = 0;
			if (add_out_ext_0 > prime) begin
				add_out_n = add_out_ext_0[SIZE - 1 : 0];
			end
			else begin
				add_out_n = add_out_ext_1[SIZE - 1 : 0];
			end
		end
		endcase
	end
	always@ (posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			state <= 0;
			add_out <= 0;
		end
		else begin
			state <= state_n;
			add_out <= add_out_n;
		end
	end
endmodule

module sub(
	i_clk,
	i_rst,
	sub_in_0,
	sub_in_1,
	prime,
	sel_sub,
	sub_out,
	done_sub);
	localparam SIZE = 32;

	input i_clk, i_rst;
	input [SIZE - 1 : 0] sub_in_0, sub_in_1;
	input [SIZE - 1 : 0] prime;
	input sel_sub;

	output [SIZE - 1 : 0] sub_out;
	output done_sub;

	reg done_sub;
	reg state, state_n;
	reg [SIZE - 1 : 0] sub_out, sub_out_n;
	wire [SIZE : 0] restore_0, restore_1;

	assign restore_0 = sub_in_0 + prime;
	assign restore_1 = restore_0 - sub_in_1;


	always@(*) begin
		case(state)
		0: begin
			done_sub = 0;
			state_n = 0;
			if (sel_sub == 1) begin
				state_n = 1;
				if (sub_in_0 > sub_in_1) begin
					sub_out_n = sub_in_0 - sub_in_1;
				end
				else begin
					sub_out_n = restore_1 [SIZE - 1 : 0];
				end
			end
			else begin
				state_n = 0;
				sub_out_n = 0;
			end			
		end
		1: begin
			done_sub = 1;
			state_n = 0;
			if (sub_in_0 > sub_in_1) begin
				sub_out_n = sub_in_0 - sub_in_1;
			end
			else begin
				sub_out_n = restore_1 [SIZE - 1 : 0];
			end
		end		
		endcase
	end
	always@ (posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			state <= 0;
			sub_out <= 0;
		end
		else begin
			state <= state_n;
			sub_out <= sub_out_n;
		end
	end
endmodule

module mult(
	i_clk,
	i_rst,
	mult_in_0,
	mult_in_1,
	prime,
	sel_mult,
	mult_out,
	done_mult
	//mult_out_mid
	);

	localparam SIZE = 32;
	
	input i_clk, i_rst;
	input sel_mult;
	input [SIZE - 1 : 0] mult_in_0, mult_in_1;
	input [SIZE - 1 : 0] prime;

	output [SIZE - 1 : 0] mult_out;
	output reg done_mult;

	reg [SIZE : 0] mult_out_mid;
	reg [SIZE : 0] mult_out_mid_n;
	reg [10 :0] i, i_n;
	reg [1:0] state, state_n;

	wire [SIZE : 0] cal_result;
	wire [SIZE + 1 : 0] connect_0, connect_1, connect_2, connect_3 ;

	assign connect_0 = (mult_in_0[i] == 0) ? mult_out_mid : (mult_out_mid + mult_in_1);
	assign connect_1 = connect_0 + prime;
	assign connect_2 = (connect_0[0] == 0) ? (connect_0 >> 1) : ((connect_1) >> 1);
	assign cal_result = connect_2[SIZE : 0];
	assign mult_out = mult_out_mid[SIZE - 1 : 0];

	always @(*) begin
		case(state)
			2'b00: begin 
				i_n = 0;
				mult_out_mid_n = mult_out_mid;
				done_mult = 0;
				state_n = 2'b00;
				if (sel_mult == 1) begin
					i_n = i + 1;
					mult_out_mid_n = cal_result;
					done_mult = 0;
					state_n = 2'b01;
				end
			end
			2'b01: begin
				i_n = i + 1;
				mult_out_mid_n = cal_result;
				done_mult = 0;
				state_n = 2'b01;
				if(i == 32) begin
					i_n = 0;
					mult_out_mid_n = mult_out_mid;
					done_mult = 0;
					state_n = 2'b10;
					if (mult_out_mid > prime) begin
						mult_out_mid_n = mult_out_mid - prime;
					end
				end
			end
			2'b10: begin
				i_n = 0;
				done_mult = 1;
				state_n = 2'b00;
				mult_out_mid_n = 0;
			end
			default: begin
				i_n = 0;
				done_mult = 0;
				state_n = 0;
				mult_out_mid_n = 0;
			end
		endcase
	end

	always@ (posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			i <= 0;
			mult_out_mid <= 0;
			state <= 0;
		end
		else begin
			i <= i_n;
			mult_out_mid <= mult_out_mid_n;
			state <= state_n;
		end
	end	
endmodule

module div(
	i_clk,
	i_rst,
	div_in_0,
	div_in_1,
	prime,
	sel_div,
	div_out,
	done_div
	);
	localparam SIZE = 32;

	input i_clk, i_rst;
	input sel_div;
	input [SIZE - 1 : 0] div_in_0, div_in_1, prime;

	output [SIZE - 1 : 0] div_out;
	//output [SIZE : 0] R;
	output reg done_div;

	reg [SIZE - 1 : 0] U, V;
	reg [SIZE - 1 : 0] U_n, V_n;
	reg [SIZE : 0] R, S, R_n, S_n;
	reg [9 : 0] i, i_n;
	reg [1 : 0] state, state_n;

	reg [9 : 0] loop_num, loop_num_n;
	reg done_div_n;

	assign div_out = R[SIZE - 1 : 0];
	

	always @(*) begin
		case(state) 
			2'd0: begin //IDLE
				U_n = U;
				V_n = V;
				R_n = R;
				S_n = S;
				i_n = 0;
				state_n = state;
				loop_num_n = 0;
				done_div_n = 0;
				if (sel_div == 1) begin //initial
					U_n = prime;
					V_n = div_in_1;
					R_n = 0;
					S_n = div_in_0;
					i_n = 0;
					state_n = 3'd1;
				end
			end
			2'd1: begin
				U_n = U;
				V_n = V;
				R_n = R;
				S_n = S;
				i_n = i + 1;
				state_n = 3'd2;
				loop_num_n = i;
				done_div_n = 0;
				if (V <= 0) begin
					state_n = 3'd3;
					i_n = i;
					loop_num_n = i - SIZE;
				end
				else if (U[0] == 0) begin
					U_n = U >> 1;
					S_n = S << 1;
				end
				else if (V[0] == 0) begin
					V_n = V >> 1;
					R_n = R << 1;
				end
				else if (U > V) begin
					U_n = (U - V) >> 1;
					R_n = R + S;
					S_n = S << 1;
				end
				else begin
					V_n = (V - U) >> 1;
					R_n = R << 1;
					S_n = R + S;
				end
			end
			2'd2: begin
				loop_num_n = loop_num;
				state_n = 3'd1;
				U_n = U;
				V_n = V;
				R_n = R;
				S_n = S;
				done_div_n = 0;
				i_n = i;
				if (R >= prime) begin
					R_n = R - prime;
					if (S >= prime) begin
						S_n = S - prime;
					end
					else begin
						S_n = S;
					end
				end
				else begin
					R_n = R;
					if (S >= prime) begin
						S_n = S - prime;
					end
					else begin
						S_n = S;
					end
				end
			end
			2'd3: begin
				U_n = 0;
				V_n = 0;
				R_n = R;
				S_n = 0;
				i_n = 0;
				state_n = state;
				loop_num_n = loop_num - 1;
				done_div_n = 0;
				if (loop_num > 0) begin
					if (R[0] == 1) begin
						R_n = (R + prime) >> 1;
					end
					else begin
						R_n = R >> 1; 
					end
				end
				else begin
					R_n = prime - R;
					state_n = 3'd0;
					done_div_n = 1;
				end
			end
		endcase
	end

	always@ (posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			U <= 0;
			V <= 0;
			R <= 0;
			S <= 0;
			i <= 0;
			loop_num <= 0;
			done_div <= 0;
			state <= 0;
		end
		else begin
			U <= U_n;
			V <= V_n;
			R <= R_n;
			S <= S_n;
			i <= i_n;
			loop_num <= loop_num_n;
			done_div <= done_div_n;
			state <= state_n;
		end
	end
endmodule


