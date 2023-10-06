from fastapi import FastAPI

app=FastAPI()

@app.get('/')
def home_page():
    return {"Message":"Welcome to Fast & Furious API"}

@app.get('/factorial')
async def factorial(num:int):
    n=num
    f=1
    while n>0:
        f*=n
        n-=1
    return {"factorial":f"{f}"}














