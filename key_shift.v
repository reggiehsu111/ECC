module key_shift(
	i_clk,
	i_rst,
	k,
	done_from_control,
	k_out);
	localparam SH_NUM = 1;
	localparam SIZE = 32;
	localparam OUT_SIZE = 1;

	input i_clk, i_rst; 
	input [SIZE - 1 : 0] k;
	input done_from_control;


	output k_out;

	reg k_out, k_out_n;
	reg [6:0] i, i_n;

	always @(*) begin
		k_out = k[i];
		if (done_from_control == 1) begin
			i_n = i + 1;
		end
		else begin
			i_n = i;
		end
	end
	always@ (posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			i = 0;
		end
		else begin
			i <= i_n;
		end
	end







endmodule 