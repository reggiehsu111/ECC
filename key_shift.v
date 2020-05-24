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
	reg key_shift_done_to_control_r;

	assign k_out = k[i];

	always @(*) begin
		case(state)
			0: begin
				state_n = 0;
				i_n = i;
				key_shift_done_to_control_r = 0;
				if (key_shift_done_from_control == 1) begin
					state_n = 1;
				end
			end
			1: begin
				state_n = 0;
				i_n = i + 1;
				key_shift_done_to_control_r = 1;
			end
		endcase
	end
	always@ (posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			i = 0;
			state_n = 0;
		end
		else begin
			i <= i_n;
			state_n = state;
		end
	end
endmodule 