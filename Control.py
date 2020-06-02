"""

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
    
"""

from montmult import *
from random import randint
import Crypto.Util.number as num
import Crypto

class Control:
	def __init__(self):
		self.px = 0
		self.py = 0
		return
    
    def operate(self):
        return

class KeyShifter:
    def __init__(self, key):
        self.key = key
        return

    def shift(self):
        return

def main(output_num):
    control = Control()
    keyshifter = KeyShifter()
    gfau = GFAU()

    prime = num.getPrime(32)
    Px = randint(0, 2**32)
    Py = randint(0, 2**32)
    Px = Px%prime
    Py = Py%prime
    key = randint(0, 2**32)


    Key = randint(0, 2**32)
    raw_prime = num.getPrime(n, randfunc=Crypto.Random.get_random_bytes)
    raw_px = randint(0, 2**32)
    raw_py = randint(0, 2**32)
    # Step 1. Read in partial key


if __name__ == '__main__':
    main()