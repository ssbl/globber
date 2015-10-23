module Globber (matchGlob) where

import           AParser    (runParser)
import           GlobParser (Token (..), anyChar, parsePattern, setToList)

import           Data.Maybe (isJust)

type GlobPattern = String

matchGlob :: GlobPattern -> String -> Bool
matchGlob p = maybe (const False) go (parsePattern p)
    where go [Eof] []        = True
          go [Eof] _         = False
          go [Many,Eof] _    = True
          go _ []            = False
          go (x:xs) t@(y:ys) = case x of
                           U c  -> (c == y) && go xs ys
                           S cs -> elem y (setToList cs) && go xs ys
                           Any  -> isJust (runParser anyChar t) && go xs ys
                           Many -> go xs t || go (x:xs) ys
