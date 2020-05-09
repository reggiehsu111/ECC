"""
module Domain_Transfer(clk, reset, ToMont, in_sig, Px_i, Py_i, Prime, Px_mont, Py_mont, done);      
    input clk, reset, ToMont, in_sig;
    input [31:0] Px_i, Py_i, Prime; 
    output [31:0] Px_mont, Py_mont;
    output done;
"""

from random import randint
from montmult import *

num_data_to_mont = 10
num_data_to_reg = 10

def to_reg(P, prime):
	P_steps = []
	# print("P:", P)
	# print("prime:", prime)
	for i in range(32):
		if P & 1:
			P = (P + prime) >> 1
		else:
			P = P >> 1
		P_steps.append(P)
	# print("P_reg:", P_reg)
	# print("P shifted:", P)
	# print('')
	# assert P == P_reg
	return P, P_steps


def to_mont(P, prime):
	P_steps = []
	# print("P:", P)
	# print("prime:", prime)
	r = 2**32
	P_mont = (r * P) % prime 
	if P >= prime:
		P -= prime
	for i in range(32):
		P = P << 1
		if P >= prime:
			P -= prime
		P_steps.append(P)
	# print("P_mont:", P_mont)
	# print("P shifted:", P)
	# print('')
	assert P == P_mont
	return P_mont, P_steps


def main():
	Px_list = []
	Py_list = []
	Px_golden = []
	Py_golden = []
	Prime_list = []
	Px_step_out = []
	Py_step_out = []
	to_mont_list = []
	for i in range(num_data_to_mont):
		prime = randint(0, 2**32)
		Px = randint(0, 2**32)
		Py = randint(0, 2**32)
		Px = Px%prime
		Py = Py%prime
		Px_list.append(Px)
		Py_list.append(Py)
		Prime_list.append(prime)
		px_mont, Px_step = to_mont(Px, prime)
		py_mont, Py_step = to_mont(Py, prime)
		Px_step_out.append(i)
		Py_step_out.append(i)
		to_mont_list.append(1)
		Px_step_out.extend(Px_step)
		Py_step_out.extend(Py_step)
		Px_golden.append(px_mont)
		Py_golden.append(py_mont)

	for i in range(num_data_to_mont):
		prime = randint(0, 2**32)
		Px = randint(0, 2**32)
		Py = randint(0, 2**32)
		Px = Px%prime
		Py = Py%prime
		Px_list.append(Px)
		Py_list.append(Py)
		Prime_list.append(prime)
		px_mont, Px_step = to_reg(Px, prime)
		py_mont, Py_step = to_reg(Py, prime)
		Px_step_out.append(i + num_data_to_mont)
		Py_step_out.append(i + num_data_to_mont)
		to_mont_list.append(0)
		Px_step_out.extend(Px_step)
		Py_step_out.extend(Py_step)
		Px_golden.append(px_mont)
		Py_golden.append(py_mont)


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
		for x in range(num_data_to_mont + num_data_to_reg):
			f.write("{}\n".format(1))
	with open('sim_data/DT/InSig.dat', 'w') as f:
		for x in range(num_data_to_mont + num_data_to_reg):
			f.write("{}\n".format(1))
	with open('sim_data/DT/ToMont.dat', 'w') as f:
		for x in to_mont_list:
			f.write("{}\n".format(x))

	with open('sim_data/DT/Px_steps.txt', 'w') as f:
		for x in Px_step_out:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))

	with open('sim_data/DT/Py_steps.txt', 'w') as f:
		for x in Py_step_out:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))


# prime = 15
# P = 3
# 3 * 2^-4 mod 15 = 
def test_to_reg():
	for i in range(num_data_to_mont):
		prime = randint(0, 2**32)
		Px = randint(0, 2**32)
		Py = randint(0, 2**32)
		Px = Px%prime
		Py = Py%prime
		print("Prime:", prime)
		print("Px:", Px)
		print("Py:", Py)
		px_mont, Px_step = to_mont(Px, prime)
		py_mont, Py_step = to_mont(Py, prime)
		print("px_mont:", px_mont)
		print("py_mont:", py_mont)
		px_reg, _ = to_reg(px_mont, prime)
		py_reg, _ = to_reg(py_mont, prime)
		print("px_reg:", px_reg)
		print("py_reg:", py_reg)
		print("Is the transformation correct?", px_reg == Px and py_reg == Py)

if __name__ == '__main__':
	# main()
	test_to_reg()
