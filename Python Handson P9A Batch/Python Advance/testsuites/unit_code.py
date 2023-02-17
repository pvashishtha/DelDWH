import pytest

def get_sqrt(num):
    import math
    return math.sqrt(num)

@pytest.mark.skip
def test_getsqrt_four():
    assert get_sqrt(4)==2

@pytest.mark.skip
def test_getsqrt_nine():
    assert get_sqrt(9)==3

@pytest.mark.xfail
def test_getsqrt_twenty_five():
    assert get_sqrt(25)==5
    
    
    