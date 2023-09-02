module Main where
import BinarySearch

main :: IO()
main = do
    let list1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    let elem = 7
    print $ binarySearch list1 elem 