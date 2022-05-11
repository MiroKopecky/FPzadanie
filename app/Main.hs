{-# START_FILE Main.hs #-}
{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Main where

import System.IO ()
import Parser ( parseWebSite )
import Data.Aeson
import Data.Text
import GHC.Generics

data Pages =
  Pages {url :: !Text, html_content :: !Text} deriving (Show,Generic)

data Person = Person { name :: Text, age :: Int } deriving (Generic, Show)

instance FromJSON Pages
instance ToJSON Pages

main :: IO ()
main = do


   --PARSING--
   let fileName = "data/output.jl" -- After complete parser change filename for "data/collection.jl" instead "data/output.jl"
   parsedWeb <- Parser.parseWebSite fileName -- parsedWeb - contain parsed web text

   putStrLn $ "Decode: " ++ (show (decode "{ \"url\": \"example.com\", \"html_content\": \"<div>asdf</div>\" }" :: Maybe Pages))

   --INDEXER--

   --PAGE RANK--

   putStrLn "Done!"
