# Lists

Lists are an ordered sequence / collection of data of the same type, List is a very useful data strucutre in haskell. 
In haskell, Lists are immutable, i.e Whenever we perform any operation such as head, take, we are generating a new list from the
previous list.


## Cons operator

List are generated with the help of cons operator (:).
E.g [1,2,3] == 1 : 2 : 3 : []

You can think like an element is gettng added at the front of the list with each cons operator.
Remeber the preceance for the cons operator is like this:
    (1:(2:(3:[])))

The type of cons operator is:
```
a -> [a] -> [a]
```
i.e in the infix form, The left should be the element of type a and the right should be the list of a.
You cannot go like this, 
[1,2,3] : 4 # This is wrong
and expect element 4 would be appended at the end.
If you want to append the element i.e add the element at the end; you should do something like this;
[1,2,3] ++ [4] -> [1,2,3,4]

## Pattern matching

You can see, I have used pattern-matching. Basically it matches the given arguments with our function arguments; If the argument is same, then the following operation would be done,
similar to switch case;
The sequence is pretty important; Haskell will match it with first case firstl so make sure to put specific cases at the beginning and default ones at the end.
In Recursion, we can pattern match with base case.

## List comprehension

In the file, I will be covering...
- Basic list operations
- Maps
- List comprehension
- Pattern Matching
