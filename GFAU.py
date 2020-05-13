"""
module GFAU(
	// inputs:
	i_clk,
	i_rst,
	in_0,
	in_1,
	prime,
	operation_select,
	done_from_control,

	// outputs:
	result,
	done_to_control);
"""
from montmult import *
from random import randint

num_data = 10

class GFAU:
	def __init__(self):
		return
	
	def operate(self, i_clk, i_rst, in_0, in_1, prime, ops, dfc):
		if dfc:
			result = 0
			if ops == 0:
				# add
				result = (in_0 + in_1) % prime
			elif ops == 1:
				# sub
				result = (in_0 - in_1) % prime
			elif ops == 2:
				# mult
				result = MonMul(in_0, in_1, prime, 32)
			else:
				# div
				result = MonDiv(in_0, in_1, prime, 32)
			return result, 1
		else:
			return 0, 0

def main(output_num):
	gfau = GFAU()
	Px_list = []
	Py_list = []
	Prime_list = []
	for i in range(num_data):
		prime = num.getPrime(32, randfunc=Crypto.Random.get_random_bytes)
		Px = randint(0, 2**32)
		Py = randint(0, 2**32)
		Px = Px%prime
		Py = Py%prime
		Px_list.append(Px)
		Py_list.append(Py)
		Prime_list.append(prime)

		Px_step_out.append(i)
		Py_step_out.append(i)
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
