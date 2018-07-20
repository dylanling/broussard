import os
import twitter
import random
import sys

consumer_key = os.environ['TWITTER_CONSUMER_KEY']
consumer_secret = os.environ['TWITTER_CONSUMER_SECRET']
access_token_key = os.environ['TWITTER_ACCESS_TOKEN_KEY']
access_token_secret = os.environ['TWITTER_ACCESS_TOKEN_SECRET']

client = twitter.Api(
  consumer_key=consumer_key,
  consumer_secret=consumer_secret,
  access_token_key=access_token_key,
  access_token_secret=access_token_secret)

def tweets_for_user(username, count):
  return [data.text for data in client.GetUserTimeline(screen_name=username, include_rts=False, exclude_replies=True, count=count)]

def to_markov_data(tweets):
  return [tweet.split(' ') for tweet in tweets]

class MarkovChain:
  def __init__(self, tweets):
    self.initial_states = [tweet[0] for tweet in tweets]
    self.transitions = {}
    self.init_transitions(tweets)

  def init_transitions(self, tweets):
    for tweet in tweets:
      for pair in zip(tweet, tweet[1:]):
        if pair[0] in self.transitions:
          self.transitions[pair[0]] += [pair[1]]
        else:
          self.transitions[pair[0]] = [pair[1]]
    
  def generate_tweet(self, max_length, current=[]):
    current = [random.choice(self.initial_states)] if not current else current
    if max_length <= 0 or current[-1] not in self.transitions:
      return current
    next_word = random.choice(self.transitions[current[-1]])
    return self.generate_tweet(max_length - 1, current + [next_word])

username = sys.argv[1]
max_length = int(sys.argv[2])
num_tweets = int(sys.argv[3])
tweets = tweets_for_user(username, num_tweets)
chain = MarkovChain(to_markov_data(tweets))
tweet = chain.generate_tweet(max_length)
print(' '.join(tweet))