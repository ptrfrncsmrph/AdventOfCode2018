{-# LANGUAGE TupleSections #-}

module Day9.Part2 where

import           Control.Arrow
import           Data.Map      (Map)
import qualified Data.Map      as M
import           Data.Sequence (Seq)
import qualified Data.Sequence as S
import           Debug.Trace

type Player = Int

type Marble = Int

parse :: String -> (Player, Marble)
parse = select . words
  where
    select (x:"players;":"last":"marble":"is":"worth":y:_) = (read x, read y)

solve :: (Player, Marble) -> Int
solve = maximum . map snd . M.toList . play

play :: (Player, Marble) -> Map Player Int
play (p, m) = go (M.fromList $ map (, 0) [1 .. p]) 3 3 (S.fromList [0, 2, 1]) 1
  where
    go gameState currPlayer currMarble boardState lastInsertIndex
      {- `gameState` is `Map Player Int` -- a map from player number (1-index) to score,
         `boardState` is a `Seq Int` that I need to insert a new marble into,
         that marble will be inserted based on the `lastInsertIndex` and the S.length
         of my `boardState`,  -}
      | currMarble == m + 1 = gameState
      | currMarble `mod` 23 == 0 =
        go
          (M.adjust (+ (boardState `S.index` ix')) currPlayer $
           (M.adjust (+ currMarble) currPlayer) gameState)
          ((currMarble - 1) `mod` p + 1)
          (currMarble + 1)
          (S.deleteAt ix' boardState)
          ix'
      | otherwise =
        go
          gameState
          ((currMarble - 1) `mod` p + 1)
          (currMarble + 1)
          (S.insertAt ix currMarble boardState)
          ix
      where
        ix = (lastInsertIndex + 2) `mod` (S.length boardState)
        ix' = (lastInsertIndex - 7) `mod` (S.length boardState)

main :: IO ()
main = do
  text <- readFile "src/Day9/input.txt"
  putStrLn $ show $ solve (405, 7095300)
