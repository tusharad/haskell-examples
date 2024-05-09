{-# LANGUAGE OverloadedStrings #-}
module BlogApp.HTML where

import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as HA
import Data.Text.Lazy (Text)
import Text.Blaze.Renderer.Text
import BlogApp.Types

loginPage :: Text
loginPage = renderMarkup $ do
  html $ do
    body $ do
      h1 "Login"
      H.form ! HA.method "POST" ! HA.action "/loginUser" $ do
        H.label "user email"
        input ! type_ "email" ! name "user_email"
        br
        H.label "password"
        input ! type_ "password" ! name "user_password"
        br
        button ! type_ "submit" $ "Login"

registerPage :: Text
registerPage = renderMarkup $ do
  html $ do
    body $ do
      h1 "Register"
      H.form ! HA.method "POST" ! HA.action "/addUser" $ do
        H.label "user name"
        input ! type_ "text" ! name "user_name"
        br
        H.label "user email"
        input ! type_ "email" ! name "user_email"
        br
        H.label "password"
        input ! type_ "password" ! name "user_password"
        br
        H.label "confirm password"
        input ! type_ "password" ! name "user_confirm_password"
        br
        button ! type_ "submit" $ "register"


addBlogPage :: Text
addBlogPage = renderMarkup $ do
  html $ do
    body $ do
      h1 "Add Blog"
      H.form ! HA.method "POST" ! HA.action "/addBlog" $ do
        H.label "Title"
        input ! type_ "text" ! name "blog_title"
        br
        H.label "content"
        textarea ! name "blog_content" $ "" 
        br
        button ! type_ "submit" $ "add blog"

homePage :: [Blog] -> Maybe User -> Text
homePage blogList mUser = renderMarkup $ do
  html $ do
    body $ do
      h1 "Blogs"
      ul $ mapM_ (\blog -> li $ H.div $ do
        toMarkup (blogTitle blog)
        case mUser of
          Nothing -> mempty
          Just user -> if (userID user) == (userId blog) then H.a ! href ("/delete/" <> (toValue (blogId blog))) $ " delete" else mempty
        ) blogList
