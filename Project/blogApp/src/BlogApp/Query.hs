{-# LANGUAGE OverloadedStrings #-}
module BlogApp.Query where
import           Database.SQLite.Simple
import           Data.Text (Text)
import           BlogApp.Types

fetchUserByEmail :: Text -> IO [User]
fetchUserByEmail email = do
  conn <- open "/home/user/haskell/blogAppDB"
  userList <- query conn "select *from users where user_email = ?" (Only email) :: IO [User]
  close conn
  pure userList
  
insertUser :: Text -> Text -> Text -> IO ()
insertUser userName userEmail userPassword = do
  conn <- open "/home/user/haskell/blogAppDB"
  execute conn "insert into users (user_name,user_email,user_password) values (?,?,?)" (userName,userEmail,userPassword)
  close conn

fetchUserById :: Int -> IO [User]
fetchUserById userId = do
  conn <- open "/home/user/haskell/blogAppDB"
  userList <- query conn "select *from users where user_id = ?" (Only userId) :: IO [User]
  close conn
  pure userList

insertBlog :: Int -> Text -> Text -> IO ()
insertBlog userId blogTitle blogContent =  do
  conn <- open "/home/user/haskell/blogAppDB"
  execute conn "insert into blogs (blog_title,blog_content,user_id) values (?,?,?)" (blogTitle,blogContent,userId)
  close conn

fetchAllBlogs :: IO [Blog]
fetchAllBlogs = do
  conn <- open "/home/user/haskell/blogAppDB"
  blogList <- query_ conn "select *from blogs" :: IO [Blog]
  close conn
  pure blogList

fetchBlogById :: Int -> IO [Blog]
fetchBlogById blogId = do
  conn <- open "/home/user/haskell/blogAppDB"
  blogList <- query conn "select *from blogs where blog_id = ?" (Only blogId) :: IO [Blog]
  close conn
  pure blogList

deleteBlogById :: Int -> IO ()
deleteBlogById blogId = do
  conn <- open "/home/user/haskell/blogAppDB"
  execute conn "delete from blogs where blog_id = ?" (Only blogId)
  close conn
