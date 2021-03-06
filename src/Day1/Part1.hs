module Day1.Part1 where

removePlus :: String -> String
removePlus = filter (/= '+')

solve :: String -> Int
solve = sum . map ((read :: String -> Int) . removePlus) . lines

main :: IO ()
main = do
  text <- readFile "src/Day1/input.txt"
  putStrLn $ show $ solve text
