module Main where

data Query = Query
data SomeObj = SomeObj
data IoOnlyObj = IoOnlyObj
data Err = Err

fetchFn :: Query -> IO [String]
fetchFn = undefined

decodeFn :: String -> Either Err SomeObj
decodeFn = undefined

mkSomeObj :: [SomeObj] -> IO [(SomeObj,IoOnlyObj)]
mkSomeObj = undefined

pipelineFn :: Query -> IO (Either Err [(SomeObj,IoOnlyObj)])
pipelineFn query = do
    a <- fetchFn query
    case sequence (map decodeFn a) of
        (Left err) -> return $ Left $ err
        (Right res) -> do
            a <- mkSomeObj res
            return $ Right $ a

pipelineFn_ :: Query -> IO (Either Err [(SomeObj,IoOnlyObj)])
pipelineFn_ query = do
    a <- fetchFn query
    traverse mkSomeObj $ mapM decodeFn a

data Either_ a b = Left_ a | Right_ b deriving (Eq,Show)

instance Functor (Either_ a) where
    fmap _ (Left_ a) = Left_ a
    fmap f (Right_ b) = Right_ (f b)

instance Foldable (Either_ a) where
    foldr _ x (Left_ _) = x
    foldr f x (Right_ y) = f y x
    
    foldMap _ (Left_ x) = mempty
    foldMap f (Right_ x) = f x

instance Applicative (Either_ a) where
    pure = Right_
    Left_ e <*> _ = Left_ e
    Right_ f <*> r = fmap f r

instance Traversable (Either_ a) where
    traverse f (Right_ b) = fmap Right_ (f b)

newtype Identity a = Identity a deriving (Eq,Show,Ord)

instance Functor Identity where
    fmap f (Identity a) = Identity (f a)

instance Foldable Identity where
    foldr f x (Identity y) = f y x

instance Applicative Identity where
    pure a = Identity a
    Identity f <*> r = fmap f r

instance Traversable Identity where
    traverse f (Identity a) = Identity <$> f a

-- Solving Traversable exercise from the haskell book
data Tree a = Nil | Leaf a | Node (Tree a) a (Tree a) deriving (Show,Eq)

instance Functor Tree where
    fmap _ Nil = Nil
    fmap f (Leaf x) = Leaf (f x)
    fmap f (Node x r y) = Node (fmap f x) (f r) (fmap f y)

instance Foldable Tree where
    foldMap _ Nil = mempty
    foldMap f (Leaf x) = f x
    foldMap f (Node left curr right) = (foldMap f left) `mappend` f curr `mappend` (foldMap f left)

instance Traversable Tree where
    traverse _ Nil = pure Nil
    traverse f (Leaf x) = Leaf <$> f x
    traverse f (Node left x right) = Node <$> (traverse f left) <*> (f x) <*> (traverse f right)

main :: IO ()
main = do
    let str = Node Nil 2 Nil
    putStrLn "hello"
