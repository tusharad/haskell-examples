{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DuplicateRecordFields #-}
module BlogApp.Types where
import Data.Text (Text)
import           Database.SQLite.Simple.FromRow
import           GHC.Generics
import           Data.Time

data User = User {
    userID :: Int 
  ,  userName :: Text
 ,  userEmail :: Text
 , userPassword :: Text
} deriving (Eq,Show,FromRow,Generic)

data Blog = Blog {
  blogId :: Int,
  blogTitle :: Text,
  blogContent :: Text,
  timeStamp :: UTCTime,
  userId :: Int
} deriving (Eq,Show,FromRow,Generic)
