module Main where
import System.IO.Unsafe

solve_ :: String -> [Int] -> String -> String
solve_ str [] res = res
solve_ str (x:xs) res = solve_ str xs (res ++ [str !! (x-1)])

solve :: String -> [Int] -> String
solve str nums = solve_ str nums ""

stringToInt_ :: String -> Int -> Int
stringToInt_ "" res = res
stringToInt_ (x:xs) res = stringToInt_ xs (res + 10^(length xs) * read [x])

stringToInt :: String -> Int
stringToInt str = stringToInt_ str 0

decodeNums_ :: String -> [Int] -> [Int]
decodeNums_ "" res = res
decodeNums_ str res = do
  let numStr = take 3 str
  let num = stringToInt numStr
  decodeNums_ (drop 3 str) (res ++ [num])

decodeNums :: String -> [Int]
decodeNums str = decodeNums_ str []

main = do
  str <- getLine
  nums_ <- getLine
  let nums = decodeNums nums_
  putStrLn $ solve str nums
  
