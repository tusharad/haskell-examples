printHello :: Int -> IO ()
printHello 0 = return ()
printHello n = do
    putStrLn "Hello World"
    printHello (n-1)

main :: IO()
main = do
    n <- readLn :: IO Int

    -- Print "Hello World" on a new line 'n' times.
    printHello  n
