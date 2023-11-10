-- using if else
isEven :: Int -> IO ()
isEven n = if even n then putStrLn "even" else putStrLn "odd"

isEven2 :: Int -> IO ()
isEven2 n 
  | even n = putStrLn "even"
  | otherwise = putStrLn "odd"

isLeapYear :: Int -> String
isLeapYear year = if year `mod` 400 == 0 then "Yes"
               else if year `mod` 100 == 0 then "No"
                    else if year `mod` 4 == 0 then "Yes"
                         else "No"

isLeapYear2 :: Int -> String
isLeapYear2 year
  | year `mod` 400 == 0 = "Yes"
  | year `mod` 100 == 0 = "No"
  | year `mod` 4 == 0 = "Yes"
  | otherwise = "No"
 
isThere :: (Eq a) => [a] -> a -> Maybe Int
isThere [] _ = Nothing
isThere xs val = isThere_ xs val 0
    where
        isThere_ [] _ _ = Nothing
        isThere_ (x:xs) val n = if x == val then Just n else isThere_ xs val (n+1)

-- Case expression
printDigit :: Int -> IO ()
printDigit n = case n of
  1 -> putStrLn "One"
  2 -> putStrLn "Two"
  3 -> putStrLn "Three"
  4 -> putStrLn "Four"
  5 -> putStrLn "Five"
  6 -> putStrLn "Six"
  7 -> putStrLn "Seven"
  8 -> putStrLn "Eight"
  9 -> putStrLn "Nine"


main :: IO ()
main = do
  -- Using if else
  isEven 2
  -- Guards
  isEven2 5
  -- Nested if else
  putStrLn $ isLeapYear 2004
  -- Nested if else
  putStrLn $ isLeapYear2 2023
  printDigit 2
