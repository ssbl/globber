module Globber (matchGlob) where

import           AParser    (runParser)
import           GlobParser (Token (..), anyChar, parsePattern, setToList)

import           Data.Maybe (fromJust, isJust)

type GlobPattern = String

matchGlob :: GlobPattern -> String -> Bool
matchGlob p = let pp = parsePattern p
              in
                if isJust pp then go (fromJust pp) else const False
    where go [Eof] []        = True
          go [Eof] _         = False
          go [Many,Eof] []   = True
          go _ []            = False
          go (x:xs) t@(y:ys) = case x of
                           U c  -> (c == y) && go xs ys
                           S cs -> elem y (setToList cs) && go xs ys
                           Any  -> if isJust (runParser anyChar t)
                                   then go xs ys else False
                           Many -> if go xs t then True else go (x:xs) ys
