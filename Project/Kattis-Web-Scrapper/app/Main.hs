module Main (main) where

import System.Environment
import Text.HTML.Scalpel
import System.IO.Unsafe
import Data.Char
import Data.List

getHTML :: Scraper String String
getHTML = html ((TagString "div") @: [hasClass "problembody"])

getProblemStatement :: String -> Maybe [String]
getProblemStatement str = scrapeStringLike str (texts $ tagSelector "p")

getInputOutput :: String -> Maybe [String]
getInputOutput str = scrapeStringLike str (texts $ tagSelector "pre")

formatInputOutput :: [String] -> String
formatInputOutput strList = formatInputOutput_ strList ""

formatInputOutput_ :: [String] -> String -> String
formatInputOutput_ [] result = result
formatInputOutput_ [x] result = result		-- edgecase where list if of odd length
formatInputOutput_ (x:y:xs) result = formatInputOutput_ xs (result ++ ("\nInput:\n" ++ x ++ "Output:\n" ++ y))

getTitle :: Scraper String String
getTitle = text ((TagString "h1") @: [hasClass "book-page-heading"])

firstCap :: String -> String
firstCap (x:xs) = [toUpper x] ++ xs

toPascalCase :: String -> String
toPascalCase str = intercalate "" $ map (firstCap) (words str)

main :: IO ()
main = do
	args <- getArgs
	case args of
		[] -> putStrLn "Please provide link!"
		_ -> do
			let url = head args
			let extractedHTML = unsafePerformIO $ scrapeURL url getHTML
			case extractedHTML of
				Nothing -> putStrLn "didn't find problemBody"
				Just extractedHTML' -> do
					let problemStatement = getProblemStatement extractedHTML'
					case problemStatement of 
						Nothing -> putStrLn "Didin't find any problem statement"
						Just problemStatement' -> do
							let result = unwords problemStatement'
							let inputOutput = getInputOutput extractedHTML'
							case inputOutput of
								Nothing -> putStrLn "Didn't find any input output"
								Just inputOutput' -> do
									let formattedInputs = formatInputOutput inputOutput'
									let extractedTitle = unsafePerformIO $ scrapeURL url getTitle
									case extractedTitle of
										Nothing -> putStrLn "titleNotFound"
										Just extractedTitle' -> do
											let title = toPascalCase extractedTitle'
											let finalText = "{- \n" ++ title ++ "\n"  ++ result ++ "\n" ++ formattedInputs ++ "\n -}"
											writeFile (title ++ ".hs") finalText
