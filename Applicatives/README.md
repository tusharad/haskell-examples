## Applicatives

Applicative is the typeclass which provides us function such as <*> (prononuced as `ap`). This function is similar to `fmap`. <*> takes two arguments, first a function inside some strcutre, second a value inside the same strucutre. <*> penetrates both structure for function and value and apply the function on the value and returns the result inside the structure.

Every instance of Applicative must be an instance of `functor` first. 

In a lot of scenerios, `ap` is used to chain number of arguments for `fmap`.
for e.g
```
    fmap (,) [1,2] <*> [3,4]
```

```
Applicatives are nothing but monoidal functors.
```
for e.g

```haskell
[(+1)] <*>  [1,2] ==> [2,3]
```

Control.Applicative provides us some better functions such as liftA,liftA2,liftA3.

liftA behaves same as fmap.
liftA2 takes a function that takes two argument, and then two arguments inside the strucutre.
```
ghci> liftA3 (add3) (Just 2) (Just 3) (Just 5)
```

### Laws of Applicative
    - Identity
    - Composition
    - Homophormism
    - Interchange
