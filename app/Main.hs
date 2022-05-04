module Main where

import System.IO ()
import Parser ( parseWebSite )

main :: IO ()
main = do
   --PARSING--
   let fileName = "data/output.jl" -- After complete parser change filename for "data/collection.jl" instead "data/output.jl"
   parsedWeb <- Parser.parseWebSite fileName -- parsedWeb - contain parsed web text
   print parsedWeb

   --INDEXER--

   --PAGE RANK--

   putStrLn "Done!"
