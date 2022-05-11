{-# START_FILE Main.hs #-}
{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Main where

import System.IO ()
import Parser ( parseWebSite )
import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics

data Pages =
  Pages {url :: !Text, html_content :: !Text} deriving (Show,Generic)

instance FromJSON Pages
instance ToJSON Pages

jsonFile :: FilePath
jsonFile = "data/output.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile

main :: IO ()
main = do

   -- Get JSON data and decode it
   d <- (eitherDecode <$> getJSON) :: IO (Either String [Pages])
   -- If d is Left, the JSON was malformed. -> In that case, we report the error.
   -- Otherwise, we perform the operation of our choice. In this case, just print it.
   case d of
      Left err -> putStrLn err
      Right ps -> print ps
   instance Show (Pages ulr) where
   show (Pages url) = "asdf"

   --PARSING--
   -- let fileName = "data/output.jl" -- After complete parser change filename for "data/collection.jl" instead "data/output.jl"
   -- parsedWeb <- Parser.parseWebSite fileName -- parsedWeb - contain parsed web text
   -- print parsedWeb

   --INDEXER--

   --PAGE RANK--

   putStrLn "Done!"
