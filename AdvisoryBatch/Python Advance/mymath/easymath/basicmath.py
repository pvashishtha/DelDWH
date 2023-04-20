'''This module contains basic mathematical functionalities'''
def add(x,y):
    '''Add two numbers: add(x,y)'''
    return x+y
def sub(x,y):
    '''Subtract y from x: sub(x,y)'''
    return x-y
def mul(x,y):
    '''Multiplies x and y: mul(x,y)'''
    return x*y
def div(x,y):
    '''Divides x by y: div(x,y)'''
    if y==0:
        return 'Y can not be zero.'
    else:
        return x/y
def exp(x,y):
    '''Exponential of x with y: exp(x,y)'''
    return x**y