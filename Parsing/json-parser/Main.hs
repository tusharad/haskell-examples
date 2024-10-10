module Main where

import Control.Applicative (Alternative, empty, many, (<|>))
import Data.Char (digitToInt, isDigit, isSpace)

newtype Parser ip op = Parser {runParser :: ip -> Maybe (ip, op)}

instance Functor (Parser ip) where
    fmap someFunc (Parser x) = Parser (\ip -> fmap someFunc <$> x ip)

instance Applicative (Parser ip) where
    pure x = Parser $ \y -> Just (y, x)
    (Parser parserFunc) <*> (Parser parserVal) = Parser $ \x ->
        case parserFunc x of
            Nothing -> Nothing
            Just (ip', func') -> fmap func' <$> parserVal ip'

instance Alternative (Parser ip) where
    empty = Parser $ const Nothing
    parser1 <|> parser2 = Parser $ \ip ->
        case runParser parser1 ip of
            Just res -> Just res
            Nothing -> runParser parser2 ip

splitBy :: Char -> String -> [String]
splitBy _ [] = []
splitBy ch str =
    let (before, remainder) = break (== ch) str
     in before : case remainder of
            [] -> []
            (_ : rest) -> splitBy ch rest

-- Parser functions
char :: Char -> Parser String Char
char c = Parser $ \str ->
    case str of
        [] -> Nothing
        (x : xs) -> if (x == c) then Just (xs, c) else Nothing

string :: String -> Parser String String
string = traverse char

digit :: Parser String Int
digit = Parser $ \str ->
    case str of
        [] -> Nothing
        (x : xs) -> if isDigit x then Just (xs, digitToInt x) else Nothing

number :: Parser String Double
number = Parser $ \str ->
    case str of
        [] -> Nothing
        (x : xs) ->
            if isDigit x || x == '-'
                then
                    ( if x == '-'
                        then go True True 10 0 xs
                        else go False True 10 0 str
                    )
                else Nothing
  where
    go ::
        Bool ->
        Bool ->
        Double ->
        Double ->
        String ->
        Maybe (String, Double)
    go isNegative isBeforeDecimal scaleAfterDecimal res str = case str of
        [] -> Nothing
        (x : xs) ->
            if isDigit x
                then
                    go
                        isNegative
                        isBeforeDecimal
                        ( if isBeforeDecimal
                            then scaleAfterDecimal
                            else scaleAfterDecimal * 10
                        )
                        ( if isBeforeDecimal
                            then
                                res * 10 + fromIntegral (digitToInt x)
                            else
                                res + (fromIntegral (digitToInt x) / scaleAfterDecimal)
                        )
                        xs
                else
                    if x == '.' && isBeforeDecimal
                        then
                            go isNegative False 10 res xs
                        else
                            Just
                                ( x : xs
                                , if isNegative then (-1) * res else res
                                )

between :: Parser String a -> Parser String b -> Parser String c -> Parser String c
between parserLeft parserRight parserMain = parserLeft *> parserMain <* parserRight

takeWhileP :: (Char -> Bool) -> Parser String String
takeWhileP pred = Parser $ \str -> go "" str
  where
    go res str = case str of
        [] -> Nothing
        (x : xs) ->
            if pred x
                then go (res ++ [x]) xs
                else Just (x : xs, res) -- Adding the last character which
                -- did not passed the predicate

satisfy :: (Char -> Bool) -> Parser String Char
satisfy pred = Parser $ \str ->
    case str of
        [] -> Nothing
        (x : xs) -> if pred x then Just (xs, x) else Nothing

skipSpaces :: Parser String a -> Parser String a
skipSpaces p = many (satisfy isSpace) *> p <* many (satisfy isSpace)

-- JSON Parser part
data JsonValue
    = JNull
    | JString String
    | JNumber Double
    | JBool Bool
    | JArray [JsonValue]
    | JObject [(String, JsonValue)]
    deriving (Show, Eq)

jNull :: Parser String JsonValue
jNull = JNull <$ string "null"

jStringHelper :: Parser String String
jStringHelper = between (char '\"') (char '\"') (takeWhileP (/= '\"'))

jString :: Parser String JsonValue
jString = JString <$> jStringHelper

jBool :: Parser String JsonValue
jBool = JBool <$> ((True <$ string "true") <|> (False <$ string "false"))

jNumber :: Parser String JsonValue
jNumber = JNumber <$> number

jArrayHelper :: Parser String [JsonValue]
jArrayHelper = (:) <$> mainParser <*> many (char ',' *> mainParser)

jArray :: Parser String JsonValue
jArray = JArray <$> between (char '[') (char ']') (jArrayHelper <|> pure [])

mainParser :: Parser String JsonValue
mainParser = skipSpaces jNull 
        <|> skipSpaces jString 
        <|> skipSpaces jBool 
        <|> skipSpaces jNumber 
        <|> skipSpaces jArray 
        <|> skipSpaces jObject

jObjectHelper :: Parser String JsonValue
jObjectHelper = JObject <$> (go <|> pure [])
  where
    go :: Parser String [(String, JsonValue)]
    go = (:) <$> someFunc <*> many (char ',' *> someFunc)

    someFunc :: Parser String (String, JsonValue)
    someFunc = (,) <$> skipSpaces (jStringHelper <* skipSpaces (char ':')) <*> mainParser

jObject :: Parser String JsonValue
jObject = between (char '{') (char '}') jObjectHelper

parseJson :: String -> Either String JsonValue
parseJson ip = 
    case runParser mainParser ip of
        Just ("", result) -> Right result 
        Just (remaining, result) -> Left ("Parsing incomplete. Remaining input: " ++ remaining)
        Nothing -> Left "Failed to parse JSON."

main :: IO ()
main = do
    putStrLn "Enter JSON content"
    ip <- getContents
    case parseJson ip of
        Right r -> putStrLn ("Parsed json: " ++ show r)
        Left err -> putStrLn ("Error:" ++ err)
