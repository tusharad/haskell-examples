{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
module MyLib where

import           Graphics.Vty
import           Graphics.Vty.Platform.Unix (mkVty)
import           Control.Concurrent
import           Control.Monad.Trans.State
import qualified Data.Vector as V
import           System.Random
import           Control.Monad.IO.Class
import           Data.String.Interpolate
import           Data.Maybe

type UserInput = String
type GivenString = String
type CurrentGivenString = String
type CurrentUserInput = String

listOfWords :: V.Vector String
listOfWords = V.fromList ["monster",
  "reflect",
  "summer",
  "radical",
  "belly",
  "mosque",
  "cigarette",
  "allowance",
  "village",
  "elegant"]

truncate_ :: Double -> Int -> Double
truncate_ num places = fromIntegral (floor (num*t)) / t
  where
    t = 10^places

titleText :: String
titleText = [i|--------------------\nSpeed Typing Test :)\n--------------------|]

titleLogo :: Image
titleLogo = mconcat $ map (string (defAttr `withForeColor` blue)) (lines titleText)

timer :: Vty -> Double -> Double -> MVar () -> MVar Double -> IO ()
timer vty totalSec remainingSec timerEndVar correctWordsCountVar
    | remainingSec <= 0.3 = update vty timeUpImage >> putMVar timerEndVar ()
    | otherwise = do
        correctWordsCount <- readMVar correctWordsCountVar
        update vty (fullImage correctWordsCount)
        threadDelay 300000
        timer vty totalSec (remainingSec-0.30000) timerEndVar correctWordsCountVar
    where
      timeUpImage = picForImage $ titleLogo <-> string (defAttr `withBackColor` red) "Time's up!"
      timerPic = string (defAttr `withForeColor` green) $ "Time Left: " <> show (truncate_ remainingSec 2) <> " seconds"
      wpmPic correctWordsCount = pad 10 0 0 0 $ string (defAttr `withForeColor` green) $ "WPM: " <> show (truncate_ ((correctWordsCount / (totalSec - remainingSec))*60) 2)
      fullImage correctWordsCount = picForImage $ titleLogo <-> (timerPic <|> wpmPic correctWordsCount)

getInputFromUser_ :: Vty -> String -> String -> MVar () -> IO (Maybe String)
getInputFromUser_ vty stringToType userInputString timerEndVar = do
    update vty prettyPrintStrings
    try <- tryTakeMVar timerEndVar
    case try of
      Just _ -> pure Nothing
      __ -> do
        e <- nextEvent vty
        tryAgain <- tryTakeMVar timerEndVar
        case tryAgain of
          Just _ -> pure Nothing
          __ -> do
            case e of
              EvKey KEnter _    -> pure (Just userInputString)
              EvKey (KChar c) _ -> getInputFromUser_ vty stringToType (userInputString ++ [c]) timerEndVar
              EvKey KBS _       -> getInputFromUser_ vty stringToType (if null userInputString then "" else init userInputString) timerEndVar
              EvKey KEsc _      -> pure Nothing
              _                 -> getInputFromUser_ vty stringToType userInputString timerEndVar
    where
      stringToTypePic = string (defAttr `withForeColor` green) $ "String to Type: " <> stringToType
      userTypedStringPic = string (defAttr `withForeColor` green) $ "Type: " <> userInputString
      prettyPrintStrings = picForImage $ translate 0 5 $ stringToTypePic <-> userTypedStringPic

getInputFromUser :: Vty -> MVar () -> MVar Double -> StateT [(UserInput,GivenString)] IO ()
getInputFromUser vty timerEndVar correctWordsCountVar = do
    n <- liftIO (randomRIO (0,9) :: IO Int)
    let suggestedWord = listOfWords V.! n
    mUserInputString <- liftIO $ getInputFromUser_ vty suggestedWord "" timerEndVar
    case mUserInputString of
        Nothing -> pure ()
        Just userInputString -> do
            modify ((userInputString,suggestedWord):)
            oldCount <- liftIO $ takeMVar correctWordsCountVar
            _ <- liftIO $ putMVar correctWordsCountVar $ oldCount + if userInputString == suggestedWord then 1 else 0
            getInputFromUser vty timerEndVar correctWordsCountVar

showScore :: Vty -> Double -> Double -> [(UserInput,GivenString)] -> IO ()
showScore vty correctWordCount totalTimeElapsed _ = update vty (picForImage wPMFormulaPic) >> threadDelay 3000000
  where
    wPMFormulaPic = string (defAttr `withForeColor` green) $ "WPM: " <> show (truncate_ ((correctWordCount / totalTimeElapsed)*60) 2)

main :: IO ()
main = do
    vty <- mkVty defaultConfig
    vty0 <- mkVty defaultConfig
    shutdownInput $ inputIface vty0
    timerEndVar <- newEmptyMVar
    correctWordsCountVar <- newMVar 0
    _ <- forkIO $ timer vty0 15 15 timerEndVar correctWordsCountVar
    evalStateT (getInputFromUser vty timerEndVar correctWordsCountVar) []
    mCorrectWordCount <- tryTakeMVar correctWordsCountVar
    let correctWordCount = fromMaybe 0 mCorrectWordCount
    _ <- showScore vty correctWordCount 15 []
    shutdown vty
    shutdown vty0