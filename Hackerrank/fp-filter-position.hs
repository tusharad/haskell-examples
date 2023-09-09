f :: [Int] -> [Int]
f [] = []
f [x] = []
f (_:y:xs) = y : (f xs)
