`timescale 1ns/10ps
`define CYCLE    10.0
`define COMPUTE_TIME 34
// You can modify NUM_DATA and MAX_DELAY
`define PX              "./sim_data/DT/Px.dat"        
`define PY              "./sim_data/DT/Py.dat" 
`define PRIME           "./sim_data/DT/Prime.dat"
`define DONE            "./sim_data/DT/Done.dat"
`define TOMONT          "./sim_data/DT/ToMont.dat"
`define INSIG           "./sim_data/DT/InSig.dat"
`define PX_GOLDEN       "./sim_data/DT/Px_golden.dat" 
`define PY_GOLDEN       "./sim_data/DT/Py_golden.dat" 

module DT_test();

    parameter DATA_LENGTH   = 20;

    reg           clk;
    reg           reset, in_sig, ToMont;
    reg   [31:0]   Px_i, Py_i, Prime;
    wire          done;
    wire  [31:0]  Px_out, Py_out;

    reg   to_mont_mem            [0:DATA_LENGTH-1];
    reg   done_mem               [0:DATA_LENGTH-1];
    reg   in_sig_mem             [0:DATA_LENGTH-1];
    reg   [31:0]  px_mem         [0:DATA_LENGTH-1];
    reg   [31:0]  py_mem         [0:DATA_LENGTH-1];
    reg   [31:0]  prime_mem      [0:DATA_LENGTH-1];
    reg   [31:0]  px_golden_mem  [0:DATA_LENGTH-1];
    reg   [31:0]  py_golden_mem  [0:DATA_LENGTH-1];
    reg   [31:0]  px_out_temp, py_out_temp;
    reg   done_temp;

    reg           stop;
    integer       i, j, out_f, err, pattern_num;
    reg           over;

    Domain_Transfer DT0( 
        .clk(clk),
        .reset(reset),
        .ToMont(ToMont),
        .in_sig(in_sig),
        .Px_i(Px_i),
        .Py_i(Py_i),
        .Prime(Prime),
        .Px_out(Px_out),
        .Py_out(Py_out),
        .done(done)
    ); 
       
    //initial $sdf_annotate(`SDFFILE, top);
    initial $readmemh (`PX,  px_mem);
    initial $readmemh (`PY,  py_mem);
    initial $readmemh (`PRIME,  prime_mem);
    initial $readmemh (`TOMONT,  to_mont_mem);
    initial $readmemh (`PX_GOLDEN,  px_golden_mem);
    initial $readmemh (`PY_GOLDEN,  py_golden_mem);
    initial $readmemh (`DONE, done_mem);
    initial $readmemh (`INSIG, in_sig_mem);
    initial $readmemh (`TOMONT, to_mont_mem);

    initial begin
       clk         = 1'b1;
       reset       = 1'b1;
       stop        = 1'b0;  
       over        = 1'b0;
       pattern_num = 0;
       err         = 0;
       i           = 0;
       j           = 0;
        #2.5 reset=1'b0;                            // system reset
        #2.5 reset=1'b1;

    end

    always begin #(`CYCLE/2) clk = ~clk; end

    initial begin
        $dumpfile("DT.fsdb");
        $dumpvars;

       out_f = $fopen("out.dat");
       if (out_f == 0) begin
            $display("Output file open error !");
            $finish;
       end
    end

    always @(negedge clk)begin
        if (j%`COMPUTE_TIME == 0) begin
            if(i < DATA_LENGTH)begin
              Px_i = px_mem[i];
              Py_i = py_mem[i];
              Prime = prime_mem[i];
              in_sig = in_sig_mem[i];
              ToMont = to_mont_mem[i];

             px_out_temp = px_golden_mem[i];
             py_out_temp = py_golden_mem[i];
             done_temp = done_mem[i];
                i = i+1;      
            end
            else                                       
               stop = 1 ;
        end
        else begin
            if (j%`COMPUTE_TIME == 1) begin
                in_sig = 0;
                ToMont = 0;      
            end

        end
        j = j+1;    // Increment j
    end

    always @(posedge clk)begin
        if (j%`COMPUTE_TIME == 0) begin
            if(Px_out !== px_out_temp || Py_out !== py_out_temp || done !== done_temp) begin
              if(Px_out !== px_out_temp) begin
                  $display("ERROR on PX at %d:output %h !=expect %h ",pattern_num, Px_out, px_out_temp);
                  $fdisplay(out_f,"ERROR on PX at %d:output %h !=expect %h ",pattern_num, Px_out, px_out_temp);
              end
              if(Py_out !== py_out_temp) begin
                  $display("ERROR on PY at %d:output %h !=expect %h ",pattern_num, Py_out, py_out_temp);
                  $fdisplay(out_f,"ERROR on PYat %d:output %h !=expect %h ",pattern_num, Py_out, py_out_temp);
              end
              if(done !== done_temp) begin
                  $display("ERROR on DONE at %d:output %h !=expect %h ",pattern_num, done, done_temp);
                  $fdisplay(out_f,"ERROR on DONE at %d:output %h !=expect %h ",pattern_num, done, done_temp);
              end
              err = err + 1 ;
            end
            pattern_num = pattern_num + 1; 
            if(pattern_num === DATA_LENGTH)  over = 1'b1;
        end
    end

    initial begin
          @(posedge stop)      
          if(over) begin
             $display("---------------------------------------------\n");
             if (err == 0)  begin
                $display("All data have been generated successfully!\n");
                $display("-------------------PASS-------------------\n");
             end
             else begin
                $display("There are %d errors!\n", err);
             end
                $display("---------------------------------------------\n");
          end
          else begin
            $display("---------------------------------------------\n");
            $display("Error!!! There is no any data output ...!\n");
            $display("-------------------FAIL-------------------\n");
            $display("---------------------------------------------\n");
          end
          $finish;
    end
   
endmodule
