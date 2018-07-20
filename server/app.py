from flask import Flask, render_template, request
from tweets import tweets_for_user
from json import dumps as to_json

app = Flask(__name__.split('.')[0])

@app.route('/')
def home():
  return render_template('home.html')

@app.route('/tweets', methods=['GET'])
def get_tweets():
  username = request.args.get('username')
  count = request.args.get('count')
  tweets = to_json(tweets_for_user(username, count))
  return tweets