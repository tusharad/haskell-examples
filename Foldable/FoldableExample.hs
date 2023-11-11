module Main where
import Data.Monoid
import Data.Foldable

{-
  Sum and Products are monoids are here. Sum tells us that concatation of list of Ints is the sum of all elements, while Product tells us it's product of them.
 - -}

-- Find if the element exists in the list using foldr
findInList :: [Int] -> Int -> Bool
findInList lst key = foldr (\x -> (|| x == key)) False lst

-- Solving exercise of chapter Foldable from the haskell book
sum_ xs = foldr (+) 0 xs
product_ xs = foldr (*) 1 xs
minimum_ ele xs = foldr min (head xs) xs
maximum_ ele xs = foldr max (head xs) xs
length_ xs = foldr (\_ -> (+1)) 0 xs
null xs = undefined -- yet to defined

-- writing foldable instances of following types
data Constant a b = Constant b

instance Foldable (Constant a) where
    foldr f x (Constant y) = f y x
    foldl f x (Constant y) = f x y
    foldMap f (Constant y) = f y

data Two a b = Two a b deriving (Show)
instance Foldable (Two a) where
    foldr f x (Two a b) = (f b x)
    foldl f x (Two a b) = f x b

main :: IO ()
main = do
  let xs = map Sum [1,2,3,4,5]
  print $ fold xs                 -- Fold will be applied to [Sum {getSum = 1},Sum {getSum = 2},Sum {getSum = 3},Sum {getSum = 4},Sum {getSum = 5}]
  print $ foldMap Sum [1,2,3,4,5] -- FoldMap will map the Function `Sum` first, then it will fold and will give us the result, while in fold , we had to
                                  -- map the function into list first, then perform fold.
  print $ foldMap Product [1,2,3,4,5]
  print $ foldMap Any [True,False,False]
  print $ foldMap All [True,False,False]
