# import Crypto
# import Crypto.Util.number as num
import math

def reduce_p_B(p,B):
	U,V = p,B
	while V>0:
		print(U,':', bin(U), V, ':', bin(V))
		if U&1 == 0:
			print("Path 1")
			U = U >> 1
		elif V&1 == 0:
			print("Path 2")
			V = V >> 1
		elif U>V:
			print("Path 3")
			U = (U-V) >> 1
		else:
			print("Path 4")
			V = (V-U) >> 1
	print(U,':', bin(U), V, ':', bin(V))
	return


def get_y_from_x(x, a, b, p):
	y_sqr = (x**3 + a*x + b) % p
	return math.sqrt(y_sqr)

def MonMul(A,B,p,n):
	C = 0
	for i in range(n):
		Ai = A&1
		# print(Ai)
		T = C + Ai*int(B)
		C = (T + (int(T)&1)*p) >> 1
		A = A >> 1
		# print("T:", T, "C:", C)
	if C >= p:
		C = C-p
	# print("C:", C)
	return int(C)

# Input: b
# Output: b^(-1) * r (mod p)
def MonInv(B,p,n):
	r = (2**n)%p
	# B = (b*r)%p
	U,V,R,S,i = int(p),int(B),0,1,0
	while V>0:
		# print("U,V,R,S,i:", U,V,R,S,i)
		if int(U)&1 == 0:
			U = U >> 1
			S = S << 1
		elif int(V)&1 == 0:
			V = V >> 1
			R = R << 1
		elif U>V:
			U = (U-V) >> 1
			R = R+S
			S = S << 1
		else:
			V = (V-U) >> 1
			R = R << 1
			S = S+R
		i = i+1
	if R>=p:
		R = R-p
	for l in range(1,i-n+1):
		R = (R+(int(R)&1)*p) >> 1
	# print("R before:", R)
	R = p-R
	# print("R before:", R)
	# Is it (r**2)%p or (r**3)%p?
	R = MonMul(int(R),(r**2)%p,p,n)
	# print("R:", R)
	return int(R)

def ModDiv(A,B,p,n):
	U, V, R, S, i = int(p), int(B), 0, int(A), 0
	while V>0:
		print("U,V,R,S:", U,V,R,S)
		if U&1 == 0:
			print("Path 1")
			U = U >> 1
			S = S << 1
		elif V&1 == 0:
			print("Path 2")
			V = V >> 1
			R = R << 1
		elif U > V:
			print("Path 3")
			U = (U-V) >> 1
			R = R+S
			S = S << 1
		else:
			print("Path 4")
			V = (V-U) >> 1
			S = S+R
			R = R << 1
		i += 1
		if R >= p:
			R = R - p
		if S >= p:
			S = S - p
	print("U,V,R,S:", U,V,R,S)
	for j in range(1, i+1):
		R = (R + (int(R)&1)*p) >> 1
	print("Latest R:", R)
	R = p - R
	return R

def MonDiv(A,B,p,n):
	U, V, R, S, i = int(p), int(B), 0, int(A), 0
	cycles = 0
	while V>0:
		cycles += 2
		# print("U,V,R,S:", U,V,R,S)
		if U&1 == 0:
			# print("Path 1")
			U = U >> 1
			S = S << 1
		elif V&1 == 0:
			# print("Path 2")
			V = V >> 1
			R = R << 1
		elif U > V:
			# print("Path 3")
			U = (U-V) >> 1
			R = R+S
			S = S << 1
		else:
			# print("Path 4")
			V = (V-U) >> 1
			S = S+R
			R = R << 1
		i += 1
		if R >= p:
			R = R - p
		if S >= p:
			S = S - p
	# print("U,V,R,S:", U,V,R,S)
	# print("i:",i)
	for j in range(1, i+1-n):
		R = (R + (int(R)&1)*p) >> 1
		cycles += 1
	# print("Latest R:", R)
	R = p - R
	cycles += 1
	return R, cycles

def main():
	
	# define a,b,p
	# y^2 = x^3 + ax + b mod p
	# n = number of bits for p
	a,b = 2,2
	n = 4
	# p = num.getPrime(n, randfunc=Crypto.Random.get_random_bytes)
	p = 17
	x = 5
	y = get_y_from_x(x, a, b, p)
	r = (2**n)%p
	A = int(((3*(x**2) + a)*r) % p)
	B = int((2*y*r) % p)
	
	"""
	s = ((3 * x^2 + a) / (2 * y)) mod p
	  = (A * B^-1) mod p
	"""
	# This is actually ((A * B^-1) * r) mod p
	c, s = MonMul(A, MonInv(B, p, n), p, n)
	print("cycles:",c)
	print("s:", s)
	print("13r mod p:", (13*r)%p)
	# Using ModDiv(A,B)
	s = ModDiv(A,B,p,n)
	print("s using ModDiv(A, B):", s)
	x3 = (s**2 - 2*x)%p
	y3 = (s*(x - x3) - y)%p
	print("x3:", x3)
	print("y3:", y3)



if __name__ == '__main__':
	main()
