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

    Control ctrl();


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
    			prime_whole_nxt = 0;
    			px_whole_nxt = 0;
    			py_whole_nxt = 0;
    			a_whole_nxt = 0;
    			k_whole_nxt = 0;
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
    			prime_whole_nxt = 0;
    			px_whole_nxt = 0;
    			py_whole_nxt = 0;
    			a_whole_nxt = 0;
    			k_whole_nxt = 0;
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
    			prime_whole_nxt = 0;
    			px_whole_nxt = 0;
    			py_whole_nxt = 0;
    			a_whole_nxt = 0;
    			k_whole_nxt = 0;
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