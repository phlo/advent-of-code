import Data.List
import System.Environment

combinations 0 _  = [[]]
combinations k xs = [ y:ys | y:xs' <- tails xs
                           , ys <- combinations (k - 1) xs' ]

findInvalid (_, []) = error "no more numbers"
findInvalid (xs, y:ys)
  | elem y (map sum (combinations 2 xs)) = findInvalid (tail xs ++ [y], ys)
  | otherwise = y

findWeakness n (_, []) = error "no more numbers"
findWeakness n (x0:x1:xs, y:ys)
  | s == n = minimum xs' + maximum xs'
  | s > n = findWeakness n ([x1, head xs], tail xs ++ y:ys)
  | otherwise = findWeakness n (xs' ++ [y], ys)
  where
    xs' = x0:x1:xs
    s = sum xs'

main = do
  [n, f] <- getArgs
  raw <- readFile f
  let numbers = map (read :: String -> Int) (lines raw)
  -- part 1
  let invalid = findInvalid (splitAt (read n) numbers)
  print invalid
  -- part 2
  let weakness = findWeakness invalid (splitAt 2 numbers)
  print weakness
