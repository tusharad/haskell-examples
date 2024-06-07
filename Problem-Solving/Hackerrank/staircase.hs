printHash :: Int -> IO ()
printHash 0 = return ()
printHash n = do
    putStr "#"
    printHash (n-1)

printSpace :: Int -> IO ()
printSpace 0 = return ()
printSpace n = do
    putStr " "
    printSpace (n-1)

staircase_ n i 
    | n == i = return ()
    | otherwise= do
        printSpace (n-i-1)
        printHash (i+1)
        putStrLn ""    
        staircase_ (n) (i+1)

staircase n = staircase_ n 0
