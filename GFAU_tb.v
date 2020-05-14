`timescale 1ns/10ps
`define CYCLE    10.0


`define PX              "./sim_data/GFAU/Px.dat"        
`define PY              "./sim_data/GFAU/Py.dat" 
`define PRIME           "./sim_data/GFAU/Prime.dat"
`define DONE            "./sim_data/GFAU/Done.dat"
`define DONE_ADD        "./sim_data/GFAU/Done_add.dat"
`define DONE_SUB        "./sim_data/GFAU/Done_sub.dat"
`define DONE_MULT        "./sim_data/GFAU/Done_mult.dat"
`define DONE_DIV        "./sim_data/GFAU/Done_div.dat"
`define OPS             "./sim_data/GFAU/OPS.dat"
`define DFC             "./sim_data/GFAU/DFC.dat"
`define RESULT_GOLDEN   "./sim_data/GFAU/Result_golden.dat"  

module GFAU_test();

    parameter OP_DATA_LENGTH = 10; // data length for each operation
    parameter DATA_LENGTH = 2080; // modify this from GFAU.py

    reg           clk;
    reg           reset, dfc;
    reg   [1:0]   ops;
    reg   [31:0]  Px_i, Py_i, Prime;
    wire          done, done_add, done_sub, done_mult, done_div;
    wire  [31:0]  Result_out;

    // Inputs from files
    reg   dfc_mem                [0:DATA_LENGTH-1];
    reg   [1:0] ops_mem          [0:DATA_LENGTH-1];
    reg   [31:0]  px_mem         [0:DATA_LENGTH-1];
    reg   [31:0]  py_mem         [0:DATA_LENGTH-1];
    reg   [31:0]  prime_mem      [0:DATA_LENGTH-1];

    // Outputs from files
    reg   [31:0]  result_golden_mem  [0:DATA_LENGTH-1];
    reg   done_mem               [0:DATA_LENGTH-1];
    reg   done_add_mem               [0:DATA_LENGTH-1];
    reg   done_sub_mem               [0:DATA_LENGTH-1];
    reg   done_mult_mem               [0:DATA_LENGTH-1];
    reg   done_div_mem               [0:DATA_LENGTH-1];

    reg   [31:0] result_temp;
    reg   done_temp, done_add_temp, done_sub_temp, done_mult_temp, done_div_temp;

    reg           stop;
    integer       i, j, out_f, err, pattern_num;
    reg           over;


   GFAU gfau0(
	      .i_clk(clk),
	      .i_rst(reset),
	      .in_0(Px_i),
	      .in_1(Py_i),
	      .prime(Prime),
	      .operation_select(ops),
	      .done_from_control(dfc),
	      .result(Result_out),
	      .done_to_control(done),
	      .done_add(done_add),
	      .done_sub(done_sub),
	      .done_mult(done_mult),
	      .done_div(done_div));
       
    //initial $sdf_annotate(`SDFFILE, top);
    // Inputs
    initial $readmemh (`PX,  px_mem);
    initial $readmemh (`PY,  py_mem);
    initial $readmemh (`PRIME,  prime_mem);
    initial $readmemh (`OPS,  ops_mem);
    initial $readmemh (`DFC,  dfc_mem);

    // Outputs
    initial $readmemh (`DONE,  done_mem);
    initial $readmemh (`DONE_ADD,  done_add_mem);
    initial $readmemh (`DONE_SUB,  done_sub_mem);
    initial $readmemh (`DONE_MULT,  done_mult_mem);
    initial $readmemh (`DONE_DIV,  done_div_mem);
    initial $readmemh (`RESULT_GOLDEN,  result_golden_mem);

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
        $dumpfile("GFAU.fsdb");
        $dumpvars;

       out_f = $fopen("out.dat");
       if (out_f == 0) begin
            $display("Output file open error !");
            $finish;
       end
    end

    always @(negedge clk)begin
       if (i<DATA_LENGTH) begin
          // Get input
            Px_i = px_mem[i];
            Py_i = py_mem[i];
            Prime = prime_mem[i];
            ops = ops_mem[i];
            dfc = dfc_mem[i];
         // Get output
            result_temp = result_golden_mem[i];
            done_temp = done_mem[i];
            done_add_temp = done_add_mem[i];
            done_sub_temp = done_sub_mem[i];
            done_mult_temp = done_mult_mem[i];
            done_div_temp = done_div_mem[i];


         i = i+1;
       end
       else stop = 1;
    end


    always @(posedge clk)begin
        if (done) begin
            if(Result_out !== result_temp || done !== done_temp || done_add !== done_add_temp || done_sub !== done_sub_temp || done_mult !== done_mult_temp || done_div !== done_div_temp) begin
              if(Result_out !== result_temp) begin
                  $display("ERROR on Result at %d:output %h !=expect %h ",pattern_num, Result_out, result_temp);
                  $fdisplay(out_f,"ERROR on Result at %d:output %h !=expect %h ",pattern_num, Result_out, result_temp);
              end
              if(done !== done_temp) begin
                  $display("ERROR on DONE at %d:output %h !=expect %h ",pattern_num, done, done_temp);
                  $fdisplay(out_f,"ERROR on DONE at %d:output %h !=expect %h ",pattern_num, done, done_temp);
              end
              if(done_add !== done_add_temp) begin
                  $display("ERROR on DONE_ADD at %d:output %h !=expect %h ",pattern_num, done_add, done_add_temp);
                  $fdisplay(out_f,"ERROR on DONE_ADD at %d:output %h !=expect %h ",pattern_num, done_add, done_add_temp);
              end
              if(done_sub !== done_sub_temp) begin
                  $display("ERROR on DONE_SUB at %d:output %h !=expect %h ",pattern_num, done_sub, done_sub_temp);
                  $fdisplay(out_f,"ERROR on DONE_SUB at %d:output %h !=expect %h ",pattern_num, done_sub, done_sub_temp);
              end
              if(done_mult !== done_mult_temp) begin
                  $display("ERROR on DONE_MULT at %d:output %h !=expect %h ",pattern_num, done_mult, done_mult_temp);
                  $fdisplay(out_f,"ERROR on DONE_MULT at %d:output %h !=expect %h ",pattern_num, done_mult, done_mult_temp);
              end
              if(done_div !== done_div_temp) begin
                  $display("ERROR on DONE_DIV at %d:output %h !=expect %h ",pattern_num, done_div, done_div_temp);
                  $fdisplay(out_f,"ERROR on DONE_DIV at %d:output %h !=expect %h ",pattern_num, done_div, done_div_temp);
              end
              err = err + 1 ;
            end
            pattern_num = pattern_num + 1; 
            if(pattern_num === 4*(OP_DATA_LENGTH))  over = 1'b1;
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
