`timescale 1ns/10ps
`define CYCLE    10           	         // Modify your clock period here
//`define SDFFILE  "./alu.sdf"	         // Modify your sdf file name
`define PX_MONT         "./sim_data/gfau_px_mont.dat"        
`define PY_MONT         "./sim_data/gfau_py_mont.dat" 
`define OP_SELECT       "./sim_data/gfau_op_select.dat" 
`define DONE            "./sim_data/gfau_done.dat" 
`define PX_MONT_OUT     "./sim_data/gfau_px_mont_out.dat" 
`define PY_MONT_OUT     "./sim_data/gfau_py_mont_out.dat" 

module GFAU_test;

parameter DATA_LENGTH   = 80;
parameter OUT_LENGTH    = 82;

reg           clk;
reg           reset;
reg   [31:0]   px_mont, py_mont;
reg   [1:0]   op_s;
wire          done;
wire  [31:0]  px_mont_out, py_mont_out;

reg   [1:0]   op_s_mem   [0:DATA_LENGTH-1];
reg   done_mem   [0:DATA_LENGTH-1];
reg   [31:0]  px_out_mem   [0:OUT_LENGTH-1];
reg   [31:0]  py_out_mem   [0:OUT_LENGTH-1];
reg   [31:0]   px_mont_mem  [0:DATA_LENGTH-1];
reg   [31:0]   py_mont_mem  [0:DATA_LENGTH-1];
reg   [31:0]  px_out_temp, py_out_temp;
reg   done_temp;

reg           stop;
integer       i, out_f, err, pattern_num;
reg           over;

   GFAU gfau_0( .clk(clk), .reset(reset), .Px_mont(px_mont), .Py_mont(py_mont), .operation_select(op_s), .done(done), .Px_mont_out(px_mont_out), .Py_mont_out(py_mont_out) );          
   
//initial $sdf_annotate(`SDFFILE, top);
initial	$readmemh (`PX_MONT,  px_mont_mem);
initial	$readmemh (`PY_MONT,  py_mont_mem);
initial $readmemh (`PX_MONT_OUT,  px_out_mem);
initial $readmemh (`PY_MONT_OUT,  py_out_mem);
initial	$readmemh (`OP_SELECT,    op_s_mem);
initial	$readmemh (`DONE, done_mem);

initial begin
   clk         = 1'b1;
   reset       = 1'b1;
   stop        = 1'b0;  
   over        = 1'b0;
   pattern_num = 0;
   err         = 0;
   i           = 0;   
    #2.5 reset=1'b0;                            // system reset
    #2.5 reset=1'b1;

end

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	$dumpfile("gfau.fsdb");
	$dumpvars;

   out_f = $fopen("out.dat");
   if (out_f == 0) begin
        $display("Output file open error !");
        $finish;
   end
end

always @(negedge clk)begin
    if (i < OUT_LENGTH) begin
		 if(i < DATA_LENGTH)begin
          px_mont = px_mont_mem[i];
          py_mont = py_mont_mem[i];
          op_s = op_s_mem[i];

	    end
		 done_temp = done_mem[i];
     px_out_temp = px_out_mem[i];
     py_out_temp = py_out_mem[i];
	    i = i+1;      
    end
    else                                       
       stop = 1 ;      
end

always @(posedge clk)begin
    if(px_mont_out !== px_out_temp || py_mont_out !== py_out_temp || done !== done_temp) begin
      if(px_mont_out !== px_out_temp) begin
          $display("ERROR on PX_MONT at %d:output %h !=expect %h ",pattern_num-2, px_mont_out, px_out_temp);
  	      $fdisplay(out_f,"ERROR on PX_MONT at %d:output %h !=expect %h ",pattern_num-2, px_mont_out, px_out_temp);
      end
      if(py_mont_out !== py_out_temp) begin
          $display("ERROR on PY_MONT at %d:output %h !=expect %h ",pattern_num-2, py_mont_out, py_out_temp);
          $fdisplay(out_f,"ERROR on PY_MONT at %d:output %h !=expect %h ",pattern_num-2, py_mont_out, py_out_temp);
      end
      if(done !== done_temp) begin
          $display("ERROR on DONE at %d:output %h !=expect %h ",pattern_num-2, done, done_temp);
          $fdisplay(out_f,"ERROR on DONE at %d:output %h !=expect %h ",pattern_num-2, done, done_temp);
      end
      err = err + 1 ;
    end
    pattern_num = pattern_num + 1; 
    if(pattern_num === OUT_LENGTH)  over = 1'b1;
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









