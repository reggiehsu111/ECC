module GFAU(
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
	done_div,
	state,
	div_out
	);

	localparam SIZE = 32;

	input i_clk, i_rst;
	input [SIZE - 1 : 0] in_0, in_1;
	input [SIZE - 1 : 0] prime;
    input [1 : 0] operation_select;
    input done_from_control;

    output[SIZE - 1 : 0] result;
    output done_to_control;
    output done_add, done_sub, done_mult, done_div;
    output [2:0] state;
    output [SIZE - 1 : 0] div_out;
    //output [10 : 0] i;
    //output [SIZE - 1 : 0] mult_out;

    wire sel_add, sel_sub, sel_mult, sel_div;
    wire [SIZE - 1 : 0] add_out, sub_out, mult_out, div_out;
    

    assign sel_add = (operation_select == 2'd0 && done_from_control == 1) ? 1 : 0;
    assign sel_sub = (operation_select == 2'd1 && done_from_control == 1) ? 1 : 0;
    assign sel_mult = (operation_select == 2'd2 && done_from_control == 1) ? 1 : 0;
    assign sel_div = (operation_select == 2'd3 && done_from_control == 1) ? 1 : 0;

    add add_0 (.i_clk(i_clk), .i_rst(i_rst), .add_in_0(in_0), .add_in_1(in_1), .prime(prime),
    		   .sel_add(sel_add), .add_out(add_out), .done_add(done_add));
    sub sub_0 (.i_clk(i_clk), .i_rst(i_rst), .sub_in_0(in_0), .sub_in_1(in_1), .prime(prime),
    		   .sel_sub(sel_sub), .sub_out(sub_out), .done_sub(done_sub));
    mult mult_0 (.i_clk(i_clk), .i_rst(i_rst), .mult_in_0(in_0), .mult_in_1(in_1), .prime(prime),
    			 .sel_mult(sel_mult), .mult_out(mult_out), .done_mult(done_mult));
    div div_0 (.i_clk(i_clk), .i_rst(i_rst), .div_in_0(in_0), .div_in_1(in_1), .prime(prime),
			   .sel_div(sel_div), .div_out(div_out), .done_div(done_div), .state(state));
    assign done_to_control = (done_add | done_sub | done_mult | done_div);
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

	output [SIZE - 1 : 0] add_out;
	output done_add;

	reg done_add, done_add_n;
	reg [SIZE - 1 : 0] add_out, add_out_n;
	reg state, state_n;

	always@(*) begin
		case(state)
			0: begin
				done_add_n = 0;
				add_out_n = add_in_0 + add_in_1;
				state_n = 0;
				if (sel_add) begin
					state_n = 1;
				end
			end
			1: begin
				state_n = 0;
				done_add_n = 1;
				if (add_out > prime) begin
					add_out_n = add_out - prime;
				end
				else begin
					add_out_n = add_out;
				end
			end
		endcase
	end

	always@(posedge i_clk or negedge i_rst) begin
		if (!i_rst) begin
			done_add <= 0;
			add_out <= 0;
			state <= 0;
		end
		else begin
			done_add <= done_add_n;
			add_out <= add_out_n;
			state <= state_n;
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

	reg done_sub, done_sub_n;
	reg [SIZE - 1 : 0] sub_out, sub_out_n;
	reg state, state_n;

	always@(*) begin
		case(state)
			0: begin
				done_sub_n = 0;
				sub_out_n = sub_in_0 + prime - sub_in_1;
				state_n = 0;
				if (sel_sub) begin
					state_n = 1;
				end
			end
			1: begin
				state_n = 0;
				done_sub_n = 1;
				if (sub_out > prime) begin
					sub_out_n = sub_out - prime;
				end
				else begin
					sub_out_n = sub_out;
				end
			end
		endcase
	end

	always@(posedge i_clk or negedge i_rst) begin
		if (!i_rst) begin
			done_sub <= 0;
			sub_out <= 0;
			state <= 0;
		end
		else begin
			done_sub <= done_sub_n;
			sub_out <= sub_out_n;
			state <= state_n;
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
	done_mult,
	state,
	i);

	localparam SIZE = 32;
	
	input i_clk, i_rst;
	input sel_mult;
	input [SIZE - 1 : 0] mult_in_0, mult_in_1;
	input [SIZE - 1 : 0] prime;

	output reg [SIZE - 1 : 0] mult_out;
	output reg done_mult;

	reg [SIZE - 1 : 0] mult_out_n;
	reg [10 :0] i, i_n;
	reg [1:0] state, state_n;

	wire [SIZE - 1 : 0] connect, cal_result;

	assign connect = (mult_in_0[i] == 0) ? mult_out : (mult_out + mult_in_1) ;
	assign cal_result = (connect[0] == 0) ? (connect >> 1) : ((connect + prime) >> 1);

	always @(*) begin
		case(state)
			2'b00: begin 
				i_n = 0;
				mult_out_n = mult_out;
				done_mult = 0;
				state_n = 2'b00;
				if (sel_mult == 1) begin
					i_n = i + 1;
					mult_out_n = cal_result;
					done_mult = 0;
					state_n = 2'b01;
				end
			end
			2'b01: begin
				i_n = i + 1;
				mult_out_n = cal_result;
				done_mult = 0;
				state_n = 2'b01;
				if(i == 32) begin
					i_n = 0;
					mult_out_n = mult_out;
					done_mult = 0;
					state_n = 2'b10;
					if (mult_out > prime) begin
						mult_out_n = mult_out - prime;
					end
				end
			end
			2'b10: begin
				i_n = 0;
				done_mult = 1;
				state_n = 2'b00;
				mult_out_n = mult_out;
			end
		endcase
	end

	always@ (posedge i_clk or negedge i_rst) begin
		if(!i_rst) begin
			i <= 0;
			mult_out <= 0;
			state <= 0;
		end
		else begin
			i <= i_n;
			mult_out <= mult_out_n;
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
	done_div,
	state
	);
	localparam SIZE = 32;

	input i_clk, i_rst;
	input sel_div;
	input [SIZE - 1 : 0] div_in_0, div_in_1, prime;

	output [SIZE - 1 : 0] div_out;
	output [2:0] state;
	output reg done_div;

	reg [SIZE - 1 : 0] U, V, R, S;
	reg [SIZE - 1 : 0] U_n, V_n, R_n, S_n;
	reg [9 : 0] i, i_n;
	reg [2 : 0] state, state_n;

	reg [9 : 0] loop_num, loop_num_n;
	reg done_div_n;

	assign div_out = R;
	

	always @(*) begin
		case(state) 
			3'd0: begin //IDLE
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
			3'd1: begin
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
			3'd2: begin
				loop_num_n = loop_num;
				state_n = 3'd1;
				U_n = U;
				V_n = V;
				R_n = R;
				S_n = S;
				done_div_n = 0;
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
			3'd3: begin
				U_n = 0;
				V_n = 0;
				R_n = R;
				S_n = 0;
				i_n = 0;
				state_n = state;
				loop_num_n = 0;
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

	always@ (posedge i_clk or negedge i_rst) begin
		if(!i_rst) begin
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


