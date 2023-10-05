module Arrays.TwoSum where
import qualified Data.Vector.Unboxed as V

findPair :: V.Vector Int -> Int -> Int -> Int -> Maybe Int
findPair nums target i j
    | V.length nums == j = Nothing
    | nums V.! i + nums V.! j == target = Just j
    | otherwise = findPair nums target i (j+1)

twoSum_ :: V.Vector Int -> Int -> Int -> V.Vector Int
twoSum_ nums target i
    | V.length nums == i = V.fromList []
    | otherwise = 
        case findPair nums target i (i+1) of
        Just j -> V.fromList [i,j]
        Nothing -> twoSum_ nums target (i+1)

twoSum :: V.Vector Int -> Int -> V.Vector Int
twoSum nums target = twoSum_ nums target 0