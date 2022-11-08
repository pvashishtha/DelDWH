import pytest
#TEST SUITE
def absoluteVal(num):
    if num>=0:
        return num
    else:
        return num*-1

@pytest.mark.parametrize("x,res", [(10,-10),(-20,20),(0,0)])
def test_absoluteVal(x, res):
    assert absoluteVal(x)==res


    
