import pytest
'''Find prime number, or chekc it'''
def check_prime(number):
    '''func to chekc number is prime or not'''
    iterator_variable=0
    for iterator_variable in range(2,number//2):
        if number%iterator_variable==0:
            return 'Not Prime'
    return 'Prime'

@pytest.mark.parametrize("number, message",[(12,'Not Prime'),(13, 'Prime')])
def test_check_prime(number, message):
    assert check_prime(number)==message
