{-# LANGUAGE OverloadedStrings #-}
module BlogApp.Core where

import Web.Scotty
import BlogApp.HTML
import BlogApp.Query
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import BlogApp.Types
import Web.JWT
import qualified Data.Map.Strict as Map
import Data.Aeson
import Web.Scotty.Cookie
import Data.Maybe
import Data.Scientific

homeR :: ActionM ()
homeR = do
  mUser <- getAuthUser
  blogList <- liftIO $ fetchAllBlogs
  html $ homePage blogList mUser

registerR :: ActionM ()
registerR = html registerPage

loginR :: ActionM ()
loginR = html loginPage

getAuthUser :: ActionM (Maybe User)
getAuthUser = do
  mEncodedString <- getCookie "jwt_token"
  case mEncodedString of
    Nothing -> pure Nothing
    Just encodedString -> do  
      let mJWT = fmap claims $ decodeAndVerifySignature (toVerify . hmacSecret . T.pack $ "keyboard cat") encodedString
      case mJWT of
        Nothing -> pure Nothing
        Just jwt -> do
          let res = Map.lookup "user_id" $ unClaimsMap $ unregisteredClaims jwt
          case res of
            Nothing -> pure Nothing
            Just (Number user_id_) -> do
              let user_id = fromMaybe (0 :: Int) $ toBoundedInteger user_id_
              userList <- liftIO $ fetchUserById user_id
              case userList of
                [] -> pure Nothing
                [user] -> pure $ Just user

addUserR :: ActionM ()
addUserR = do
  userName <- formParam "user_name"
  userEmail <- formParam "user_email"
  userPassword <- formParam "user_password"
  (userConfirmPassword :: Text) <- formParam "user_confirm_password"
  userList <- liftIO $ fetchUserByEmail userEmail
  case userList of
    [] -> do
      if (userPassword /= userConfirmPassword) then text "password not matching" else
        (liftIO $ insertUser userName userEmail userPassword) >> redirect "/"
    _  -> text "user email already exists"

loginUserR :: ActionM ()
loginUserR = do
  userEmail <- formParam "user_email"
  password <- formParam "user_password"
  userList <- liftIO $ fetchUserByEmail userEmail
  case userList of
    [] -> text "user does not exist, please register first"
    [userFromDB] -> do
      if (password == (userPassword userFromDB)) then do
          let key = hmacSecret . T.pack $ "keyboard cat"
              cs = mempty { -- mempty returns a default JWTClaimsSet
              iss = stringOrURI . T.pack $ "Foo"
              , unregisteredClaims = ClaimsMap $ 
                Map.fromList [(T.pack "user_id", (Number $ fromIntegral (userID userFromDB)))]
          }
          let encodedString = encodeSigned key mempty cs
          setSimpleCookie "jwt_token" encodedString 
          redirect "/"
      else text $ "password is wrong!"


addBlogR :: ActionM ()
addBlogR = html $ addBlogPage

addBlogP :: ActionM ()
addBlogP = do
  mUser <- getAuthUser
  case mUser of
    Nothing -> text "please login first!"
    Just user -> do
      blogTitle <- formParam "blog_title"
      blogContent <- formParam "blog_content"
      liftIO $ insertBlog (userID user) blogTitle blogContent
      redirect "/"

deleteBlogR :: ActionM ()
deleteBlogR = do
  mUser <- getAuthUser
  case mUser of
    Nothing -> redirect "/"
    Just user -> do
      blogId <- pathParam "blogId"
      blogList <- liftIO $ fetchBlogById blogId
      case blogList of
        [] -> redirect "/"
        [blog] -> do
          if (userID user) == (userId blog) then do
            liftIO $ deleteBlogById blogId
            redirect "/"
          else redirect "/"

main :: IO ()
main = scotty 8080 $ do
  get "/"           homeR
  get "/register"   registerR
  get "/login"      loginR
  get "/addBlog"    addBlogR
  post "/addBlog"    addBlogP
  post "/addUser"   addUserR
  post "/loginUser" loginUserR
  get "/delete/:blogId" deleteBlogR

test :: IO ()
test = putStrLn "Hello there"
