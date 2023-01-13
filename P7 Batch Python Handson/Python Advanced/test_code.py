import pytest

from code import *

@pytest.mark.parametrize("num, output", [(-1,1),(0,1),(4,24),(5,120),(6,720)])
def test_fact_multiplevalues(num, output):
    assert fact(num)==output