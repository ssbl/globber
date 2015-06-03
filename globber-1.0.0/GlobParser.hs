module GlobParser where

import           AParser
import           Control.Applicative
import           Data.Char

data SetToken = Single Char
              | Range Char Char
                deriving Show

type Set = [SetToken]

data Token = U Char
           | S Set
           | Any
           | Many
           | Eof
             deriving Show

escape :: Parser Char
escape = char '\\' *> (satisfy isPrint)

single :: Parser Char
single = satisfy f
    where f x = case x of
                  ']' -> False
                  '[' -> False
                  '?' -> False
                  '*' -> False
                  _   -> True

anyChar :: Parser Char
anyChar = (escape <|> single)

parseRange :: Parser SetToken
parseRange = (\x _ y -> Range x y) <$> anyChar <*> char '-' <*> anyChar

set :: Parser Set
set = char '[' *> some (parseRange <|> Single <$> anyChar) <* char ']'

parseAny :: Parser Token
parseAny = Any <$ char '?'

parseMany :: Parser Token
parseMany = Many <$ char '*'

parseToken :: Parser Token
parseToken = (U <$> anyChar) <|> parseAny <|> parseMany <|> (S <$> set)

parsePattern :: String -> [Token]
parsePattern p = case runParser parseToken p of
                   Nothing        -> [Eof]
                   Just (x, rest) -> x : parsePattern rest

setToList :: Set -> String
setToList []                   = []
setToList ((Single x) : xs)    = x : setToList xs
setToList ((Range x1 x2) : xs) = [x1..x2] ++ setToList xs
