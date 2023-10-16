module Main where

{-
fmap penatrates the structure (such as a Maybe) and applies our function to the value inside that structure and returns the result with the value inside it.
applicative on the other hand...helps fmap taking structures as argument.

applicative typeclass helps you to use functions which are inside the context such as maybe or IO

ghci> (/2) <$> (Just 5)
Just 2.5
ghci> (/) <$> (Just 5) <*> (Just 2)
Just 2.5
-}

minOfThree :: (Ord a) => a -> a -> a -> a
minOfThree x y z = min x (min y z)

readInt :: IO (Int)
readInt = do
    n <- getLine
    let n' = read n :: Int
    return (n')

minOfInts :: IO (Int)
minOfInts = (minOfThree) <$> readInt <*> readInt <*> readInt

{-
pure is the second function in the applicative typeclass. It is a function which takes a value and put it in a context such as Maybe or IO.
-}

main :: IO ()
main = do
    num <- minOfInts
    print num
    print $ (+2) <$> (Just 1)
    print $ (+) <$> (Just 1) <*> (Just 2)                       -- applicative chains the first argument
    print $ (++) <$> (Just "Tushar") <*> (Just " Adhatrao")
    -- (++) <$> (Just "Tusahr") <*> (Just "Adhatrao") -> (++" Adhatrao") <$> Just "Tushar" -> Just ("Tushar" ++ " Adhatrao")
    print $ pure (+1) <*> (Just 5)  -- you can use pure instead of fmap
    print $ pure (+) <*> [1,2,3] <*> [50,60]
    print $ (,,) <$> Just 1 <*> Just 2 <*> Just 3 -- Just (1,2,3)

