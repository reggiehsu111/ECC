module CHIP (clk_p_i, reset_n_i, start_i, a, prime, Px, Py, k, kPx, kPy, final_done);

    input clk_p_i, reset_n_i, start_i;
	input [3 : 0] a, prime, Px, Py, k;

	output reg [3 : 0] kPx, kPy;
    output done;


    wire i_clk_p_i, i_reset_n_i, i_start_i;
    wire [3:0] i_a, i_prime, i_px, i_py, i_k;
    wire [3:0] i_kpx, i_kpy;
    wire i_done;

endmodule