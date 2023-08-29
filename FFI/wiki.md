[https://ghc.gitlab.haskell.org/ghc/doc/users_guide/exts/ffi.html]
[https://en.wikibooks.org/wiki/Haskell/FFI]
[https://wiki.haskell.org/Foreign_Function_Interface]

Haskell FFI (Foreign Function Interface) helps calling c functions from haskell and vice versa. You just need to write function signature with appropriate data types (haskell equivalent data types of c).

## How to run:

$ ghc ffi_examples.hs ffi_examples_c.hs
$ ./ffi_examples

## 
You can never return char* from c function. You must create the string in heap (malloc) and then only you can return the string.

## Upcoming functions

1. Take 2 array...return concatenated array
2. Take 2 pointers...return nothing
3. take 2 strings...return one string
4. use foreignPointer, deallocate memory, allocate memory
5. dynamic array,dynamic string
