{-# START_FILE Main.hs #-}
{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}

module Main where

import System.IO (openFile, IOMode (WriteMode), hPutStrLn, hGetLine, IOMode(ReadMode) )
import Parser
import Indexer
import Data.Text(Text, strip, splitOn, words, unpack, replace, length)
import GHC.Generics
import Data.Aeson.Types (parseJSON)
import Data.Aeson
import Control.Applicative
import Control.Monad

import Text.HTML.Scalpel
import Control.Applicative
--import Data.Text as TS
import Data.Typeable
import Data.List

import qualified Data.ByteString.Lazy as B
import Data.Map (Map)
import qualified Data.Map as Map


data Page =
  Page {url :: !Text, html_content :: !Text} deriving (Show,Generic)

pattern = ["\237", "\231", "\227", "\243", "\225", "\250", "\245", "\233", "\234", "\224", "\244", "\205", "\186", "\226", "\211", "\193", "\218","<div", "<li>", "</li>",
            "</div>", "</a>", "{{/pageLink}}", "<li", "<span>", "</ul>", "<a", "<img", "<span", "</span>", "<form", "<ul", "<figure", "</figure>", "<h2>", "</h2>",
            "</form>", "<fieldset>", "</fieldset>", "<input", "{{/hasImage}}", "{{#items}}", "<button", "{{time}}", "{{#hasImage}}", "{{/isLogged}}", "{{^isLogged}}",
            "{{#docs}}", "{{#imagem}}"] 

instance FromJSON Page where
   parseJSON (Object v) = do
      url <- v .: "url"
      html_content <- v .: "html_content"
      return (Page {url = url, html_content = html_content})
   parseJSON _ = Control.Applicative.empty
instance ToJSON Page

convertLinks :: [[Text]] -> [Map Text Int]
convertLinks [] = []
convertLinks (x:xs) = do
   let emptyMap = Map.empty
   let newMap = (Map.insert (head x) (Data.List.length x) emptyMap)
   newMap : (convertLinks xs)

parsePage :: [B.ByteString] -> [(Text, [Text], [Map Text Int])]
parsePage [] = []
parsePage (x:xs) = do
   let decodedPage = decode x :: Maybe Page
   case decodedPage of
      Nothing -> (parsePage xs)
      Just decodedPage -> do
         let scrapedHrefs = scrapeStringLike (html_content $ decodedPage) (attrs "href" "a")
         let scrapedDivs = scrapeStringLike (html_content $ decodedPage) (texts(tagSelector "div"))
         case scrapedDivs of
           Nothing -> (parsePage xs)
           Just x -> do
             let pageUrl = url decodedPage
             let parsedText = parseText x pattern
             case scrapedHrefs of
                Nothing -> (parsePage xs)
                Just x -> do
                  let pageLinks = Data.List.group (Data.List.sort x)
                  let parsedPageLinks = (convertLinks pageLinks)
                  let parsedPage = (pageUrl, parsedText, parsedPageLinks)
                  parsedPage : parsePage xs

infLoop x = do
   --l <- getLine  
   makeResultsByQuery x 
   infLoop x

main :: IO ()
main = do
   --PARSING--
   content <- getJSON
   let splitContent = (B.split 10 content)

   let parsedSplitContent = parsePage splitContent
   ---print (head parsedSplitContent)
   --print parsedSplitContent

   --INDEXER--
   ---makeResultsByQuery parsedSplitContent
   infLoop parsedSplitContent

   --PAGE RANK--
   putStrLn "Done!"
