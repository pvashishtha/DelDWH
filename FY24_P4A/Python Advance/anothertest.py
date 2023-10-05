import pytest
def factorial(n):
    if n<2:
        return 1
    else:
        return n*factorial(n-1)

@pytest.mark.parametrize("x,y",[(-1,1),(0,1),(4, 24),(7,5040)])
def test_factorial(x,y):
    assert factorial(x)==y
    
    
    
    
    
    
    