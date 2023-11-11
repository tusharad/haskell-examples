## Traversable

Traversable Typeclass provides us following functions:
- traverse
- sequenceA
- sequence
- mapM

sequenceA is an extremly useful function from Traversable typeclass. If the value is within two structures,
It basically flips these two structures.
```
ghci> :t sequenceA
sequenceA :: (Traversable t, Applicative f) => t (f a) -> f (t a)
ghci> sequenceA (Just [2])
[Just 2]
```

Applicative is the superclass of Traversable. The type signature of traverse is same as filp bind (=<<)
```
ghci> :t traverse @[] @IO
traverse @[] @IO :: Applicative IO => (a -> IO b) -> [a] -> IO [b]
```
```
ghci> sequenceA $ fmap Just [1,2,3]
Just [1,2,3]
```
traverse f = sequenceA . fmap f

```
ghci> sequenceA $ fmap Just [1,2,3]
Just [1,2,3]
ghci> traverse Just [1,2,3]
Just [1,2,3]
```

To Write an instance for Traversable, you need to write instance for Functor, Foldable & Applicative first.

Traversable must follow following laws:
- Naturality
- Identity
- Composition
