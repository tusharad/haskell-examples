module Main where

helper :: Int -> Int -> [Int] -> String
helper _ _ [] = "No"
helper leftSum rightSum (x:xs) 
    | leftSum == (rightSum-x) = "Yes"
    | otherwise = helper (leftSum+x) (rightSum-x) xs 
    
balancedSums :: [Int] -> String
balancedSums arr = helper 0 (sum arr) arr

doubleAll :: [Int] -> [Int]
doubleAll [] = []
doubleAll (x:xs) = (x+x) : doubleAll xs 

squareAll :: [Int] -> [Int]
squareAll list1 = map (\x -> x*x) list1

main :: IO ()
main = do
  print $ sum [1,2,3]         -- sum of a list
  print $ head [1,2,3]        -- get the first element of the list
  print $ tail [1,2,3]        -- get the list without the first element
  print $ 5 : [1,2,3]         -- create a new list, in which 5 is added in the front of the list
  print $ [5] ++ [1,2,3]      -- concate two lists
  print $ [1,2,3] ++ [5]      -- concate two lists
  print $ [1,2,3] ++ [4,5,6]  -- concate two lists
  print $ doubleAll [1,2,3,4] -- double each element in the list by using recursion and pattern matching
  print $ squareAll [1,2,3,4] -- square each element in the list by using map
  putStrLn $ balancedSums [5,6,8,11] -- print yes if find an element of the array such that the sum of all elements to the left is equal to the sum of all elements to the right
