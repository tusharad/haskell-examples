{- cabal:
    build-depends: base
                   ,containers
                   ,bytestring
-}
module Main where
import qualified Data.Map as Map
import qualified Data.Set as Set
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as Char8

import Text.Printf 

data SSN = SSN {
    ssnPrefix :: Int,
    ssnInfix :: Int,
    ssSuffix :: Int
} deriving (Ord,Eq)

instance Show SSN where
    show (SSN pr inf suf) = printf "%d-%d-%d" pr inf suf

data Gender = Male | Female deriving (Eq,Show)

data Person = Person {
    firstName :: String,
    lastName :: String,
    gender :: Gender
} deriving (Eq)

instance Show Person where
    show (Person fname lname gen) = printf "%s %s Gender: %s" fname lname (show gen)

type Employees = Map.Map SSN Person

mkSSN :: Int -> Int -> Int -> SSN
mkSSN p i s
    | p <= 0 || p == 666 || p >= 900 = error $ "invalid SSN prefix " ++ (show p)
    | i <= 0 || i > 99 = error $ "invalid SSN infix " ++ (show i)
    | s <= 0 || s > 999 = error $ "invalid SSN suffix " ++ (show s)
    | otherwise = SSN p i s

getEmployees :: Employees
getEmployees = Map.fromList [
        (mkSSN 11 2 3,Person "Tushar" "Adhatrao" Male),
        (mkSSN 11 2 4,Person "Paras" "Adhatrao" Male),
        (mkSSN 11 2 5,Person "Shweta" "Adhatrao" Female)
    ]

lookupEmployee :: SSN -> Employees -> Maybe Person
lookupEmployee = Map.lookup

main :: IO ()
main = do
    putStrLn "asa"
