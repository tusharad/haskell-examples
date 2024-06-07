module Main where

getBinary_ :: Int -> String -> String
getBinary_ 0 res = show res
getBinary_ n res = getBinary_ (n `div` 2) (res ++ show (n `mod` 2))

getBinary :: Int -> String
getBinary n = getBinary_ n ""

binaryToInt_ :: String -> Int -> Int
binaryToInt_ "" n = n
binaryToInt_ (x:xs) n 
  | x == '1' = binaryToInt_ xs (n + 2 ^ ((length xs) -1))
  | otherwise = binaryToInt_ xs n

binaryToInt :: String -> Int
binaryToInt str = binaryToInt_ str 0 

solve :: Int -> IO ()
solve n = do
  let binary = getBinary n
  print $ binaryToInt $ "001"

main = do
  n_ <- getLine
  let n = read n_ :: Int
  solve n
