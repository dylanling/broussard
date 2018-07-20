module Markov exposing ( MarkovChain, markovChain, mergeChains, generate )

import Dict
import List.Nonempty
import Random

type alias MarkovChain comparable = 
  { startingValues : List comparable
  , transitions : (Dict.Dict comparable (List comparable))
  }

markovChain :
  List (List comparable)
  -> MarkovChain comparable
markovChain lists =
  let 
    heads = lists
      |> List.filterMap List.head
    transitions = lists
      |> List.map toTransitions
      |> List.foldl (\a b -> mergeTransitions a b) Dict.empty
  in
    { startingValues = heads
    , transitions = transitions
    }

mergeChains : 
  MarkovChain comparable 
  -> MarkovChain comparable 
  -> MarkovChain comparable
mergeChains a b =
  { startingValues = (.startingValues a) ++ (.startingValues b)
  , transitions = mergeTransitions (.transitions a) (.transitions b)
  }

generate :
  MarkovChain comparable
  -> Int
  -> Random.Seed
  -> List comparable
generate chain len seed =
  List.reverse (generateReversed chain seed [] len)

mergeTransitions :
  Dict.Dict comparable (List comparable)
  -> Dict.Dict comparable (List comparable)
  -> Dict.Dict comparable (List comparable)
mergeTransitions lhs rhs =
  Dict.merge Dict.insert (\key a b -> Dict.insert key (a ++ b)) Dict.insert lhs rhs Dict.empty

toTransitions :
  List comparable
  -> Dict.Dict comparable (List comparable)
toTransitions list = 
  List.map2 (,) list (Maybe.withDefault [] (List.tail list))
    |> List.foldl
      (\(parent, child) children ->
        Dict.update
          parent
          (\value ->
            case value of
              Just value -> Just (value ++ [child])
              Nothing -> Just [child])
          children
      )
      Dict.empty

join : -- how does elm core maybe not have this?!
  Maybe (Maybe a) 
  -> Maybe a
join mm = case mm of
  Just m ->
    m
  Nothing ->
    Nothing

selectRandomFrom :
  Random.Seed
  -> List comparable
  -> (Maybe comparable, Random.Seed)
selectRandomFrom seed list =
  case List.Nonempty.fromList list of
    Just nonempty ->
     Random.step (List.Nonempty.sample nonempty) seed
      |> Tuple.mapFirst Just
    Nothing ->
      (Nothing, seed)

nextState :
  MarkovChain comparable
  -> Random.Seed
  -> comparable
  -> (Maybe comparable, Random.Seed)
nextState chain seed initial =
  case (Dict.get initial (.transitions chain)) of
    Just transitions ->
      selectRandomFrom seed transitions
    Nothing ->
      (Nothing, seed)
   

generateReversed : 
  MarkovChain comparable 
  -> Random.Seed
  -> List comparable
  -> Int
  -> List comparable
generateReversed chain seed current len =
  let 
    (next, newSeed) = case List.head current of 
      Just state ->
        case (nextState chain seed state) of
          (Just state, rseed) ->
            (List.singleton state, rseed)
          (Nothing, rseed) ->
            ([], rseed)
      Nothing ->
        case (selectRandomFrom seed (.startingValues chain)) of
          (Just first, rseed) ->
            (List.singleton first, rseed)
          (Nothing, rseed) ->
            ([], rseed)
  in 
    if len > 0 then
      generateReversed chain newSeed (next ++ current) ( len - 1 )
    else
      current