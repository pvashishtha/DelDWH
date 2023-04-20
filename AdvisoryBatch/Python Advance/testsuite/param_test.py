# parametrised testing
import pytest

def factorial(num):
    if num<2:
        return 1
    return num*factorial(num-1)

@pytest.mark.parametrize("num, output", [(2, 2), (-5, 1), (7, 5040), (3, 6), (-1, 1), (1, 1), (0, 1), (5, 120), (6, 720)])
def test_factorial(num, output):
    assert factorial(num) == output