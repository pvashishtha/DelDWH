'''module to find factorial and check prime'''
def factorial(x):
    '''find factorial of x: factorial(x)'''
    if x<=2:
        return x
    else:
        return x*factorial(x-1)

def check_prime(x):
    for i in range(2,(x//2)+1):
        if x%i==0:
            return False
    return True