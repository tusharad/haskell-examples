module Main where
import System.IO.Unsafe

diagonalDifference_ :: [[Int]] -> Int -> Int -> Int -> IO Int
diagonalDifference_ arr lsum rsum i 
    | i == length arr = return (abs (lsum-rsum))
    | otherwise = do
    let lElem = (arr !! i) !! i
    let rElem = (arr !! i) !! (length arr - i - 1)
    print $ show lElem ++ " " ++ show rElem
    diagonalDifference_ arr (lsum + lElem) (rsum + rElem) (i+1)

diagonalDifference arr = do
    diagonalDifference_ arr 0 0 0

main = do
    let arr = [[11,2,4],[4,5,6],[10,8,-12]]
    print $ unsafePerformIO $ diagonalDifference arr
