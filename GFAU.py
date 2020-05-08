"""
module GFAU();
    input [31:0] Px_mont, Py_mont;
    input [1:0] operation_select;
    output done;
    output[31:0] Px_mont_out, Py_mont_out;
endmodule
"""
from montmult import *
from random import randint

class GFAU:
	def __init__(self):
		self.px = 0
		self.py = 0
		return

def main(output_num):
	gfau = GFAU()
