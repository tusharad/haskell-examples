module Main where
import System.IO.Unsafe

solve :: [Int] -> [Int] -> IO ()
solve (n:k:xs) scores = do
  let avg = fromIntegral (sum scores) / fromIntegral (length scores)
  let maxi = fromIntegral (sum scores + (n-k)*3) / fromIntegral (length scores + (n-k))
  let mini = fromIntegral (sum scores + (n-k)*(-3)) / fromIntegral (length scores + (n-k))
  putStrLn $ show mini ++ " " ++ show maxi


-- Read numbers from stdin until n and return Integer IO
readNumbers :: Int -> [Int] -> IO [Int]
readNumbers 0 res = return (res)
readNumbers t res = do
  num_ <- getLine
  let num = read num_ :: Int
  readNumbers (t-1) (res ++ [num])

main = do
  n_ <- getLine
  let n = map (read :: String -> Int) $ words n_
  let scores = unsafePerformIO $ readNumbers (n !! 1) [] 
  solve n scores
