module Main where
import System.IO
import qualified Data.Text as T
import qualified Data.Text.IO as TI

getCounts :: T.Text -> (Int,Int,Int)
getCounts contents = (cc,wc,lc)
 where
  cc = T.length contents
  wc = (length. T.words) contents
  lc = (length. T.lines) contents

countsText :: (Int,Int,Int) -> T.Text
countsText (cc,wc,lc) = T.pack $ unwords ["characters: ",show cc," words: ",show wc," lines: ",show lc]

main :: IO ()
main = do
 fileData <- readFile "./sample.txt"
 -- _ <- readFile' "./sample.txt"		-- read files all at once and then returns it, readFile does it lazyly
 putStrLn $ head $ words fileData
 fh <- openFile "./sample.txt" ReadMode
 firstLine <- hGetLine fh
 putStrLn firstLine
 secondLine <- hGetLine fh
 putStrLn secondLine
 isEOF <- hIsEOF fh
 thirdLine <- if isEOF then return "Empty!" else hGetLine fh
 putStrLn thirdLine
 TI.putStrLn $ (countsText.getCounts) $ T.pack fileData
 -- using Text instead of Strings during while operations to avoid lazy evaluation
 -- contents <- hGetContents fh
 -- putStrLn contents
 hClose fh
