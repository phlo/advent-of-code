import Data.List
import Data.Map (Map)
import qualified Data.Map as Map
import System.Environment

split delim (c:cs)
  | null cs = [[c]]
  | c == delim = "" : cs'
  | otherwise = (c:head cs'):tail cs'
  where cs' = split delim cs

parseInt = read :: String -> Int

parseTicket l = map parseInt (split ',' l)

parseNearby [] = []
parseNearby (l:ls) = [parseTicket l] ++ (parseNearby ls)

parseMine (l:ls) = (parseTicket l, parseNearby (tail (tail ls)))

parseField check ("":ls) = (check, parseMine (tail ls))
parseField check (l:ls) = parseField check' ls
  where
    Just c = elemIndex ':' l
    ranges = (filter (\x -> x /= "or") (words (drop (c + 2) l)))
    [[ll, lr], [rl, rr]] = map (\x -> map parseInt (split '-' x)) ranges
    valid x = (x >= ll && x <= lr) || (x >= rl && x <= rr)
    check' = Map.insert (take c l) valid check

parse ls = parseField Map.empty ls

clean known [] = []
clean known (x:xs)
  | x == [known] = x:xs'
  | otherwise = (filter (/= known) x):xs'
  where xs' = clean known xs

solve xs
  | all single xs = xs
  | otherwise = solve xs'
  where
    single = (== 1) . length
    known = filter single xs
    xs' = foldl (\f [k] -> clean k f) xs known

main = do
  [f] <- getArgs
  raw <- readFile f
  -- part 1
  let (check, (mine, nearby)) = parse (lines raw)
  print $ sum (filter (\x -> and (map (\y -> not (y x))
                                      (Map.elems check)))
                      (concat nearby))
  -- part 2
  let valid = filter (\xs -> and (map (\y -> or (map (\z -> z y)
                                                     (Map.elems check)))
                                      xs))
                     nearby
  let candidates = map (\(x:xs) -> foldl intersect x xs)
                       (map (\xs -> map (\y -> filter (\z -> (check Map.! z) y)
                                                      (Map.keys check))
                                        xs)
                            (transpose valid))
  print $ product (map snd (filter (\(f, _) -> "departure" `isPrefixOf` f)
                                   (zip (concat (solve candidates)) mine)))
