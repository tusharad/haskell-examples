miniMaxSum arr = do
    let total = sum arr
    putStr $ show $ (total - (Prelude.maximum arr))
    putStr " "
    putStr $ show $ (total - (Prelude.minimum arr))
