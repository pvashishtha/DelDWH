import pytest

def check_values(num1, num2):
    return num1%num2

@pytest.fixture
def input_num():
    return 39

def test_check_values_3(input_num):
    assert check_values(input_num, 3) == 0
    
def test_check_values_6(input_num):
    assert check_values(input_num, 6) == 0