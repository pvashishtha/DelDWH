from flask import Flask
import requests

app=Flask(__name__)

@app.route('/')
def welcome():
    return '<h1>Welcome to Flask App'

@app.route('/country')
def country_predict():
    response=requests.get('https://api.nationalize.io/?name=prateek')
    text=response.json()
    country=text['country'][0]['country_id']
    prob=text['country'][0]['probability']
    return f'<h2 style="color:blue;">Country: {country}<br>Probability: {prob}'

@app.route('/gender')
def gender_predict():
    response=requests.get('https://api.genderize.io/?name=prateek')
    text=response.json()
    name=text['name']
    gender=text['gender']
    prob=text['probability']
    return f'<h2 style="color:red;">Name: {name}<br>Gender: {gender}<br>Probability: {prob}'

if __name__=='__main__':
    app.run()
    
