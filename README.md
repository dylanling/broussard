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

## Motivation

As incredibly basic as this application is, there are still some confusing design choices, most of which can be explained by the fact that this was first and foremost intended to be a fun way to get started with Elm, which I hadn't had the opportunity to try out before.

In fact, the original implementation of this (without the frontend) was about 50 lines of python as a quick half hour proof of concept. The intention was to just port it all to Elm with a simple boilerplate frontend.

The reason any backend at all is required is that Twitter's API doesn't support CORS (even for a "client-only" app!), and figuring out the correct browser settings for each browser to get around this was way more work than just wiring up Flask and my original python solution using the [python-twitter](https://github.com/bear/python-twitter) library (especially because the Elm/Flask boilerplate I found came with such pretty templates).

## Additional Features that would be pretty easy to implement

- Changing the number of tweets used to generate a chain, as well as the maximum generated tweet length. Both are already part of the Elm model, the only work would just be adding more fields.
- Combining multiple twitter users into a single chain. The only work here is just the additional text fields, combining and composing Markov chains themselves is simple. 
  - In fact, Markov chains as implemented here actually form a monoid under [addition](https://github.com/dylanling/broussard/blob/master/app/elm/Markov.elm#L27). 
  - Beyond addition, Markov chains should be able to support any other set-related binary operation, so long as that operation is defined on a `Dict` and it's values. e.g. if `-` were the set difference operator and `a` and `b` are each an input to a chain (here a set of tweets), then `markov(a) - markov(b)` should be a totally valid chain, and in fact would be the same as `markov(a - b)`.
  - For performance the flask server would probably also expose a way to get multiple users' tweets with a single call.
- Error handling, input validation, etc.
- 

## Boilerplate

:heart: https://github.com/hypebeast/flask-elm-starter-kit