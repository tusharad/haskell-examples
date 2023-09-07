roundTo :: Int -> Double -> Double
roundTo n x = (fromInteger $ round $ x * (10^n)) / (10.0^^n)

plusMinus arr = do
    let positives = sum [1 | x <- arr, x > 0]
    let negatives = sum [1 | x <- arr, x < 0]
    let zeros = sum [1 | x <- arr, x == 0]
    print $ roundTo 6 $  positives / fromIntegral (Data.List.length arr)
    print $ roundTo 6 $  negatives / fromIntegral (Data.List.length arr)
    print $ roundTo 6 $  zeros / fromIntegral (Data.List.length arr)
