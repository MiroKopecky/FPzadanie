module Parser
    ( loadFile
    , jsonFile
    , getJSON
    , parseWebSite
    ) where


import System.IO ( hGetLine, openFile, IOMode(ReadMode) )
import qualified Data.ByteString.Lazy as B

{-
    TODO:
        - parsing each web page
-}

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