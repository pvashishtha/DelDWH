'''Find prime number, or chekc it'''
def check_prime(number):
    '''func to chekc number is prime or not'''
    iterator_variable=0
    for iterator_variable in range(2,number//2):
        if number%iterator_variable==0:
            return 'Not Prime'
    return 'Prime'
