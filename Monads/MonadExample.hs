module Main where
import qualified Data.Map as Map

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

main :: IO ()
main = do
    print $ creditsFromId 2
    echo
    readInt >>= print
    askForName
