```haskell
ghci> :set -XTypeApplications
ghci> :t (<*>)
(<*>) :: Applicative f => f (a -> b) -> f a -> f b
ghci> :t (<*>) @[]
(<*>) @[] :: [a -> b] -> [a] -> [b]
```
