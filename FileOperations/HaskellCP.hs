import System.IO
import System.Environment

main :: IO ()
main = do
 args <- getArgs
 if (length args) < 2 then do
  putStrLn "Please provide at least 2 arguments"
  return ()
 else do
  let originalFile = (head args)
  let copyFile = args !! 1
  fileContents <- readFile originalFile
  writeFile copyFile fileContents
