{-
 Given an array of integers, find the sum of its elements.

For example, if the array , , so return .

Function Description

Complete the simpleArraySum function in the editor below. It must return the sum of the array elements as an integer.

simpleArraySum has the following parameter(s):

ar: an array of integers
-}

{-# LANGUAGE DuplicateRecordFields, FlexibleInstances, UndecidableInstances #-}

module Main where

import Control.Monad
import Data.Array
import Data.Bits
import Data.List
import Data.List.Split
import Data.Set
import Data.Text
import Debug.Trace
import System.Environment
import System.IO
import System.IO.Unsafe

--
-- Complete the 'simpleArraySum' function below.
--
-- The function is expected to return an INTEGER.
-- The function accepts INTEGER_ARRAY ar as parameter.
--

simpleArraySum ar = do
    sum(ar)

lstrip = Data.Text.unpack . Data.Text.stripStart . Data.Text.pack
rstrip = Data.Text.unpack . Data.Text.stripEnd . Data.Text.pack

main :: IO()
main = do
    stdout <- getEnv "OUTPUT_PATH"
    fptr <- openFile stdout WriteMode

    arCountTemp <- getLine
    let arCount = read $ lstrip $ rstrip arCountTemp :: Int

    arTemp <- getLine

    let ar = Data.List.map (read :: String -> Int) . Data.List.words $ rstrip arTemp

    let result = simpleArraySum ar

    hPutStrLn fptr $ show result

    hFlush fptr
    hClose fptr

