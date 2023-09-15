module Main where

solve :: Int -> Int -> [Int] -> [Int] -> [Double]
solve l r a b = do
    let first =  sum [x*(fromIntegral a)^y :: Double | (x,y) <- zip l r]
    let second = sum [x*(fromIntegral b)^y :: Double | (x,y) <- zip l r]
    [first,second]

main  = do
  print $ solve 
