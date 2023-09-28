-- creating linked list in haskell

data SinglyLinkedList = SinglyLinkedList {val :: Int,next :: SinglyLinkedList} | Nil

instance Show SinglyLinkedList where
 show (Nil) = ""
 show (SinglyLinkedList x Nil) = (show x)
 show (SinglyLinkedList x xs) = (show x) ++ " -> " ++(show xs)

-- let head = SinglyLinkedList {val = 2,next = SinglyLinkedList {val = 4,next = Nil}}

createList :: [Int] -> SinglyLinkedList
createList [] = Nil
createList (x:xs) = SinglyLinkedList {val = x,next = createList xs}

-- We are assuming that index will always be less than length of linked list..we are not checking whether
-- index is out of bound or not
-- need to find a way to join the list..Cool!
-- The first integer is index and second one is the value to be inserted
insertAtIndex :: SinglyLinkedList -> Int -> Int -> SinglyLinkedList
insertAtIndex llist 1 value = SinglyLinkedList {val = value,next = llist}
insertAtIndex llist index value = SinglyLinkedList {val = (val llist),
next = insertAtIndex (next llist) (index-1) value}

-- Deleting the node at index
-- Value is getting deleted!
deleteAtIndex :: SinglyLinkedList -> Int -> SinglyLinkedList
deleteAtIndex llist 1 = (next llist)
deleteAtIndex llist index = SinglyLinkedList {val = (val llist),next = deleteAtIndex (next llist) (index-1)}

main :: IO ()
main = do
 let head = createList [1..10]
 print $ deleteAtIndex head 3
 putStrLn "Hello"
