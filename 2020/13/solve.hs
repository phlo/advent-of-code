import Data.Bool
import Data.List
import System.Environment

sieve (t, i) (dt, id) = (t', i')
  where
    t' = until (\x -> (x + dt) `mod` id == 0) (+ i) t
    i' = i * id

main = do
  [f] <- getArgs
  raw <- readFile f
  let ls = lines raw
  let xs = map (\x -> bool x (tail x) (head x == ','))
               (groupBy (\_ y -> y /= ',') (ls !! 1))
  -- part 1
  let t = (read (ls !! 0) :: Int)
  print $ foldl (*) 1 (minimum (map (\x -> [x * (t `div` x + 1) - t, x])
                               (map (read :: String -> Int)
                                    (filter (\x -> x /= "x") xs))))
  -- part 2
  let y:ys = (filter (\x -> snd x > 0)
                     (zip [0..length xs]
                          (map (\x -> bool (read x :: Int) 0 (x == "x")) xs)))
  print $ fst (foldl sieve y ys)
