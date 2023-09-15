module Main where

sumOfDigits :: Int -> Int
sumOfDigits 0 = 0
sumOfDigits x = x `mod` 10 + sumOfDigits (x `div` 10)

findDigit :: [Int] -> Int -> Int
findDigit [] _ = -1 
findDigit (y:ys) x 
  | sumOfDigits y == x = y
  | otherwise = findDigit ys x

solve :: Int -> Int -> Int -> IO ()
solve l d x = do
  let first = findDigit [l..d] x 
  let second = findDigit (reverse [l..d]) x 
  print first
  print second

main = do
  l_ <- getLine
  let l = read l_ :: Int
  d_ <- getLine
  let d = read d_ :: Int
  x_ <- getLine
  let x = read x_ :: Int
  solve l d x
