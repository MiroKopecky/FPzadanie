{-# START_FILE Main.hs #-}
{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}

module Main where

import System.IO (openFile, IOMode (WriteMode), hPutStrLn)
import Parser
import Data.Text
import GHC.Generics
import Data.Aeson.Types (parseJSON)
import Data.Aeson
import Control.Applicative
import Control.Monad






data Pages =
  Pages {url :: !Text, html_content :: !Text} deriving (Show,Generic)


instance FromJSON Pages
instance ToJSON Pages




main :: IO ()
main = do
   --PARSING--
   --let fileName = "data/output.json" -- After complete parser change filename for "data/collection.jl" instead "data/output.jl"
   --parsedWeb <- Parser.parseWebSite fileName -- parsedWeb - contain parsed web text--
   d <- (eitherDecode <$> getJSON) :: IO (Either String [Pages])
   case d of
     Left err -> putStrLn err
     Right pages -> do
      -- pages je pole datovych tried [Pages]
       print . html_content $ Prelude.head pages
       
    -- If d is Left, the JSON was malformed.
    -- In that case, we report the error.
    -- Otherwise, we perform the operation of
    -- our choice. In this case, just print it.
  
   putStrLn $ "Decode: " ++ (show (decode "{ \"url\": \"example.com\", \"html_content\": \"<div>asdf</div>\" }" :: Maybe Pages))

   --INDEXER--

   --PAGE RANK--

   putStrLn "Done!"
