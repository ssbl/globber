module Globber (matchGlob) where

import           AParser
import           GlobParser

type GlobPattern = String

matchGlob :: GlobPattern -> String -> Bool
matchGlob p = go (parsePattern p)
    where go [Eof] []        = True
          go [Eof] _         = False
          go [Many,Eof] []   = True
          go _ []            = False
          go (x:xs) t@(y:ys) = case x of
                           U c  -> (c == y) && go xs ys
                           S cs -> elem y (setToList cs) && go xs ys
                           Any  -> case runParser anyChar t of
                                     Nothing -> False
                                     _       -> go xs ys
                           Many -> if go xs t then True else go (x:xs) ys
