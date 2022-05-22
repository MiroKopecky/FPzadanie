module Indexer
    ( makeResultsByQuery
    ) where

import Data.String
--import Data.String.UTF8
--import Data.ByteString as B
--import Data.ByteString.UTF8 as BSU
import Data.Map (Map)
import qualified Data.Map as Map
import Data.List.Split
import Data.List
import Data.Maybe
import Data.Function (on)
import Data.List (sortBy)
import Data.Text(Text, pack)


query a = splitOn " " a

queryPacker a = Prelude.map(\x -> pack(x)) a

risearch2 :: Text -> Map Text [Text] -> Maybe [Text]
risearch2 a m = Map.lookup a m

risearch :: [Text] -> Map Text [Text] -> [Maybe [Text]]
risearch a m = Prelude.map (\x -> risearch2 x m) a

invert :: Ord v => Map k [v] -> Map v [k]
invert m = Map.fromListWith (++) pairs
    where pairs = [(v, [k]) | (k, vs) <- Map.toList m, v <- vs]

fnc2 a b = Map.insert a b Map.empty

fnc a = Prelude.map (\x -> fnc2 (fst x) (snd x)) a

merge xs     []     = xs
merge []     ys     = ys
merge (x:xs) (y:ys) = x : y : merge xs ys

getArr a = Prelude.map (\e1 e2 -> merge e1 e2) a

printSearchResults2 a = do
    print (fst a)

getSiteNames a = Prelude.map (\x -> fst(x)) a

printSearchResults a = do
    mapM_ print a

ignore_third2 (x, y, _) = (x, y)

ignore_third a = Prelude.map (\x -> ignore_third2 x) a

makeResultsByQuery x = do
    let i = ignore_third x
    let mi = Map.unions (fnc i)
    let ri = invert mi

    --print (head (Map.keys ri))
    print("-----------------------------------   ZADAJ VSTUP  -----------------------------------")
    user_input <- Prelude.getLine
    let q = queryPacker( query user_input )
    --let q = [pack "pandemia"]

    let ris = risearch q ri
    --print ris

    let ris_con = Data.List.concat (Just ris)
    let ris_con_cat = catMaybes ris_con
    let ris_con_cat_cat = Data.List.concat (ris_con_cat)

    let groups = Data.List.group (Data.List.sort ris_con_cat_cat)
    let groups_sorted = Data.List.sortOn (Data.List.length) groups

    let groups_sorted_toupled = Prelude.map (\x -> (Data.List.head (nub x), Data.List.length x)) groups_sorted
    let groups_sorted_toupled_sorted = Data.List.reverse( sortBy (compare `on` snd) groups_sorted_toupled )
    print("----------------------------------- SEARCH RESULTS -----------------------------------")
    let sitenames = getSiteNames(groups_sorted_toupled_sorted)
    printSearchResults(sitenames)
    --return()