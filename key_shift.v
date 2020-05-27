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