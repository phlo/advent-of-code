import qualified Data.Text as T
import Data.List
import System.Environment

main = do
  [f] <- getArgs
  raw <- readFile f
  let ls = lines raw
  let t = (read :: String -> Int) (ls !! 0)
  let xs = map (read :: String -> Int)
               (filter (\x -> x /= "x")
                       (map (\x -> T.unpack x)
                            (T.splitOn (T.pack ",") (T.pack (ls !! 1)))))
  print $ foldl (*) 1 (minimum (map (\x -> [x * (t `div` x + 1) - t, x]) xs))
