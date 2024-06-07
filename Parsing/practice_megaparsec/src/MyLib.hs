module MyLib (someFunc) where

import Text.Megaparsec
import Text.Megaparsec.Char
import Data.Void

type Parser = Parsec Void String

type ConfigName = String
type Config = (String,String)
type Result = [(ConfigName,[Config])]

parseConfigName :: Parser ConfigName
parseConfigName = do
  _ <- char '['
  configName <- some alphaNumChar
  _ <- char ']'
  newline
  return configName

parseConfig :: Parser Config
parseConfig = do
  key <- some alphaNumChar
  _ <- char '='
  value <- some alphaNumChar
  newline
  return (key,value)

finalParse :: Parser Result 
finalParse = some $ do
  configName <- parseConfigName
  configs <- some parseConfig
  return (configName,configs)

someFunc :: IO ()
someFunc = do
  let content = "[audio]\nvolume=15"
  print content

{-
parseCharA :: Parser Char
parseCharA = hidden (char 'a')

parseCharB :: Parser Char
parseCharB = char 'b'

parseCharAB :: Parser String
parseCharAB = do
  charA <- parseCharA
  charB <- parseCharB
  return (charA:charB:[])

parseCat :: Parser String
parseCat = do
  space
  sym <- symbolChar
  a <- upperChar
  b <- lowerChar
  _ <- tab
  c <- digitChar
  e <- newline
  d <- asciiChar
  space
  f <- asciiChar
  return (sym:a:b:c:d:f:[])

parseCat2 :: Parser String
parseCat2 = many (char 'z')
-}

