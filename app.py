#App

from flask import Flask, jsonify, render_template
import requests

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/rates')
def rates():
    r = requests.get('https://open.er-api.com/v6/latest/USD')
    return jsonify(r.json())

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')