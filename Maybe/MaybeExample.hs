import Data.Maybe (fromMaybe,catMaybes)

data Optional a = Only a | Empty

instance Functor Optional where
 fmap someFunc (Only n) = Only (someFunc n)
 fmap _ Empty = Empty

getVal2 :: Optional Int
getVal2 = Only 23

getVal :: Maybe Int
getVal = Just 2

main :: IO ()
main = do
 let result = getVal
 case result of
  Just val -> print val
  Nothing -> print ("Something went wrong!")
 case getVal2 of
  Only val -> print val
  Empty -> print("Something went wrong!")
 -- Alternatively, instead of using case expression to pattern match Maybe result
 -- We can use fromMaybe from Data.Maybe
 print $ fromMaybe "" (Just "tushar")
 print $ fromMaybe "" Nothing
 print $ catMaybes [Just 2,Just 3]
