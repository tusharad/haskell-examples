{-# LANGUAGE OverloadedStrings #-}
-- examples of byteString
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC

sampleBytes :: B.ByteString
sampleBytes = "Hello in bytes :)"

bcInt :: BC.ByteString
bcInt = "6"

bcToInt :: BC.ByteString -> Int
bcToInt = (read . BC.unpack) 

main :: IO ()
main = do
    print $ bcToInt bcInt
    putStrLn $ BC.unpack sampleBytes 
