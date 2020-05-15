"""
module Control(
                i_clk,
                i_reset,
                GFAU_done,
                Keyshift_done,
                PartKey,
                GFAU_result,
                Px_mont, Py_mont,
                operation_select,
                done_keyshift,
                done_control,
                raw1, raw2, raw_prime,
                output_1, output_2
                );
  /*========================IO declaration============================ */	  

    input i_clk;
    input i_reset;

    input GFAU_done;                        // done signal from GFAU
    input Keyshift_done;                    // done signal from  key shifter

    input PartKey;                          // single bit for key
    input [31:0] GFAU_result;               // Result from GFAU

    input [31:0] raw1, raw2, raw_prime;     // non-transferred input and prime

    output [31:0] Px_mont, Py_mont;         // transferred inputs To GFAU
    output [1:0] operation_select;          // 00, 01, 10, 11 add, subtract, multiple, divide
    output done_keyshift;                   // done signal to key shifter for completion of add or double
    output done_control;                    // done signal to GFAU for finishing saving the return value to register

    output [31:0] output_1, output_2;       // final output to Top(be inverse transferred)
    output all_done;                        // kP is finally computed singal to Top
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

def main(output_num):
    control = Control()
    keyshifter = KeyShifter()
    gfau = GFAU()

    Key = randint(0, 2**32)
    raw_prime = num.getPrime(n, randfunc=Crypto.Random.get_random_bytes)
    raw_px = randint(0, 2**32)
    raw_py = randint(0, 2**32)
    # Step 1. Read in partial key


if __name__ == '__main__':
    main()