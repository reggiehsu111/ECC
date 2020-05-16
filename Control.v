module Control(
                i_clk, i_reset,
                GFAU_done, Keyshift_done,
                PartKey, GFAU_result,
                Px_mont, Py_mont, operation_select,
                done_keyshift, done_control,
                raw1, raw2, raw_prime, a,
                output_1, output_2, all_done
                );
  /*========================IO declaration============================ */	  

    input i_clk;
    input i_reset;

    input GFAU_done;                        // done signal from GFAU
    input Keyshift_done;                    // done signal from  key shifter

    input PartKey;                          // single bit for key
    input [31:0] GFAU_result;               // Result from GFAU

    input [31:0] raw1, raw2, raw_prime, a;     // non-transferred input and prime

    output [31:0] Px_mont, Py_mont;         // transferred inputs To GFAU
    output [1:0] operation_select;          // 00, 01, 10, 11 add, subtract, multiple, divide
    output done_keyshift;                   // done signal to key shifter for completion of add or double
    output done_control;                    // done signal to GFAU for finishing saving the return value to register

    output [31:0] output_1, output_2;       // final output to Top(be inverse transferred)
    output all_done;                        // kP is finally computed singal to Top

  /*========================Wire and Reg======================== */	  
     
    reg all_done_r;
    reg all_done_rn;
    reg in_sig;    
    reg in_sig_n;                         

    wire [31:0] i1_w, i2_w;
    wire Transfer_done_w;
    wire in_sig_w;

    reg [31:0] x1, y1, x2, y2;              // inputs for Add and Double
    reg [4:0] state;                        // state machine
    reg [4:0] next_state;

    reg [31:0] Px_mont_r;
    reg [31:0] Py_mont_r;
    
    reg [1:0] instruction;
    reg [31:0] r1, r2;
    reg [31:0] r1_n, r2_n;

    reg [31:0] x3,y3;
    wire [31:0] x3_w, y3_w;
    assign x3_w = x3;
    assign y3_w = y3;

    reg done_control_r;                     //connect to output wire
    reg done_keyshift_r;                    // connect to output wire
    
    reg [4:0] key_counter;                  // counter for keyshifter is whether finish
    reg [4:0] key_counter_n;

    Domain_Transfer d0(clk, reset, 1'b1, in_sig_w, raw1, raw2, raw_prime, i1_w, i2_w, Transfer_done_w);
    Domain_Transfer d1(clk, reset, 1'b0, in_sig_w, x3, y3, raw_prime, output_1, output_2, Transfer_done_w);

/*====================assign output wires to the register=========================*/

    assign Px_mont = Px_mont_r;
    assign Py_mont = Py_mont_r;
    assign operation_select = instruction;
    assign done_control = done_control_r;
    assign done_keyshift = done_keyshift_r;
    assign in_sig_w = in_sig;
    assign all_done = all_done_r;
/*==========================next state logic=========================*/
    
    always@(*)
    begin
        case(state)
            0:
                begin
                    done_control_r = 0;
                    done_keyshift_r = 0;
                    if(Transfer_done_w == 1)
                        begin
                            if(key_counter == 5'b11111)
                                begin
                                    all_done_rn = 1;
                                    in_sig_n = in_sig;
                                    r1_n = r1;
                                    r2_n = r2;
                                    next_state = 0;
                                end
                            else
                                begin
                                    all_done_rn = 0;
                                    in_sig_n = 0;
                                    r1_n = i1_w; /// may not correct after first pass value
                                    r2_n = i2_w;
                                    done_keyshift_r = 1;
                                    next_state = 0;
                                end
                            
                        end
                    else
                        begin
                            all_done_rn = 0;
                            if(key_counter == 5'b11111)
                                begin
                                    in_sig_n = 1;
                                    next_state = 0;
                                    r1_n = r1;
                                    r2_n = r2;
                                end
                            else    
                                begin
                                    if(Keyshift_done == 1)
                                        begin
                                            in_sig_n = in_sig;
                                            r1_n = r1;
                                            r2_n = r2;
                                            
                                            x1 = r1;
                                            y1 = r2;
                                            x2 = r1;
                                            y2 = r2;
                                            next_state = 1;
                                        end
                                    else
                                        begin
                                            in_sig_n = in_sig;
                                            r1_n = r1;
                                            r2_n = r2;
                                            next_state = 0;
                                        end
                                end
                        end              
                end
            1:
                begin
                    Px_mont_r = x1;
                    Py_mont_r = x1;
                    instruction = 2'b10;
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 2; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            2:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r1;
                    instruction = 2'b00; // add
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 3; 
                            r1_n = r1;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            3:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b00;//add
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 4; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            4:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = a;
                    instruction = 2'b00;//add
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 5; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            5:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = r1;
                    instruction = 2'b00;//add
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 6; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            6:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b11;//divide
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 7; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            7:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = r1;
                    instruction = 2'b10;//multi
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 8; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            8:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 9; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            9:
                 begin
                    Px_mont_r = r2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 10; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                            x3 = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            10:
                 begin
                    Px_mont_r = x1;
                    Py_mont_r = r2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 11; 
                            r1_n = r1;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            11:
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b10;//multi
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 12; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            12: 
                 begin
                    Px_mont_r = r1;
                    Py_mont_r = y1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            y3 = GFAU_result;
                            if(PartKey == 1)
                                begin
                                    next_state = 13;
                                    r2_n = GFAU_result;//it's not correct but next state will reset
                                    r1_n = r1;// it's not correct but next state will reset
                                    x1 = x3;
                                    y1 = y3;
                                end
                            else
                                begin
                                    r1_n = x3;
                                    r2_n = y3;
                                    done_keyshift_r = 1;
                                    key_counter_n = key_counter + 1;
                                    next_state = 0;
                                end
                            end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
/*===========================addition control================================*/                
            
            13:
                begin
                    Px_mont_r = x2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 14; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
               
            14:
                begin
                    Px_mont_r = y1;
                    Py_mont_r = y2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 15; 
                            r1_n = r1;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            15:
                begin
                    Px_mont_r = r2;
                    Py_mont_r = r1;
                    instruction = 2'b11;//multi
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 16; 
                            r1_n = GFAU_result;
                            r2_n = r2;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            16:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r1;
                    instruction = 2'b10;//multi
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 17; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            17:
                begin
                    Px_mont_r = r2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 18; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            18:
                begin
                    Px_mont_r = r2;
                    Py_mont_r = x2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 19; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                            x3 = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            19:
                begin
                    Px_mont_r = x1;
                    Py_mont_r = r2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 20; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            20:
                begin
                    Px_mont_r = r1;
                    Py_mont_r = r2;
                    instruction = 2'b10;//multi
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 21; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
            21:
               begin
                    Px_mont_r = r2;
                    Py_mont_r = y1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 0; 
                            done_keyshift_r = 1;
                            key_counter_n = key_counter + 1;
                            y3 = GFAU_result;
                            r1_n = r1;
                            r2_n = y3;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                       end
                end
        endcase
    end

  /* ====================Sequential Part=================== */

always@(posedge  i_clk or negedge i_reset)
    begin
        if (i_reset == 1'b0)
            begin
                in_sig          <= 1;
                state	        <= 5'b0;
                done_control_r  <= 0;
                done_keyshift_r <= 0;
                key_counter     <= 5'b0000;
                all_done_r      <= 0;
            end
        else
            begin
                r1              <= r1_n;
                r2              <= r2_n;
                state           <= next_state;  
                key_counter     <= key_counter_n;
                in_sig          <= in_sig_n;
                all_done_r      <= all_done_rn;
                done_keyshift   <= done_keyshift_r;
                done_control    <= done_control_r;
            end
    end
endmodule