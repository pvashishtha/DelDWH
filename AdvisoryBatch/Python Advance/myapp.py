from flask import Flask, request
import requests

app=Flask(__name__)

@app.route('/')
def home():
    return 'Welcome to Deloitte API Server.'

@app.route('/details')
def details():
    return {"msg":"Office Location: Hydearabad Locality: Hitech City Towers: 03"}

@app.route('/bitcoin')
def btc():
    response=requests.get('https://api.coindesk.com/v1/bpi/currentprice.json')
    d=response.json()
    coin=d['chartName']
    price=d['bpi']['USD']['rate']
    return f'{coin} rate today is $ {price}'

@app.route('/factorial')
def fact():
    n=int(request.args.get('number'))
    fact=1
    if n<2:
        return str(1)
    else:
        while n>0:
            fact*=n
            n-=1
        return f'Factorial of {request.args.get("number")} is: '+str(fact)

@app.route('/stamp_log')
def stamping_logs():
    stamp=request.args.get('tstamp')
    with open('stamp.txt', 'a') as file:
        file.write(stamp+'\n')
    return "Success"

if __name__=='__main__':
    app.run(debug=True)
    
    
    
    
    
    
    