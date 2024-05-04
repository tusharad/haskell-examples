{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module CRUD.Query where

import Database.SQLite.Simple
import GHC.Generics
import Data.Aeson

data Person = Person {
  personId :: Int,
  personName :: String,
  age        :: Int
} deriving (Eq,Show,FromRow,ToRow,Generic,ToJSON,FromJSON)

getConn :: IO Connection
getConn = open "/home/user/yt/servantDB"

fetchPersonsQ :: IO [Person]
fetchPersonsQ = do
  conn <- getConn
  personList <- query_ conn "select *from persons;"
  close conn
  pure personList

insertPersonQ :: Person -> IO ()
insertPersonQ person = do
  conn <- getConn
  execute conn "insert into persons values (?,?,?);" person
  close conn

updatePersonQ :: Person -> IO ()
updatePersonQ Person{..} = do
  conn <- getConn
  execute conn "update persons set person_name = ?, age = ? where person_id = ?;" (personName,age,personId)
  close conn

deletePersonQ :: Int -> IO ()
deletePersonQ personId = do
  conn <- getConn
  execute conn "delete from persons where person_id = ?" (Only personId)
  close conn

test :: IO ()
test = putStrLn "Hello from Query"
