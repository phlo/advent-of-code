import Data.Bool
import Data.List
import Data.Map (Map)
import qualified Data.Map as Map
import System.Environment

speak turn prev map max
  | turn == max = prev
  | otherwise = speak (turn + 1) cur map' max
  where
    map' = Map.insert prev turn map
    cur = case Map.lookup prev map of Just last -> turn - last
                                      Nothing -> 0

main = do
  [f] <- getArgs
  raw <- readFile f
  let xs = map (read :: String -> Int)
               (map (\x -> bool x (tail x) (head x == ','))
                    (groupBy (\_ y -> y /= ',') raw))
  let turn = length xs
  let prev = last xs
  let map = Map.fromList (zip xs [1..turn])
  -- part 1
  print $ speak turn prev map 2020
  -- part 2
  print $ speak turn prev map 30000000
