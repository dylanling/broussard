# broussard

## Requirements

  * Elm >= 0.18
  * Node >= 5
  * Python >= 2.7

## Running Locally

If you don't have one, [register an app for the Twitter API](https://apps.twitter.com/).


Clone the repository:

```
❯ git clone https://github.com/dylanling/broussard
```

Install all packages:

```
❯ npm install
❯ pip install -r requirements.txt
```

Export the following variables:

```
❯ export FLASK_APP=server/app.py
❯ export FLASK_DEBUG=1
❯ export TWITTER_CONSUMER_KEY=<twitter api consumer key>
❯ export TWITTER_CONSUMER_SECRET=<twitter api consumer secret>
❯ export TWITTER_ACCESS_TOKEN_KEY=<twitter api access token key>
❯ export TWITTER_ACCESS_TOKEN_SECRET=<twitter api access token secret>
```

Now, start the server:

```
❯ flask run
```

Run `brunch` in development mode:

```
❯ npm run dev
```

Open your browser and visit `http://localhost:5000`.

## Boilerplate

:heart: https://github.com/hypebeast/flask-elm-starter-kit