import Data.List
import System.Environment

dist (_, (x, y)) = (abs x) + (abs y)

nav1 ('N', a) (h, (x, y)) = (h, (x, y + a))
nav1 ('S', a) (h, (x, y)) = (h, (x, y - a))
nav1 ('E', a) (h, (x, y)) = (h, (x + a, y))
nav1 ('W', a) (h, (x, y)) = (h, (x - a, y))
nav1 ('L', a) (h, s) = ((h - a) `mod` 360, s)
nav1 ('R', a) (h, s) = ((h + a) `mod` 360, s)
nav1 ('F', a) (h, s)
  | h == 0   = nav1 ('N', a) (h, s)
  | h == 90  = nav1 ('E', a) (h, s)
  | h == 180 = nav1 ('S', a) (h, s)
  | h == 270 = nav1 ('W', a) (h, s)

rot r (x, y)
  | r == 90  = (y, -x)
  | r == 180 = (-x, -y)
  | r == 270 = (-y, x)

nav2 ('N', a) ((x, y), s) = ((x, y + a), s)
nav2 ('S', a) ((x, y), s) = ((x, y - a), s)
nav2 ('E', a) ((x, y), s) = ((x + a, y), s)
nav2 ('W', a) ((x, y), s) = ((x - a, y), s)
nav2 ('L', a) (w, s) = (rot (360 - a) w, s)
nav2 ('R', a) (w, s) = (rot a w, s)
nav2 ('F', a) ((wx, wy), (sx, sy)) = ((wx, wy), (sx + a * wx, sy + a * wy))

main = do
  [f] <- getArgs
  raw <- readFile f
  let xs = (map (\x -> (head x, (read :: String -> Int) (tail x))) (lines raw))
  -- part 1
  print $ dist (foldl (\x a -> nav1 a x) (90, (0, 0)) xs)
  -- part 2
  print $ dist (foldl (\x a -> nav2 a x) ((10, 1), (0, 0)) xs)
