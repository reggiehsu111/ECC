module Top_ting(
	i_rst,
	i_clk,
	a,
	prime,
	Px,
	Py,
	k,
	kP);
	
	localparam SIZE = 32;
	input i_rst, i_clk;
	input [3 : 0] a, prime, Px, Py, k;

	output [3 : 0] kP;
	
	wire GFAU_done_to_control, key_shift_done_to_control;
	wire GFAU_done_from_control, key_shift_from_control;
	wire key_from_key_shift;
	wire [SIZE - 1 : 0] GFAU_out;
	wire [1 : 0] operation_select;

	Control control_0 (.i_clk(i_clk), i_reset(i_rst), .GFAU_done(GFAU_done_to_control), 
					   .Keyshift_done(), .PartKey(key_from_key_shift), .GFAU_result(), .Px_mont(), 
					   .Py_mont(), .operation_select(operation_select), .done_keyshift(), .done_control(),
					   .raw1(), .raw2(), .raw_prime(), .raw_a(),
					   .output_1(), .output_2(), .all_done());

	GFAU GFAU_0 (.i_clk(i_clk), .i_rst(i_rst), .in_0(), .in_1(), .prime(prime), 
				 .operation_select(operation_select),
				 .GFAU_done_from_control(GFAU_done_from_control), .result(GFAU_out), 
				 .GFAU_done_to_control(GFAU_done_to_control));

	key_shift key_shift_0 (.i_clk(i_clk), .i_rst(i_rst), .k(k), 
						   .key_shift_done_from_control(key_shift_done_from_control), 
						   .k_out(key_from_key_shift), 
						   .key_shift_done_to_control(key_shift_done_to_control));

endmodule