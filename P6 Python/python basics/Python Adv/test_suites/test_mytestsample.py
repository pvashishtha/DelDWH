import pytest

def find_factorial(num):
    if num<=1:
        return 1
    else:
        return num*find_factorial(num-1)
    return 1


@pytest.mark.parametrize("x,y",[(0,1),(1,1),(5,120),(6,720),(-3,1)])
def test_find_factorial(x,y):
    assert find_factorial(x)==y


def test_fact_5():
    assert find_factorial(5)==120

@pytest.mark.xfail
def test_fact_6():
    assert find_factorial(6)==130

@pytest.mark.skip
def test_fact_neg():
    assert find_factorial(-3)==1
    
    
    
    
    
    
    
    
    
    
    
    
    