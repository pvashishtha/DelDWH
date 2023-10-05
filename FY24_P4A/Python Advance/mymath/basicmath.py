def add(*args):
    '''add(*args) finds sum of any number of values provided.
    Example: add(2,3,4,5) will return 14 as answer.'''
    return sum(args)

def sub(a,b):
    return a-b

def mul(*args):
    m=1
    for n in args:
        m*=n
    return m

def trudiv(a,b):
    return a/b