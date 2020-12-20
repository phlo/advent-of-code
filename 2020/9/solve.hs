import Data.List
import System.Environment
-- import Debug.Trace

combinations 0 _  = [ [] ]
combinations k xs = [ y:ys | y:xs' <- tails xs
                           , ys <- combinations (k - 1) xs' ]

-- findInvalid xs | trace ("findInvalid " ++ show xs) False = undefined
findInvalid ([], _) = error "empty preamble"
findInvalid (_, []) = error "no more numbers"
findInvalid (xs, (y:ys))
  | elem y (map sum (combinations 2 xs)) = findInvalid (tail xs ++ [y], ys)
  | otherwise = y

main = do
  [preamble, file] <- getArgs
  content <- readFile file
  let numbers = map (read :: String -> Int) (lines content)
  -- part 1
  let invalid = findInvalid (splitAt (read preamble) numbers)
  print $ invalid
