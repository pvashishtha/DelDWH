import math
import pytest

@pytest.fixture
def constant_value():
    input_value=math.pi
    return input_value

#@pytest.mark.xfail
@pytest.mark.skip
def test_perimeter(constant_value):
    r=10
    assert 2*constant_value*r == 62
    
def test_area(constant_value):
    r=5
    assert constant_value*(r**2) == 78.53981633974483