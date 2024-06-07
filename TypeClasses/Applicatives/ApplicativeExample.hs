module Main where
import Control.Applicative

{-
fmap penatrates the structure (such as a Maybe) and applies our function to the value inside that structure and returns the result with the value inside it.
applicative on the other hand...helps fmap taking structures as argument.

applicative typeclass helps you to use functions which are inside the context such as maybe or IO

```
Applicatives are monoidal functors
```

ghci> (/2) <$> (Just 5)
Just 2.5
ghci> (/) <$> (Just 5) <*> (Just 2)
Just 2.5

Control.Applicative provides us liftA,liftA2,liftA3.
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

{-
LiftA == fmap
ghci> fmap (+1) (Just 2)
Just 3
ghci> liftA (+1) (Just 2)
Just 3
ghci> let add3 x y z = x+y+z
ghci> liftA3 (add3) (Just 2) (Just 3) (Just 5)
Just 10

ghci> :set -XTypeApplications
ghci> :t (<*>)
(<*>) :: Applicative f => f (a -> b) -> f a -> f b
ghci> :t (<*>) @[]
(<*>) @[] :: [a -> b] -> [a] -> [b]
-}

-- Below is the example to create a Person type which consists of name and address which in itself are types, here we will also have a validateLength
-- Function, which will return a maybe, causing us to use applicative.

validateLength :: Int -> String -> Maybe String
validateLength n str
    | length str < n = Just str
    | otherwise = Nothing

newtype Name = Name String deriving (Show)
newtype Address = Address String deriving (Show)
data Person = Person Name Address deriving (Show)

mkName :: String -> Maybe Name
mkName str = fmap Name $ validateLength 10 str

mkAddress :: String -> Maybe Address
mkAddress str = fmap Address $ validateLength 10 str

mkPerson :: String -> String -> Maybe Person
mkPerson name address = fmap Person (mkName name) <*> (mkAddress address)

{-
ghci> mkPerson "tushar" "pune"
Just (Person (Name "tushar") (Address "pune"))
-}

-- Implementing Cow example from the haskell book.
data Cow = Cow {
      name :: String
    , age :: Int
    , weight :: Int
} deriving (Show)

notEmpty :: String -> Maybe String
notEmpty str = if str == "" then Nothing else Just str
    
nonNegative :: Int -> Maybe Int
nonNegative n = if n < 0 then Nothing else Just n

mkCow :: String -> Int -> Int -> Maybe Cow
mkCow name' age' weight' = liftA3 Cow (notEmpty name') (nonNegative age') (nonNegative weight')

-- Solving Applicative exercise from the haskell book

-- Write Applicative instance of below type constructor
data Pair a = Pair a a deriving (Show,Eq)

-- Before writing applicative construtor, we must write functor constructor for same.
instance Functor Pair where
    fmap f (Pair x y) = Pair (f x) (f y)

instance Applicative Pair where
    pure x = Pair x

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
