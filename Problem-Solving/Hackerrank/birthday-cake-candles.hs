birthdayCakeCandles candles = do
    Data.List.length (Prelude.filter (== (Prelude.maximum candles)) candles)
