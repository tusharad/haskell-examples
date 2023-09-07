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

printList :: Show a => [a] -> IO ()
printList [] = return ()
printList (x:xs) = do
  print x
  printList xs


{-
This is a standard way of writing helper function (functionName_). Sometimes while using recursion, we often need more arguments;
maybe to store result. We can't expects these arguments to come from end user. Hence, we write helper function to pass extra arguments.
-}
mergeTwoSortedLists_ :: Ord a => [a] -> [a] -> [a] -> [a]
mergeTwoSortedLists_ [] ys res = res ++ ys
mergeTwoSortedLists_ xs [] res = res ++ xs
mergeTwoSortedLists_ (x:xs) (y:ys) res 
  | x < y = mergeTwoSortedLists_ xs (y:ys) (res ++ [x])
  | x > y = mergeTwoSortedLists_ (x:xs) ys (res ++ [y])
  | otherwise = mergeTwoSortedLists_ xs ys (res ++ [x,y])

mergeTwoSortedLists :: Ord a => [a] -> [a] -> [a]
mergeTwoSortedLists xs ys = mergeTwoSortedLists_ xs ys []

main :: IO ()
main = do
  print $ sum [1,2,3]         -- sum of a list
  print $ head [1,2,3]        -- get the first element of the list
  print $ tail [1,2,3]        -- get the list without the first element
  print $ last [1,2,3]        -- get the last element of the list [link](https://stackoverflow.com/questions/7376937/fastest-way-to-get-the-last-element-of-a-list-in-haskell)
  print $ minimum [1,2,3]     -- Get the minimum element of the list
  print $ maximum [1,2,3]     -- Get the maximum element of the list
  print $ 5 : [1,2,3]         -- create a new list, in which 5 is added in the front of the list
  print $ [5] ++ [1,2,3]      -- concate two lists
  print $ [1,2,3] ++ [5]      -- concate two lists
  print $ [1,2,3] ++ [4,5,6]  -- concate two lists
  print $ doubleAll [1,2,3,4] -- double each element in the list by using recursion and pattern matching
  print $ squareAll [1,2,3,4] -- square each element in the list by using map
  putStrLn $ balancedSums [5,6,8,11] -- print yes if find an element of the array such that the sum of all elements to the left is equal to the sum of all elements to the right
  printList [1,2,3,4]         -- haskell function to print each element of the list on new line
  print $ [1,2,3,4] !! 2      -- Get the ith element from haskell list (bang bang sign)
  -- Slicing of list can be done in 2 ways, using take and drop
  print $ take 2 [1,2,3,4]    -- Takes first 2 elements of list
  print $ drop 2 [1,2,3,4]    -- Drop first 2 element and returns remaining list
  -- print $ delete 2 [1,2,2,3,4]  -- Removes the first occurance of the element from the list, part of Data.List
  print $ mergeTwoSortedLists [1,4,6] [2,3,5]
  -- List comprehension 
  print $ [x*x | x <-  [1,2,3]] -- Squaring each element in the list using list comprehension
  print $ [(x,y) | x <-  [1,2,3], y <- [4,5,6]] -- Generate all possible combinations of tuple from 2 lists
  print $ [x | x <-  [1..10], even x] -- Get a list that contains even numbers between 1 to 10
  print $ [(x,y) | x <-  [1..5], y <- [1..5],(x+y) == 4] -- Generate list of tuples where the sum of both numbers is 4
