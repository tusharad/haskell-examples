{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Lib (someFunc) where

import Servant
import Network.Wai.Handler.Warp (run)
import Database.SQLite.Simple hiding ((:.))
import GHC.Generics
import Servant.Auth.Server
import Data.Aeson
import Control.Monad.IO.Class
import qualified Data.ByteString.Lazy.Char8 as BSC

data Admin = Admin { 
     adminName :: String 
    , adminEmail :: String
    , adminPassword :: String
} deriving (Eq,Show,Generic,FromRow,FromJWT,FromJSON,ToJWT,ToJSON)

data AdminData = AdminData { 
    adminEmail :: String
    , adminPassword :: String
} deriving (Eq,Show,Generic,FromJSON)

getConn :: IO Connection
getConn = open "/home/user/yt/haskell-examples/someDB.db"

fetchAdminQ :: String -> String -> IO (Maybe Admin)
fetchAdminQ email password = do
    conn <- getConn
    res <- query conn "SELECT * FROM admin WHERE adminemail = ? AND adminpassword = ?" (email, password) :: IO [Admin]
    return $ case res of
        [] -> Nothing
        (x:_) -> Just x

type MainAPI auths = "admin" 
            :> "login" 
                :> ReqBody '[JSON] AdminData 
                    :> Post '[JSON] 
                        (Headers '[Header "Set-Cookie" SetCookie
                            , Header "Set-Cookie" SetCookie] String)
            :<|> 
                Auth auths Admin 
                    :> "admin" 
                        :> "dashboard" 
                            :> Get '[JSON] String

server :: CookieSettings -> JWTSettings -> Server (MainAPI auths)
server cookieSett jwtSett = adminLoginHandler :<|> adminDashboardHandler
    where
        adminLoginHandler = adminLoginH cookieSett jwtSett
        adminDashboardHandler = adminDashboardH

adminLoginH :: CookieSettings 
                  -> JWTSettings 
                  -> AdminData 
                  -> Handler (Headers '[Header "Set-Cookie" SetCookie,Header "Set-Cookie" SetCookie] String)
adminLoginH cookieSett jwtSett AdminData{..} = do
    mAdmin <- liftIO $ fetchAdminQ adminEmail adminPassword
    case mAdmin of
        Nothing -> throwError $ err401 {errBody = "email/password not found"}
        Just admin -> do
            mLoginAccepted <- liftIO $ acceptLogin cookieSett jwtSett admin
            case mLoginAccepted of
                Nothing -> throwError $ err401 {errBody = "login failed! Please try agian!"}
                Just x -> do
                    eJWT <- liftIO $ makeJWT admin jwtSett Nothing
                    case eJWT of
                        Left _ -> throwError $ err401 {errBody = "login failed! please try again!"}
                        Right r -> return $ x (BSC.unpack r)

adminDashboardH :: (AuthResult Admin) -> Handler String
adminDashboardH (Authenticated Admin{..})= return $ "Hello " <> adminName <> "!"
adminDashboardH _ = throwError err400 {errBody = "Not allowed!"}


someFunc :: IO ()
someFunc = do
    let port = 8080
    jwtSecretKey <- generateKey
    let jwtSett = defaultJWTSettings jwtSecretKey
    let cookieSett = defaultCookieSettings
    let cfg = cookieSett :. jwtSett :. EmptyContext
    run port $ serveWithContext 
        (Proxy :: Proxy (MainAPI '[JWT,Cookie])) cfg $ (server cookieSett jwtSett)
