module Main (main) where
import Arrays.TwoSum
import qualified Data.Vector.Unboxed as V
import Arrays.GenerateParanthesis (generateParanthesis)

main :: IO ()
main = do
    print $ generateParanthesis 3
    --print $ twoSum (V.fromList [2,7,11,5]) 9
    --print $ twoSum (V.fromList [3,2,4]) 6
