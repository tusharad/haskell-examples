module Main where

solve :: [Int] -> IO ()
solve (x:y:_)
  | x < y = putStrLn $ show x ++ " " ++show y
  | otherwise = putStrLn $ show y ++ " " ++show x 

main :: IO ()
main = do
  nums_ <- getLine
  let nums = map read (words nums_)
  solve nums
