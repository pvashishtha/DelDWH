import math
import pytest

@pytest.mark.integer
def test_sqrt_64():
    num=64
    assert math.sqrt(num) == 8
    
@pytest.mark.integer
def test_sqrt_81():
    num=81
    assert math.sqrt(num) == 9
    
@pytest.mark.floating
def test_sqrt_121():
    num=3.14
    assert math.sqrt(num) == 1.772004514666935
    
@pytest.mark.pow
def test_pow():
    x=2
    y=3
    assert math.pow(x,y) == 8
    