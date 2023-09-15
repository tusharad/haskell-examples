{- cabal:
  build-depends: base,hspec,QuickCheck
-}
module Main where
import Test.Hspec
import Test.QuickCheck

sayHello :: IO()
sayHello = putStrLn "hello!"

binarySearch_ :: [Int] -> Int -> Int -> Int -> Maybe Int
binarySearch_ lst key low high
  | low > high = Nothing
  | (lst !! mid) < key = binarySearch_ lst key (mid+1) high
  | (lst !! mid) > key = binarySearch_ lst key low (mid-1)
  | otherwise = Just mid
  where
    mid = (low+high) `div` 2

binarySearch :: [Int] -> Int -> Maybe Int
binarySearch lst key = binarySearch_ lst key 0 (length lst - 1)

prop_additionGreater :: Int -> Bool
prop_additionGreater x = x+1 > x

runQc :: IO ()
runQc = quickCheck prop_additionGreater

main = do
  putStrLn "nice to meet you"
  hspec $ do
    describe "Addition" $ do
      it "1+1 is greater than 1" $ do
       (1+1) > 1 `shouldBe` True
      it "2+2 is equal to 4" $ do
       (2+2) `shouldBe` 4
      it "binarySearch returned index's value should be equal to the key" $ do
        let lst = [1,2,3,4,5,6,7]
        let key = 7
        let ans = (binarySearch lst key) 
        case ans of
          Just x -> (lst !! x) `shouldBe` key 
      it "x+1 is always\
          \ greater than x" $ do
        property $ \x -> (x+1) > (x :: Int)
  runQc
