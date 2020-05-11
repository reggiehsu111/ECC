module Top(rst, clk, ready, valid, a, prime, Px, Py, k, kP);
    input rst, valid;
    input clk;
    input [3:0] a;
    input [3:0] prime;
    input [3:0] Px;
    input [3:0] Py;
    input [3:0] k;
    output ready;
    output [3:0] kP;

    reg [31:0] prime_whole, px_whole, py_whole, a_whole, k_whole;
    reg [31:0] prime_whole_nxt, px_whole_nxt, py_whole_nxt, a_whole_nxt, k_whole_nxt;
    reg [2:0] counter, counter_nxt;
    reg state, state_nxt;

    wire GFAU_done, Keyshift_done, PartKey, done_keyshift, done_control;
    wire prime_in, px_in, py_in, a_in ,k_in;
    wire [31:0] GFAU_result, Px_mont, Py_mont;
    wire [1:0] op_s;

    assign prime_in = prime_whole;
    assign px_in = px_whole;
    assign py_in = py_whole;
    assign a_in = a_whole;
    assign k_in = k_whole;

    Control ctrl(.i_clk(clk), .i_rst(rst), .GFAU_done(GFAU_done), .Keyshift_done(Keyshift_done),
    	.PartKey(PartKey), .GFAU_result(GFAU_result), .Px_mont(Px_mont), .Py_mont(Py_mont), .operation_select(op_s), .done_keyshift(done_keyshift), .done_control(done_control), .raw1(px_in), .raw2(py_in), .raw_prime(prime_in));

    GFAU gfau(.i_clk(clk), .i_rst(rst), .in_0(px_in), .in_1(py_in), .prime(prime_in), .operation_select(op_s), .done_from_control(done_control), .result(GFAU_result), .done_to_control(GFAU_done));




    always @(*) begin
    	// state = 1 after valid signal, until counter = 7
    	if(valid) begin
    		state_nxt = 1;
    		// Load 
    		if (state) begin
	    		prime_whole_nxt = (prime_whole << 4) + prime;
	    		px_whole_nxt = (px_whole << 4) + Px;
	    		py_whole_nxt = (py_whole << 4) + Py;
	    		a_whole_nxt = (a_whole << 4) + a;
	    		k_whole_nxt = (k_whole << 4) + k;
	    		counter_nxt = counter + 1;
    		end
    		else begin
    			prime_whole_nxt = prime_whole;
    			px_whole_nxt = px_whole;
    			py_whole_nxt = py_whole;
    			a_whole_nxt = a_whole;
    			k_whole_nxt = k_whole;
    			counter_nxt = 0;
    		end
    	end

    	
    	else if (counter == 7) begin 
    		state_nxt = 0;
    		if (state) begin
	    		prime_whole_nxt = (prime_whole << 4) + prime;
	    		px_whole_nxt = (px_whole << 4) + Px;
	    		py_whole_nxt = (py_whole << 4) + Py;
	    		a_whole_nxt = (a_whole << 4) + a;
	    		k_whole_nxt = (k_whole << 4) + k;
	    		counter_nxt = counter + 1;
    		end
    		else begin
    			prime_whole_nxt = prime_whole;
    			px_whole_nxt = px_whole;
    			py_whole_nxt = py_whole;
    			a_whole_nxt = a_whole;
    			k_whole_nxt = k_whole;
    			counter_nxt = 0;
    		end
    	end
    	else begin
    		state_nxt = state;
    		if (state) begin
	    		prime_whole_nxt = (prime_whole << 4) + prime;
	    		px_whole_nxt = (px_whole << 4) + Px;
	    		py_whole_nxt = (py_whole << 4) + Py;
	    		a_whole_nxt = (a_whole << 4) + a;
	    		k_whole_nxt = (k_whole << 4) + k;
	    		counter_nxt = counter + 1;
    		end
    		else begin
    			prime_whole_nxt = prime_whole;
    			px_whole_nxt = px_whole;
    			py_whole_nxt = py_whole;
    			a_whole_nxt = a_whole;
    			k_whole_nxt = k_whole;
    			counter_nxt = 0;
    		end
    	end

    	 
    	
    end

    always @(posedge clk or posedge rst) begin
    	if (rst) begin
    		prime_whole <= 0;
    		px_whole <= 0;
    		py_whole <= 0;
    		a_whole <= 0;
    		k_whole <= 0;
    		counter <= 0;
    		state <= 0;
    	end
    	else begin
    		prime_whole <= prime_whole_nxt;
    		px_whole <= px_whole_nxt;
    		py_whole <= py_whole_nxt;
    		a_whole <= a_whole_nxt;
    		k_whole <= k_whole_nxt;
    		counter <= counter_nxt;
    		state <= state_nxt;
    	end
    end

endmodule