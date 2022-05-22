{-# START_FILE Main.hs #-}
{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}

module Main where

import System.IO (openFile, IOMode (WriteMode), hPutStrLn, hGetLine, IOMode(ReadMode) )
import Parser
import Data.Text(Text, strip, splitOn, words, unpack, replace, length)
import GHC.Generics
import Data.Aeson.Types (parseJSON)
import Data.Aeson
import Control.Applicative
import Control.Monad

import Text.HTML.Scalpel
import Control.Applicative
import Data.Text as TS
import Data.Typeable

import qualified Data.ByteString.Lazy as B

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

parsePage :: [B.ByteString] -> [[Text]]
parsePage [] = []
parsePage (x:xs) = do
   let decodedPage = decode x :: Maybe Page
   case decodedPage of
      Nothing -> (parsePage xs)
      Just decodedPage -> do
         let scrapedDivs = scrapeStringLike (html_content $ decodedPage) (texts(tagSelector "div"))
         case scrapedDivs of
           Nothing -> (parsePage xs)
           Just x -> do
             let parsedText = parseText x pattern
             parsedText : parsePage xs

--https://hackage.haskell.org/package/scalpel-0.6.2/docs/Text-HTML-Scalpel.html

getUrl a = ((url a), scrapeStringLike (html_content a) (texts(tagSelector "div")))

getPageContent a = Prelude.map (\x -> getUrl x) a

parsingText a = parseText a pattern

getParsed a = Prelude.map (parsingText) a

main :: IO ()
main = do
   --PARSING--
   content <- getJSON
   let splitContent = (B.split 10 content)

   print splitContent
   --TODO: splitContent need transform from '[B.ByteString]' to '[Page]'

   {-
   -- TODO: Rework this code for .jl file
   let scrapedDivs = getPageContent splitContent
   print scrapedDivs
   putStrLn ""
   
  
   case (snd (Prelude.head scrapedDivs)) of
    Nothing -> putStrLn "err"
    Just x -> do
      let t = TS.pack $ Prelude.head x
      let parsedText = getParsed [[t]]
      print parsedText
  -}

   -- vypise naparsovanu prvu stranku
   -- print (head (parsePage splitContent))

   --INDEXER--

   --PAGE RANK--
   putStrLn "Done!"
