module Parser
    ( parseWebSite
    ) where

import System.IO ( hGetLine, openFile, IOMode(ReadMode) )

{-
    TODO:
        - parsing each web page
-}


-- Main function for parsing web data
parseWebSite :: FilePath -> IO String
parseWebSite fileName = do
    -- Load file
    fileText <- openFile fileName ReadMode
    fileName <- hGetLine fileText
    print "Parser - Done!"

    return fileName



    ---For writing text
    --secondLine <- hGetLine helloFile
    --goodbyeFile <- openFile "data/goodbye.txt" WriteMode
    --hPutStrLn goodbyeFile secondLine
    --hClose helloFile
    --hClose goodbyeFile