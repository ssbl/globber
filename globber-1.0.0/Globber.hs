module Globber (matchGlob) where

import           AParser
import           GlobParser

type GlobPattern = String

matchGlob :: GlobPattern -> String -> Bool
matchGlob p s = go (parsePattern p) s
    where go [Eof] []        = True
          go [Eof] _         = False
          go [Many,Eof] []   = True
          go _ []            = False
          go (x:xs) t@(y:ys) = case x of
                           U c  -> (c == y) && go xs ys
                           S cs -> (elem y $ setToList cs) && go xs ys
                           Any  -> case runParser anyChar t of
                                     Nothing -> False
                                     _       -> go xs ys
                           Many -> case go xs t of
                                     False -> go (x:xs) ys
                                     _     -> True



