module Arrays.GenerateParanthesis where

helper :: Int -> Int -> String -> [String]
helper n1 n2 temp
    | n1 == 0 && n2 == 0 = [temp]
    | otherwise = if n1 > 0 then helper (n1-1) n2 (temp++"(") else if n2 > n1 then helper n1 (n2-1) (temp++")") else []

generateParanthesis :: Int -> [String]
generateParanthesis n = helper n n ""