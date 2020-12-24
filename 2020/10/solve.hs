import Data.List
import System.Environment

arrangements (3:_) = 0
arrangements [1] = 0
arrangements [1, 1] = 1
arrangements [1, 1, 1] = 3
arrangements (1:1:xs) = 3 + arrangements (1:xs)

main = do
  [f] <- getArgs
  raw <- readFile f
  let adapters = (sort (map (read :: String -> Int) (lines raw)))
  let differences = map (\x -> fst x + snd x)
                        (zip (adapters ++ [last adapters + 3])
                             (map (* (-1)) (0:adapters)))
  -- part 1
  print $ foldl (*) 1 (map length (group (sort differences)))
  -- part 2
  print $ foldl (\x ys -> x + x * arrangements ys) 1 (group (differences))
