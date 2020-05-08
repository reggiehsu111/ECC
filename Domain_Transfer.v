module Domain_Transfer(clk, reset, ToMont, in_sig, Px_i, Py_i, Prime, Px_out, Py_out, done);      
    input clk, reset, ToMont, in_sig;
    input [31:0] Px_i, Py_i, Prime; 
    output [31:0] Px_out, Py_out;
    output done;

    reg [31:0] Px, Py, Px_nxt, Py_nxt;
    reg [1:0] state, state_nxt;
    reg [4:0] counter, counter_nxt;
    reg done_reg;

    wire [31:0] Px_shift, Py_shift;

    parameter IDLE = 2'b00;
    parameter TO_MONT = 2'b01;
    parameter TO_REGULAR = 2'b10;
    parameter OUT = 2'b11;

    assign Px_out = Px;
    assign Py_out = Py;
    assign Px_shift = {Px[30:0], 1'b0};
    assign Py_shift = {Py[30:0], 1'b0};

    always @(*) begin
      case(state)
          IDLE: begin
            if(in_sig) begin
              if(ToMont) state_nxt = TO_MONT;
              else state_nxt = TO_REGULAR;
            end
            else state_nxt = IDLE;
          end
          TO_MONT: begin
            if (counter != 5'b11111) state_nxt = TO_MONT;
                else state_nxt = OUT;
          end
          TO_REGULAR: begin
            if (counter != 5'b11111) state_nxt = TO_REGULAR;
                else state_nxt = OUT;
          end
          OUT: state_nxt = IDLE;
      endcase
    end

    always @(*) begin
        case(state)
            TO_MONT: counter_nxt = counter + 1;
            TO_REGULAR: counter_nxt = counter + 1;
            default: counter_nxt = 0;
        endcase
    end

    always @(*) begin
        case(state)
          IDLE: begin
            if(in_sig) begin
              if(Px > Prime) Px_nxt = Px - Prime;
              else Px_nxt = Px; 
            end
          end
          TO_MONT: begin
            if (Px_shift > Prime) Px_nxt = Px_shift - Prime;
            else Px_nxt = Px_shift;
            if(Py_shift > Prime) Py_nxt = Py_shift - Prime;
            else Py_nxt = Py_shift;
          end
          TO_REGULAR: begin
            Px_nxt = Px_shift;
          end
          default: begin
            Px_nxt <= 0;
            Py_nxt <= 0;
          end

        endcase
    end

      /* ====================Sequential Part=================== */
    always@(posedge clk or negedge reset)
    begin
        if (reset == 1'b0)
        begin
              Px <= 32'b0;
              Py <= 32'b0;
              counter <= 5'b0;
              state <= 1'b0;
        end
        else
        begin
        	if (in_sig) begin
            Px <= Px_i;
            Py <= Py_i;
          end
          else begin
            Px <= Px;
            Py <= Py;
          end
          counter <= counter_nxt;
          state <= state_nxt;
          if (counter == 5'b11111) done_reg <= 1'b1;
            else done_reg <= 1'b0;
        end
    end
  /* ====================================================== */
endmodule