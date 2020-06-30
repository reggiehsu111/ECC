module CHIP (i_clk, i_rst, i_start, a, prime, Px, Py, k, kPx, kPy, done);

    input i_clk, i_rst, i_start;
	input [3 : 0] a, prime, Px, Py, k;

	output [3 : 0] kPx, kPy;
    output done;


    wire i_i_clk, i_i_rst, i_i_start;
    wire [3:0] i_a, i_prime, i_px, i_py, i_k;
    wire [3:0] i_kpx, i_kpy;
    wire i_done;
    wire n_logic0,n_logic1;
    Top_ting top0(
	.i_rst(i_i_rst),
	.i_clk(i_i_clk),
	.i_start(i_i_start),
	.a(i_a),
	.prime(i_prime),
	.k(i_k),
	.Px(i_px),
	.Py(i_py),
	.kPx(i_kpx),
	.kPy(i_kpy),
    .done(i_done)
    );
    TIE0 ipad_n_logic0(.O(n_logic0));
    TIE1 ipad_n_logic1(.O(n_logic1));

    XMD ipad_i_clk (.O(i_i_clk), .I(i_clk), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_i_rst (.O(i_i_rst), .I(i_rst), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_i_start  (.O(i_i_start), .I(i_start), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_a_i_0  (.O(i_a[0]), .I(a[0]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_a_i_1  (.O(i_a[1]), .I(a[1]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_a_i_2  (.O(i_a[2]), .I(a[2]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_a_i_3  (.O(i_a[3]), .I(a[3]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_prime_i_0  (.O(i_prime[0]), .I(prime[0]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_prime_i_1  (.O(i_prime[1]), .I(prime[1]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_prime_i_2  (.O(i_prime[2]), .I(prime[2]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_prime_i_3  (.O(i_prime[3]), .I(prime[3]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_px_i_0  (.O(i_px[0]), .I(Px[0]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_px_i_1  (.O(i_px[1]), .I(Px[1]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_px_i_2  (.O(i_px[2]), .I(Px[2]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_px_i_3  (.O(i_px[3]), .I(Px[3]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_py_i_0  (.O(i_py[0]), .I(Py[0]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_py_i_1  (.O(i_py[1]), .I(Py[1]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_py_i_2  (.O(i_py[2]), .I(Py[2]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_py_i_3  (.O(i_py[3]), .I(Py[3]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_k_i_0  (.O(i_k[0]), .I(k[0]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_k_i_1  (.O(i_k[1]), .I(k[1]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_k_i_2  (.O(i_k[2]), .I(k[2]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));
    XMD ipad_k_i_3  (.O(i_k[3]), .I(k[3]), .PU(n_logic0), .PD(n_logic0), .SMT(n_logic0));

    YA2GSD ipad_kpx_0 (.O(kPx[0]), .I(i_kpx[0]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_kpx_1 (.O(kPx[1]), .I(i_kpx[1]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_kpx_2 (.O(kPx[2]), .I(i_kpx[2]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_kpx_3 (.O(kPx[3]), .I(i_kpx[3]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_kpy_0 (.O(kPy[0]), .I(i_kpy[0]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_kpy_1 (.O(kPy[1]), .I(i_kpy[1]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_kpy_2 (.O(kPy[2]), .I(i_kpy[2]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_kpy_3 (.O(kPy[3]), .I(i_kpy[3]), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    YA2GSD ipad_done (.O(done), .I(i_done), .E(n_logic1), .E2(n_logic0), .E4(n_logic0), .E8(n_logic0), .SR(n_logic0));
    
  

endmodule
