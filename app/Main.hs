{-# START_FILE Main.hs #-}
{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}

module Main where

import System.IO (openFile, IOMode (WriteMode), hPutStrLn)
import Parser
import Data.Text(Text, strip, splitOn, words, unpack, replace, length)
import GHC.Generics
import Data.Aeson.Types (parseJSON)
import Data.Aeson
import Control.Applicative
import Control.Monad

import Text.HTML.Scalpel
import Control.Applicative


data Page =
  Page {url :: !Text, html_content :: !Text} deriving (Show,Generic)

pattern = ["\237", "\231", "\227", "\243", "\225", "\250", "\245", "\233", "\234", "\224", "\244", "\205", "\186", "\226", "\211", "\193", "<div", "<li>", "</li>",
            "</div>", "</a>", "{{/pageLink}}", "<li", "<span>", "</ul>", "<a", "<img", "<span", "</span>", "<form", "<ul", "<figure", "</figure>"] 

instance FromJSON Page
instance ToJSON Page


main :: IO ()
main = do
   --PARSING--
   --let fileName = "data/output.json" -- After complete parser change filename for "data/collection.jl" instead "data/output.jl"
   --parsedWeb <- Parser.parseWebSite fileName -- parsedWeb - contain parsed web text--
   d <- (eitherDecode <$> getJSON) :: IO (Either String [Page])

   case d of
     Left err -> putStrLn err
     Right pages -> do
      -- pages je pole datovych tried [Pages]
       --print . html_content $ Prelude.head pages
      let scrapedDivs = scrapeStringLike (html_content $ head pages) (texts(tagSelector "div"))

      case scrapedDivs of
        Just x -> print $ parseText x pattern
        Nothing -> putStrLn "err"

      --print Prelude.concatMap (splitOn " ") (Prelude.head scrapedDivs)
    -- If d is Left, the JSON was malformed.
    -- In that case, we report the error.
    -- Otherwise, we perform the operation of
    -- our choice. In this case, just print it.
  

   --INDEXER--

   --PAGE RANK--

   putStrLn "Done!"
