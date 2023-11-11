## Foldable

```
A class of data structures that can be summaries in single value. It includes functions such as foldr,foldl and foldMap.
```

Tracing of foldr

```haskell
ghci> foldr (\x -> ([x]++)) [0] [1,2,3]
[1,2,3,0]
```

ghci> ([1]++[2]++([3]++[0]))
[1,2,3,0]
