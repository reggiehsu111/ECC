"""
module Domain_Transfer(clk, reset, ToMont, in_sig, Px_i, Py_i, Prime, Px_mont, Py_mont, done);      
    input clk, reset, ToMont, in_sig;
    input [31:0] Px_i, Py_i, Prime; 
    output [31:0] Px_mont, Py_mont;
    output done;
"""

from random import randint
from montmult import *

num_data = 10

def to_mont(P, prime):
	P = P%prime
	print("P:", P)
	print("prime:", prime)
	r = 2**32
	P_mont = (r * P) % prime 
	if P >= prime:
		P -= prime
	for i in range(32):
		P = P << 1
		if P >= prime:
			P -= prime
	print("P_mont:", P_mont)
	print("P shifted:", P)
	print('')
	assert P == P_mont
	return P_mont


def main():
	Px_list = []
	Py_list = []
	Px_golden = []
	Py_golden = []
	Prime_list = []
	for i in range(num_data):
		prime = randint(0, 2**32)
		Px = randint(0, 2**32)
		Py = randint(0, 2**32)
		Px_list.append(Px)
		Py_list.append(Py)
		Prime_list.append(prime)
		Px_golden.append(to_mont(Px, prime))
		Py_golden.append(to_mont(Py, prime))


	with open('sim_data/DT/Px.dat', 'w') as f:
		for x in Px_list:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/DT/Py.dat', 'w') as f:
		for x in Py_list:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/DT/Prime.dat', 'w') as f:
		for x in Prime_list:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/DT/Px_golden.dat', 'w') as f:
		for x in Px_golden:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/DT/Py_golden.dat', 'w') as f:
		for x in Py_golden:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/DT/Done.dat', 'w') as f:
		for x in range(len(Py_golden)):
			f.write("{}\n".format(1))

if __name__ == '__main__':
	main()
