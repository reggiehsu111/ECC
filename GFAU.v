module GFAU(
	Px_mont,
	Py_mont,
	operation_select,
	done,
	Px_mont_out,
	Py_mont_out);

	localparam SIZE = 32

	input i_clk, i_rst;
	input [31:0] Px_mont, Py_mont;
    input [1:0] operation_select;

    output done;
    output[31:0] Px_mont_out, Py_mont_out;

endmodule

module mult(
	i_clk,
	done_control,
	mult_in_0,
	mult_in_1,
	mult_out,
	done_mult);
	localparam SIZE = 32
	
	input i_clk, i_rst;
	input done_control;
	input [SIZE - 1 : 0] mult_in_0, mult_in_1;

	output [SIZE - 1 : 0] mult_out;
	output done_mult;

	reg [SIZE - 1 : 0] mult_out_n;
	reg [10 :0] i, i_n;
	reg [1:0] state, state_n;

	wire [SIZE - 1 : 0] connect, cal_result;

	assign connect = mult_out + mult_in_0[i] ;
	assign cal_result = (connect[0] == 0) ? (connect >> 1) : ((connect + prime) >> 1);

	always @(*) begin
		case(state)
			2'b00: begin 
				i_n = i;
				mult_out_n = mult_out;
				done_mult = 0
				state_n = 2'b00;
				if (done_control) begin
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
					if (mult_out > p) begin
						mult_out_n = mult_out - p;
					end
				end
			end
			2'b10: begin
				i_n = 0;
				done_mult = 1;
				state_n = 2'b00;
				mult_out_n = mult_out;
			end
	end

	always@ (posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			i <= 0;
			mult_out <= 0;
		end
		i <= i_n;
		mult_out <= mult_out_n;
	end	
endmodule

module div(
	);
	input i_clk, i_rst;
	input done_control;
	input [SIZE - 1 : 0] div_in_0, div_in_1;

	output [SIZE - 1 : 0] div_out;


endmodule









