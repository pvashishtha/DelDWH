import pytest
def factorial(n):
    if n<2:
        return 1
    else:
        return n*factorial(n-1)

@pytest.mark.xfail
def test_factorial_6_720():
    value=6 # Arrange
    expected=120
    answer=factorial(value) # Act
    assert answer==expected # Assert
    
@pytest.mark.skip
def test_factorial_5_120():
    value=5 # Arrange
    expected=120
    answer=factorial(value) # Act
    assert answer==expected # Assert
    
@pytest.mark.skip
def test_factorial_2_2():
    value=2 # Arrange
    expected=2
    answer=factorial(value) # Act
    assert answer==expected # Assert
    
@pytest.mark.negative
def test_factorial_neg3_1():
    value=-3 # Arrange
    expected=1
    answer=factorial(value) # Act
    assert answer==expected # Assert
    
@pytest.mark.negative
def test_factorial_neg10_1():
    value=-10 # Arrange
    expected=1
    answer=factorial(value) # Act
    assert answer==expected # Assert
    
@pytest.mark.negative
def test_factorial_neg100_1():
    value=-100 # Arrange
    expected=1
    answer=factorial(value) # Act
    assert answer==expected # Assert