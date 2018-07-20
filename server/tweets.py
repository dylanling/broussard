import os
import twitter

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