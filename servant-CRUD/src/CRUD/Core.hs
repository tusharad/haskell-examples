{-# LANGUAGE DataKinds #-}
module CRUD.Core where

import Network.Wai.Handler.Warp
import Network.Wai
import Servant.Server
import Servant ((:>),Get,JSON,(:<|>)(..),ReqBody,Post,Put,Delete,Capture)
import Data.Proxy
import CRUD.Query
import Control.Monad.IO.Class

type PersonAPI = "persons" :> Get '[JSON] [Person] -- "/persons" GET [Person]
                :<|> "persons" :> ReqBody '[JSON] Person :> Post '[JSON] () -- "/persons" Post ()
                :<|> "persons" :> ReqBody '[JSON] Person :> Put '[JSON] () -- "/persons" Put ()
                :<|> "persons" :> Capture "id" Int :> Delete '[JSON] () -- "/persons" Put ()

fetchPerson :: Handler [Person]
fetchPerson = do
  personList <- liftIO fetchPersonsQ
  return personList

insertPerson :: Person -> Handler ()
insertPerson person = do
  liftIO $ insertPersonQ person
  pure ()

updatePerson :: Person -> Handler ()
updatePerson person = do
  liftIO $ updatePersonQ person
  pure ()

deletePerson :: Int -> Handler ()
deletePerson personId = do
  liftIO $ deletePersonQ personId
  pure ()

personAPI :: Server PersonAPI
personAPI = (fetchPerson :<|> insertPerson :<|> updatePerson :<|> deletePerson)

app :: Application
app = serve (Proxy :: Proxy PersonAPI) personAPI

main :: IO ()
main = do
  putStrLn "server started at port 8080"
  run 8080 app

test :: IO ()
test = putStrLn "Hello from Core"
