import pytest

def find_exp(x, y):
    return x**y

@pytest.mark.parametrize("x, y, result", [(2,2,4), (2,3,8), (3,2,9), (5,0,1), (3,3,27), (4,2,16), (7,2,49)])
def test_find_exp(x, y, result):
    assert find_exp(x,y) == result