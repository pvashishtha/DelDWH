from flask import Flask
import requests
app = Flask(__name__)

@app.route('/')
def hello_world():
   return 'Hello World'

@app.route('/country')
def country_predict():
    response=requests.get('https://api.nationalize.io/?name=prateek')
    text=response.json()
    name=text["country"][0]["country_id"]
    prob=text["country"][0]["probability"]
    return f'Country: {name}\nProbability: {prob}'

if __name__ == '__main__':
   app.run()