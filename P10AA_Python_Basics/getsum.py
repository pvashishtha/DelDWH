'''function factorial(n)'''
def factorial(number):
    '''function to find factorial of given number.
    example: factorial(5) returns 120'''
    if number<2:
        return 1
    return number*factorial(number-1)
