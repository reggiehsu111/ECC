module Domain_Transfer(clk, reset, ToMont, in_sig, Px_i, Py_i, A, Prime, Px_out, Py_out, A_out, done);      
    input clk, reset, ToMont, in_sig;
    input [31:0] Px_i, Py_i, Prime, A; 
    output [31:0] Px_out, Py_out, A_out;
    output done;

    reg [31:0] Px, Py, A, Px_nxt, Py_nxt, A_nxt;
    reg [1:0] state, state_nxt;
    reg [4:0] counter, counter_nxt;
    reg done_reg;

    wire [32:0] Px_shift, Py_shift, A_shift;
    wire [32:0] Px_add, Py_add, A_add;

    parameter IDLE = 2'b00;
    parameter TO_MONT = 2'b01;
    parameter TO_REGULAR = 2'b10;
    parameter OUT = 2'b11;

    assign Px_out = Px;
    assign Py_out = Py;
    assign A_out = A;
    assign Px_shift = Px << 1;
    assign Py_shift = Py << 1;
    assign A_shift = A << 1;
    assign done = done_reg;
    assign Px_add = Px + Prime;
    assign Py_add = Py + Prime;
    assign A_add = A + Prime;

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
              if(Px_i >= Prime) Px_nxt = Px_i - Prime;
              else Px_nxt = Px_i;
              if(Py_i >= Prime) Py_nxt = Py_i - Prime;
              else Py_nxt = Py_i;
              if (A >= Prime) A_nxt = A - Prime;
              else A_nxt = A;
            end
            else begin
              Px_nxt = Px;
              Py_nxt = Py;
              A_nxt = A;
            end
          end
          TO_MONT: begin
            if (Px_shift >= Prime) Px_nxt = Px_shift - Prime;
            else Px_nxt = Px_shift;
            if(Py_shift >= Prime) Py_nxt = Py_shift - Prime;
            else Py_nxt = Py_shift;
            if(A_shift >= Prime) A_nxt = A_shift - Prime;
            else A_nxt = A_shift;
          end
          TO_REGULAR: begin
            if (Px[0]) Px_nxt = Px_add >> 1;
            else Px_nxt = Px >> 1;
            if (Py[0]) Py_nxt = Py_add >> 1;
            else Py_nxt = Py >> 1;
            if (A[0]) A_nxt = A_add >> 1;
            else A_nxt = A >> 1;
          end
          default: begin
            Px_nxt <= 0;
            Py_nxt <= 0;
            A_nxt <= 0;
          end

        endcase
    end

      /* ====================Sequential Part=================== */
    always@(posedge clk or negedge reset)
    begin
        if (!reset)
        begin
              Px <= 32'b0;
              Py <= 32'b0;
              A <= 32'b0;
              counter <= 5'b0;
              state <= 1'b0;
        end
        else
        begin
          Px <= Px_nxt;
          Py <= Py_nxt;
          A <= A_nxt;
          counter <= counter_nxt;
          state <= state_nxt;
          if (counter == 5'b11111) done_reg <= 1'b1;
            else done_reg <= 1'b0;
        end
    end
  /* ====================================================== */
endmodule