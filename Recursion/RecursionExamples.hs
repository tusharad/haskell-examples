module Main where
import Data.Int

binarySearch_ :: [Int32] -> Int32 -> Int -> Int -> Maybe Int
binarySearch_ list1 elem low high
    | low >= high = Nothing
    | (list1 !! mid) < elem = binarySearch_ list1 elem (mid+1) high
    | (list1 !! mid) > elem = binarySearch_ list1 elem low (mid-1)
    | otherwise = Just mid
    where 
        mid = low + ((high-low) `div` 2)

binarySearch :: [Int32] -> Int32 -> Maybe Int
binarySearch list1 elem = binarySearch_ list1 elem 0 (length list1)

main :: IO ()
main = do
    putStrLn "hello"
    let list1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    let elem = 7
    print $ binarySearch list1 elem 
