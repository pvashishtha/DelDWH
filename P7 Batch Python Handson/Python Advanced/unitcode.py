import pytest

def fact(num):
    if num<2:
        return 1
    else:
        return num*fact(num-1)
    return None

@pytest.mark.parametrize("num, output", [(-1,1),(0,1),(4,24),(5,120),(6,720)])
def test_fact_multiplevalues(num, output):
    assert fact(num)==output