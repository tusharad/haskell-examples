module Main where

import qualified Data.Map as Map
import Control.Monad (join)

type Username = String
type GamerId = Int
type PlayerCredits = Int

userNameDB :: Map.Map GamerId Username
userNameDB = Map.fromList [(1,"tushar"),(2,"nehal")]

creditsDB :: Map.Map Username PlayerCredits
creditsDB = Map.fromList [("tushar",234),("nehal",453)]

lookupUsername :: GamerId -> Maybe Username
lookupUsername gamerId = Map.lookup gamerId userNameDB

lookupCredits :: Username -> Maybe PlayerCredits
lookupCredits username = Map.lookup username creditsDB

creditsFromId :: GamerId -> Maybe PlayerCredits
creditsFromId gamerId = lookupUsername gamerId >>= lookupCredits

{- Implementation of unix's echo command in haskell -}
echo :: IO ()
echo = putStrLn "Enter something, I will echo it" >>
        getLine >>= putStrLn

readInt :: IO (Int)
readInt = read <$> getLine 

{-
(>>=) this is called a bind operator which chains together functions by their outputs.
(>>) is called the sequence operator. It executes functions one after another, but this time, it doesn't pass one function to another.
-}

askForName :: IO ()
askForName = putStrLn "What is your name" >>
             getLine >>=
             (\name -> return ("Hello " ++ name)) >>= 
             putStrLn

twiceWhenEven :: [Int] -> [Int]
twiceWhenEven xs = do
    x <- xs
    if even x then [x*x,x*x] else [x*x]

-- the haskell book ex. 18.7
data Nope a = NopeDotJpg
    deriving (Show,Eq)

instance Functor Nope where
    fmap f NopeDotJpg = NopeDotJpg

instance Applicative Nope where
    pure a = NopeDotJpg
    NopeDotJpg <*> NopeDotJpg = NopeDotJpg

instance Monad Nope where
    return = pure
    NopeDotJpg >>= f = NopeDotJpg

data Either_ a b = Left_ a | Right_ b
    deriving (Show,Eq)

instance Functor (Either_ a) where
    fmap f (Right_ x) = Right_ (f x)
    fmap _ (Left_ x) = Left_ x

instance Applicative (Either_ a) where
    pure x = Right_ x
    Left_ f <*> _ = Left_ f
    Right_ f <*> x = fmap f x

instance Monad (Either_ a) where
    return = pure
    Left_ x >>= _ = Left_ x
    Right_ x >>= f = f x

data List a = Nil | Cons a (List a) deriving (Show,Eq)

instance Functor List where
    fmap _ Nil = Nil
    fmap f (Cons a xs)  = Cons (f a) (fmap f xs)

{-
ghci> [(+1)] <*> [1]
[2]
ghci> [(+1),(+2)] <*> [1]
[2,3]
ghci> [(+1),(+2)] <*> [1,2]
[2,3,3,4]
-}
instance Applicative List where
    pure a = Cons a Nil
    _ <*> Nil = Nil
    Cons f fs <*> Cons x xs = Cons (f x) (fs <*> xs)

-- >>= --> [a] -> (a -> [b]) -> [b]
instance Monad List where
    return = pure
    Nil >>= _ = Nil
    Cons x xs >>= f = (f x) `append` (xs >>= f)

append :: List a -> List a -> List a
append xs Nil = xs
append Nil xs = xs
append (Cons x xs) ys = append xs (Cons x ys)

main :: IO ()
main = undefined

{-
main :: IO ()
main = do
    print $ creditsFromId 2
    echo
    readInt >>= print
    askForName
    -- Writing bind operator (>>=) in terms of fmap and join
    print $ (Just 2) >>= (\x -> (Just (x+1)))       -- Just 3
    print $ join $ (\x -> Just (x+1)) <$> (Just 2)  -- Just 3
    -}
