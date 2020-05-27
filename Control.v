module Control(
                i_clk, i_reset,
                GFAU_done, Keyshift_done,
                PartKey, GFAU_result,
                Px_mont, Py_mont, operation_select,
                done_keyshift, done_control,
                raw1, raw2, raw_prime, raw_a, load_done,
                output_1, output_2, all_done
                );
  /*========================IO declaration============================ */	 
    input i_clk;
    input i_reset;

    input GFAU_done;                        // done signal from GFAU
    input Keyshift_done;                    // done signal from  key shifter

    input PartKey;                          // single bit for key
    input [31:0] GFAU_result;               // Result from GFAU

    input [31:0] raw1, raw2, raw_prime, raw_a;     // non-transferred input and prime

    input load_done;

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
    wire Transfer_done_w0, Transfer_done_w1;
    wire in_sig_w;

    reg [31:0] x1, y1, x2, y2;
    reg [31:0] x1_n, y1_n, x2_n, y2_n;              // inputs for Add and Double
    reg [4:0] state;                        // state machine
    reg [4:0] next_state;

    reg [31:0] Px_mont_r;
    reg [31:0] Py_mont_r;
    
    reg [1:0] instruction;
    reg [31:0] r1, r2;
    reg [31:0] r1_n, r2_n;

    reg [31:0] x3,y3;
    reg [31:0] x3_n, y3_n;
    
    wire [31:0] x3_w, y3_w;

    reg done_control_r;                     //connect to output wire
    reg done_keyshift_r;                    // connect to output wire
    
    reg [4:0] key_counter;                  // counter for keyshifter is whether finish
    reg [4:0] key_counter_n;

    reg [31:0] a, a_n;

    wire [31:0] transferred_a_w0, transferred_a_w1;

    Domain_Transfer d0(i_clk, i_reset, 1'b1, in_sig_w, raw1, raw2, raw_a, raw_prime, i1_w, i2_w, transferred_a_w0, Transfer_done_w0);
    Domain_Transfer d1(i_clk, i_reset, 1'b0, in_sig_w, x3_w, y3_w, raw_a, raw_prime, output_1, output_2, transferred_a_w1, Transfer_done_w1);

/*====================assign output wires to the register=========================*/

    assign x3_w = x3;
    assign y3_w = y3;
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
            0: begin
                done_control_r = 0;
                done_keyshift_r = 0;
                in_sig_n = 0;
                a_n = a;                    
                if(Transfer_done_w0 == 1 || Transfer_done_w1 == 1) begin                    
                    if(key_counter == 2) begin   // this will be changed to the length of Key                     
                        all_done_rn = 1;
                        r1_n = r1; 
                        r2_n = r2; 
                        x1_n = x1; 
                        y1_n = y1; 
                        x2_n = x2; 
                        y2_n = y2; 
                        x3_n = x3; 
                        y3_n = y3;
                        next_state = 0;
                        key_counter_n = 0;
                        a_n = a;
                    end
                    else begin                            
                        all_done_rn = 0;
                        a_n = transferred_a_w0;
                        r1_n = i1_w; 
                        r2_n = i2_w;
                        x1_n = x1; 
                        y1_n = y1; 
                        x2_n = i1_w; 
                        y2_n = i2_w; 
                        x3_n = x3; 
                        y3_n = y3;
                        done_keyshift_r = 1;
                        next_state = 0;
                        key_counter_n = key_counter;
                    end                        
                end

                else begin                
                    all_done_rn = 0;
                    a_n = a;
                    if(key_counter == 2) begin// this will be change to the length of Key                        
                        next_state = 0;
                        r1_n = r1; 
                        r2_n = r2; 
                        x1_n = x1; 
                        y1_n = y1; 
                        x2_n = x2; 
                        y2_n = y2; 
                        x3_n = x3; 
                        y3_n = y3;
                        key_counter_n = key_counter;
                        if (in_sig == 0) begin
                            in_sig_n = 1;
                        end
                        else begin 
                            in_sig_n = 0;
                        end
                    end
                    else begin                         
                        key_counter_n = key_counter;
                        if(Keyshift_done == 1) begin                            
                            in_sig_n = in_sig;
                            r1_n = r1; 
                            r2_n = r2; 
                            x1_n = r1; 
                            y1_n = r2; 
                            x2_n = x2; 
                            y2_n = y2; 
                            x3_n = x3; 
                            y3_n = y3;
                            /*if(key_counter == 0)begin
                                next_state = 0;
                                done_keyshift_r = 1;
                                key_counter_n = key_counter + 1; 
                                x3_n = r1;
                                y3_n = r2;
                            end*/
                            //else begin
                            next_state = 1;
                            //end  
                        end
                        else begin                            
                            in_sig_n = in_sig;
                            r1_n = r1; 
                            r2_n = r2; 
                            x1_n = x1; 
                            y1_n = y1; 
                            x2_n = x2; 
                            y2_n = y2; 
                            x3_n = x3; 
                            y3_n = y3;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    Px_mont_r = r2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 10; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                            x3_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                           x3_n = x3;
                       end
                end
            10:
                 begin
                    Px_mont_r = x1;
                    Py_mont_r = r2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
            12: begin                
                Px_mont_r = r1;
                Py_mont_r = y1;
                instruction = 2'b01;//minus
                done_control_r = 1; 
                done_keyshift_r = 0; 
                in_sig_n = in_sig; 
                all_done_rn = 0; 
                a_n = a;
                if(GFAU_done == 1) begin
                    done_control_r = 0;
                    y3_n = GFAU_result;
                    if(PartKey == 1) begin                        
                        next_state = 13;
                        r2_n = GFAU_result;//it's not correct but next state will reset
                        r1_n = r1;// it's not correct but next state will reset
                        x1_n = x3; y1_n = GFAU_result;
                        x2_n = x2; y2_n = y2; x3_n = x3;
                        key_counter_n = key_counter;
                    end
                    else begin
                        r1_n = x3;
                        r2_n = GFAU_result;
                        x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3;
                        done_keyshift_r = 1;
                        key_counter_n = key_counter + 1;
                        next_state = 0;
                    end
                end
                else begin                   
                   next_state = state;
                   r1_n = r1;
                   r2_n = r2;
                   x1_n = x1; 
                   y1_n = y1; 
                   x2_n = x2; 
                   y2_n = y2; 
                   x3_n = x3; 
                   y3_n = y3;
                end
            end
/*===========================addition control================================*/                            
            13:
                begin
                    Px_mont_r = x2;
                    Py_mont_r = x1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    Px_mont_r = y2;
                    Py_mont_r = y1;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2;  y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 19; 
                            r2_n = GFAU_result;
                            r1_n = r1;
                            x3_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                           x3_n = x3;
                       end
                end
            19:
                begin
                    Px_mont_r = x1;
                    Py_mont_r = r2;
                    instruction = 2'b01;//minus
                    done_control_r = 1; done_keyshift_r = 0; in_sig_n = in_sig; all_done_rn = 0;
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; y3_n = y3; a_n = a;
                    key_counter_n = key_counter;
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
                    x1_n = x1; y1_n = y1; x2_n = x2; y2_n = y2; x3_n = x3; a_n = a;
                    if(GFAU_done == 1)
                        begin
                            done_control_r = 0;
                            next_state = 0; 
                            done_keyshift_r = 1;
                            key_counter_n = key_counter + 1;
                            y3_n = GFAU_result;
                            r1_n = x3;
                            r2_n = GFAU_result;
                        end
                    else
                       begin
                           next_state = state;
                           r1_n = r1;
                           r2_n = r2;
                           y3_n = y3;
                           key_counter_n = key_counter;
                       end
                end
            22:
                begin
                    in_sig_n = 1;
                    next_state = 0;
                    key_counter_n = 0;
                    r1_n = r1; 
                    r2_n = r2; 
                    x1_n = x1; 
                    y1_n = y1; 
                    x2_n = x2; 
                    y2_n = y2; 
                    x3_n = x3; 
                    y3_n = y3; 
                    a_n = a;
                    Px_mont_r = 0; 
                    Py_mont_r = 0;
                    all_done_rn = 0;
                    done_control_r = 0; 
                    done_keyshift_r = 0;
                    if (load_done == 0) begin
                        in_sig_n = 0;
                        next_state = 22;
                    end
                end
        endcase
    end

/* ====================Sequential Part=================== */

always@(posedge  i_clk or posedge i_reset)
    begin
        if (i_reset)
            begin
                in_sig          <= 0;
                state	        <= 22;
                done_control_r  <= 0;
                done_keyshift_r <= 0;
                key_counter     <= 5'b00000;
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
                x1              <= x1_n;
                x2              <= x2_n;
                y1              <= y1_n;
                y2              <= y2_n;
                x3              <= x3_n;
                y3              <= y3_n;
                a               <= a_n;    
            end
    end

endmodule