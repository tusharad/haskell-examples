module Main where
import Data.Monoid
import Data.Foldable

{-
  Sum and Products are monoids are here. Sum tells us that concatation of list of Ints is the sum of all elements, while Product tells us it's product of them.
 - -}

main :: IO ()
main = do
  let xs = map Sum [1,2,3,4,5]
  print $ fold xs                 -- Fold will be applied to [Sum {getSum = 1},Sum {getSum = 2},Sum {getSum = 3},Sum {getSum = 4},Sum {getSum = 5}]
  print $ foldMap Sum [1,2,3,4,5] -- FoldMap will map the Function `Sum` first, then it will fold and will give us the result, while in fold , we had to
                                  -- map the function into list first, then perform fold.
  print $ foldMap Product [1,2,3,4,5]
  print $ foldMap Any [True,False,False]
  print $ foldMap All [True,False,False]
