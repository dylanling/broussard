module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick, onInput )
import Http exposing (..)
import Time exposing (..)
import Random exposing (..)
import Task exposing ( perform )
import Json.Decode as Decode
import Markov exposing (..)

main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

backend : String
backend = "http://localhost:5000/"

httpTimeout : Maybe Time
httpTimeout = Nothing

-- MODEL
type alias Model = 
  { screenName : String
  , sampleSize : Int
  , generationLength : Int
  , tweets : List String
  , display : String
  }

model : Model
model = 
  { screenName = ""
  , sampleSize = 200
  , generationLength = 30
  , tweets = []
  , display = ""
  }

init : (Model, Cmd Msg)
init = (model, Cmd.none)

-- UPDATE
type Msg = 
  Change String 
  | Apply 
  | GotTweets (Result Http.Error (List String)) 
  | GotTime Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Change inputText ->
      ( { model | screenName = inputText }, Cmd.none )
    Apply ->
      ( model, Http.send GotTweets (getTweets model) )
    GotTweets result ->
      case result of
        Err httpError ->
          ( { model | tweets = [], display = "Error fetching tweets! Message: " ++ (toString httpError) }, Cmd.none )
        Ok response ->
          ( { model | tweets = response }, getTime )
    GotTime time ->
      ( { model | display = generateTweet model (getSeed time) }, Cmd.none )

twitterApiQuery : Model -> String
twitterApiQuery model =
  backend
  ++ "tweets?username=" 
  ++ (.screenName model) 
  ++ "&count=" 
  ++ (toString (.sampleSize model))

getTweets : Model -> Http.Request (List String)
getTweets model =
  Http.request 
  { method = "GET"
  , headers = [ ]
  , url = twitterApiQuery model
  , body = Http.emptyBody
  , expect = expectJson (Decode.list Decode.string)
  , timeout = httpTimeout
  , withCredentials = False
  }

getTime : Cmd Msg
getTime =
  Time.now |> perform GotTime

getSeed :
  Time
  -> Random.Seed
getSeed time =
  Random.initialSeed (round (Time.inMilliseconds time))

generateTweet : 
  Model
  -> Random.Seed
  -> String
generateTweet model seed =
  Markov.generate (toMarkovChain (.tweets model)) (.generationLength model) seed
    |> String.join " "

toMarkovChain :
  List String
  -> MarkovChain String
toMarkovChain strings =
  markovChain (strings |> List.map (String.split " "))

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [class "column"]
        [ input [ class "input is-success", placeholder "twitter username", onInput Change] [] ]
    , div [class "column"]
        [ div [class "text-big"] [ button [onClick Apply] [text "Generate a tweet!"] ] ]
    , div [] [ text (.display model) ]
    ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
