-- {https://open.kattis.com/problems/fizzbuzz}

module Main where

solve :: [Int] -> IO ()
solve (x:y:0:_) = return ()
solve (x:y:n:_) = do
	solve (x:y:(n-1):[])
	if (n `mod` x == 0) && (n `mod` y == 0) then putStrLn "FizzBuzz"
		else if (n `mod` x == 0) then putStrLn "Fizz"
			else if (n `mod` y == 0) then putStrLn "Buzz"
				else print n

main = do
	nums_ <- getLine
	let nums = map read (words nums_)
	solve nums
