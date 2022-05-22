module CsvManager where

--writeToCsv :: [(String, Int)] -> IO ()
writeToCsv (x) = do
    writeFile "indexer.csv" (writeLine x)
        where
            writeLine x = foldl (\f dt -> f ++ show dt ++ "\n") "" (x)