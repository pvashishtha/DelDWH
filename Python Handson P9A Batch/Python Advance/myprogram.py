'''finding factorial'''
def fact(num):
    '''calc factorial of integer by fact(num) format'''
    if num<=1:
        return 1
    return num*fact(num-1)
fact(7)
