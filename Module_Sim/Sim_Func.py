from montmult import *

class Sim_Func:
    def __init__(self, cycles):
        self.cycles = cycles
        return
    
    def __call__(self, *args, **kwargs):
        func_outs = self.operate(*args, **kwargs)
        return self.cycles, func_outs

    # Define function body
    def operate(self):
        operate_cycles = self.cycles
        results = 0
        return operate_cycles, results

def calc_cycle(function):
    cycles = 0
    def wrapper(*args, **kwargs):
        result = function(*args, **kwargs)
        return result
    return wrapper


def func1():
    print("Called function 1")
    return 1, 1

def func2():
    c,r = func1()
    print("Called function 2")
    return c+2, 1

# class func1(Sim_Func):
#     def __init__(self):
#         cycles = 1
#         super().__init__(cycles)
#         return

#     def operate(self):
#         print("Called function 1")
#         return self.cycles, 1

# class func2(Sim_Func):
#     def __init__(self):
#         cycles = 2
#         super().__init__(cycles)

#         return

#     def operate(self):
#         c, r = self.F1()
#         print("Called function 2")
#         return self.cycles+c, 1


def test():
    c,r = func2()
    print(c,r)
    return

if __name__ == '__main__':
    test()