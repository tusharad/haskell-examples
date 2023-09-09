module Main where

f :: [Int] -> [Int]
f lst = lst

main = do
	inputdata <- getContents
	mapM_ (putStrLn. show). f. map read. lines $ inputdata
