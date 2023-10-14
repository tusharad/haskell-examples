module Main where

{-

fmap penatrates the structure (such as a Maybe) and applies our function to the value inside that structure and returns the result with the value inside it.

applicative on the other hand...helps fmap taking structures as argument.

-}

main :: IO ()
main = do
    print $ (+2) <$> (Just 1)
    print $ (+) <$> (Just 1) (Just 2)

