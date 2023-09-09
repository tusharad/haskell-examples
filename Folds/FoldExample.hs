module Main where

main = do
  print $ foldr (++) "" ["Hello"," Haskell"]
  print $ foldr (+) 0 [1,2,3,4]
