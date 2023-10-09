module Main where
import System.Environment
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC

intToChar :: Int -> Char
intToChar n = toEnum safeInt
    where safeInt = n `mod` 256

intToBC :: Int -> BC.ByteString
intToBC n = BC.pack [intToChar n]

replaceByte :: Int -> Int -> BC.ByteString -> BC.ByteString
replaceByte loc charVal bytes = mconcat [before,newByte,after]
    where (before,rest) = BC.splitAt loc bytes
          after = BC.drop 1 rest
          newByte = intToBC charVal

randomReplaceByte :: BC.ByteString -> IO BC.ByteString
randomReplaceByte bytes = do
    let bytesLength = BC.length bytes
    let location = 852
    let charVal = 190
    return (replaceByte location charVal bytes)
    
main :: IO ()
main = do
    args <- getArgs
    let fileName = head args
    imageFile <- B.readFile fileName
    glitched <- randomReplaceByte imageFile
    let glitchedFileName = mconcat ["glitched_",fileName]
    BC.writeFile glitchedFileName glitched
    putStrLn "All done!"
    
