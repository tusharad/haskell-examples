## Monoids

- Monoids provides us three operations/functions
- 1. mempty
  2. mappend
  3. mconcat
- The operations which are instances of monoids can use these functions.
mconcat similar to concat, takes a list of type a (where a is a type who has an instance of Monoid) and concatinates all of them.
for e.g
```
prelude> mconcat [Just "hello",Just " haskell!"]
prelude> Just "hello haskell!"
```
