-- using if else
isEven :: Int -> IO ()
isEven n = if even n then putStrLn "even" else putStrLn "odd"

isEven2 :: Int -> IO ()
isEven2 n 
  | even n = putStrLn "even"
  | otherwise = putStrLn "odd"

main :: IO ()
main = do
  isEven 2
  isEven2 5

