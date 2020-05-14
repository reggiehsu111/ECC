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
import Crypto.Util.number as num
import Crypto

num_data = [10,10,10,10]
OP_CYCLES = [1, 1, 100, 100]

class GFAU:
	def __init__(self):
		return
	
	def operate(self, in_0, in_1, prime, ops, dfc):
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

def append_done(dtc, done_list, done_add, done_sub, done_mult, done_div, ops):
	if dtc:
		done_list.append(1)
	else:
		done_list.append(0)
	done_add.append(0)
	done_sub.append(0)
	done_mult.append(0)
	done_div.append(0)
	if dtc:
		if ops == 0:
			done_add.pop()
			done_add.append(1)
		elif ops == 1:
			done_sub.pop()
			done_sub.append(1)
		elif ops == 2:
			done_mult.pop()
			done_mult.append(1)
		else:
			done_div.pop()
			done_div.append(1)
	
	return done_list, done_add, done_sub, done_mult, done_div
def main():
	gfau = GFAU()
	# inputs
	Px_list = []
	Py_list = []
	Prime_list = []
	ops_list = []
	dfc_list = []

	# outputs
	result_list = []
	done_list = []
	done_add = []
	done_sub = []
	done_mult = []
	done_div = []
	data_count = 0
	op_type = -1

	for i in num_data:
		op_type += 1
		for j in range(i):
			data_count += 1
			
			prime = num.getPrime(32)
			Px = randint(0, 2**32)
			Py = randint(0, 2**32)
			Px = Px%prime
			Py = Py%prime

			# dfc = 1
			Px_list.append(Px)
			Py_list.append(Py)
			Prime_list.append(prime)
			ops_list.append(op_type)
			dfc_list.append(1)
			result_list.append(0)
			done_list, done_add, done_sub, done_mult, done_div = append_done(0, done_list, done_add, done_sub, done_mult, done_div, op_type)


			# input something
			result, done = gfau.operate(Px, Py, prime, op_type, 1)
			print("Px:", Px)
			print("Py:", Py)
			print("Prime:", prime)
			print("op_type:", op_type)
			print("result:", result)
			print('')

			# wait for some time (output 0s)
			for x in range(OP_CYCLES[op_type]):
				Px_list.append(Px)
				Py_list.append(Py)
				Prime_list.append(prime)
				ops_list.append(op_type)
				dfc_list.append(0)
				result_list.append(result)
				done_list, done_add, done_sub, done_mult, done_div = append_done(0, done_list, done_add, done_sub, done_mult, done_div, op_type)

			# output
			Px_list.append(0)
			Py_list.append(0)
			Prime_list.append(0)
			ops_list.append(op_type)
			dfc_list.append(0)
			result_list.append(result)
			done_list, done_add, done_sub, done_mult, done_div = append_done(1, done_list, done_add, done_sub, done_mult, done_div, op_type)
	print("Data length:", len(result_list))

			


	with open('sim_data/GFAU/Px.dat', 'w') as f:
		for x in Px_list:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/Py.dat', 'w') as f:
		for x in Py_list:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/Prime.dat', 'w') as f:
		for x in Prime_list:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/OPS.dat', 'w') as f:
		for x in ops_list:
			hex_x = str(hex(x))[2:].upper().zfill(1)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/DFC.dat', 'w') as f:
		for x in dfc_list:
			hex_x = str(hex(x))[2:].upper().zfill(1)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))

	with open('sim_data/GFAU/Result_golden.dat', 'w') as f:
		for x in result_list:
			hex_x = str(hex(x))[2:].upper().zfill(8)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/Done.dat', 'w') as f:
		for x in done_list:
			hex_x = str(hex(x))[2:].upper().zfill(1)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/Done_add.dat', 'w') as f:
		for x in done_add:
			hex_x = str(hex(x))[2:].upper().zfill(1)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/Done_sub.dat', 'w') as f:
		for x in done_sub:
			hex_x = str(hex(x))[2:].upper().zfill(1)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/Done_mult.dat', 'w') as f:
		for x in done_mult:
			hex_x = str(hex(x))[2:].upper().zfill(1)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))
	with open('sim_data/GFAU/Done_div.dat', 'w') as f:
		for x in done_div:
			hex_x = str(hex(x))[2:].upper().zfill(1)
			f.write("{}\t\t\t//{}\n".format(hex_x,x))

if __name__ == '__main__':
	main()
