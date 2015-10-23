module GlobParser where

import           AParser
import           Control.Applicative

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

flnotElem = flip notElem

escape :: String -> Parser Char
escape xs = char '\\' *> (satisfy (flip elem xs) <|> char '\\')

anyExcept :: String -> Parser Char
anyExcept reserved = escape reserved <|> satisfy (flnotElem reserved)

setChar :: Parser Char
setChar = anyExcept "]"

anyChar :: Parser Char
anyChar = anyExcept "[?*"

parseRange :: Parser SetToken
parseRange = (\x _ y -> Range x y) <$> anyChar <*> char '-' <*> anyChar

set :: Parser Set
set = char '[' *> some (parseRange <|> Single <$> setChar) <* char ']'

parseAny :: Parser Token
parseAny = Any <$ char '?'

parseMany :: Parser Token
parseMany = Many <$ char '*'

parseToken :: Parser Token
parseToken = (S <$> set) <|> parseAny <|> parseMany <|> (U <$> anyChar)

parsePattern :: String -> Maybe [Token]
parsePattern [] = Just [Eof]
parsePattern p  = case runParser parseToken p of
                   Just (x, rest) -> (:) <$> Just x <*> parsePattern rest
                   _              -> Nothing

setToList :: Set -> String
setToList []                 = []
setToList (Single x : xs)    = x : setToList xs
setToList (Range x1 x2 : xs) = [x1..x2] ++ setToList xs
