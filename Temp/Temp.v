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
                    if (load_done == 0) begin
                        in_sig_n = 0;
                        next_state = 22;
                    end

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
          default: begin
            Px_nxt = Px;
            Py_nxt = Py;
            A_nxt = A;
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
			state = state_n;
		end
	end
endmodule 