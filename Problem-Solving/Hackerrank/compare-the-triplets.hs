--
-- Complete the 'compareTriplets' function below.
--
-- The function is expected to return an INTEGER_ARRAY.
-- The function accepts following parameters:
--  1. INTEGER_ARRAY a
--  2. INTEGER_ARRAY b
--
compareTriplets_ :: [Int] -> [Int] -> [Int] -> [Int]
compareTriplets_ [] _ res = res
compareTriplets_ (x:xs) (y:ys) (alice:bob:[])
    | x > y = compareTriplets_ xs ys (alice+1:bob:[])
    | x < y = compareTriplets_ xs ys (alice:bob+1:[])
    | otherwise = compareTriplets_ xs ys (alice:bob:[])

compareTriplets a b = do
    compareTriplets_ a b [0,0] 
