# conversion funcs for length, temp, area
def m2km(x):
    return x/1000
def km2m(x):
    return x*1000
def sqm2sqy(x):
    return x*1.196
def sqy2sqm(x):
    return x*0.836
def far2cent(x):
    return (x-32)/9*5
def cent2far(x):
    return (x*9)/5 + 32