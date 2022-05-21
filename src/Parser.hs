module Parser
    ( loadFile
    , jsonFile
    , getJSON
    , parseWebSite
    , ignoreLongWords
    , replaceWithBlank
    , parseText
    ) where


import System.IO ( hGetLine, openFile, IOMode(ReadMode) )
import qualified Data.ByteString.Lazy as B
import Data.Text(Text, strip, splitOn, words, unpack, replace, length, pack)

{-
    TODO:
        - parsing each web page
-}

ignoreLongWords :: [Text] -> [Text]
ignoreLongWords [] = []
ignoreLongWords (x:xs) = if (Data.Text.length x) > 14 then ignoreLongWords xs else x:(ignoreLongWords xs) 

replaceWithBlank :: [Text] -> Text -> Text
replaceWithBlank [] y = y
replaceWithBlank (x:xs) y = replaceWithBlank xs (replace x (pack " ") y)

parseText :: [Text] -> [Text]-> [Text]
parseText [] _ = []
parseText (x:xs) y = (ignoreLongWords $ Data.Text.words $ replaceWithBlank y x) ++ (parseText xs y)

loadFile :: FilePath -> IO B.ByteString
loadFile = B.readFile

jsonFile :: FilePath
jsonFile = "data/output.json"

getJSON :: IO B.ByteString
getJSON = B.readFile jsonFile


-- Main function for parsing web data
parseWebSite :: FilePath -> IO String
parseWebSite fileName = do
    -- Load file
    fileText <- openFile fileName ReadMode
    fileName <- System.IO.hGetLine fileText
    print "Parser - Done!"

    return fileName



    ---For writing text
    --secondLine <- hGetLine helloFile
    --goodbyeFile <- openFile "data/goodbye.txt" WriteMode
    --hPutStrLn goodbyeFile secondLine
    --hClose helloFile
    --hClose goodbyeFile