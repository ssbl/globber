module Main (main) where

import           Test.Hspec

import           Globber

main :: IO ()
main = hspec $ describe "Testing Globber" $ do

    describe "empty pattern" $ do
      it "matches empty string" $
        matchGlob "" "" `shouldBe` True
      it "shouldn't match non-empty string" $
        matchGlob "" "string" `shouldBe` False

    describe "simple pattern" $ do
      it "single chars and char sets" $
         matchGlob "foo[0-9]" "foo9" `shouldBe` True
      it "should not match" $
         matchGlob "foo[a-z]" "foo9" `shouldBe` False

    describe "pattern with ?" $ do
      it "matches any char" $
         matchGlob "?" "a" `shouldBe` True
      it "should not match" $
         matchGlob "?" "bar" `shouldBe` False

    describe "pattern with *" $ do
      it "matches any string" $
         matchGlob "*" "hello" `shouldBe` True
      it "matches empty string" $
         matchGlob "*" "" `shouldBe` True

    describe "real patterns" $ do
      it "should match" $
         matchGlob "foo*" "foobarbar" `shouldBe` True
      it "should match" $
         matchGlob "*bar*" "foobarbar" `shouldBe` True
      it "should match" $
         matchGlob "*[0-9_\\?]*" "hello0there" `shouldBe` True
      it "should match" $
         matchGlob "*bar" "foobarbar" `shouldBe` True
      it "invalid pattern" $
         matchGlob "[0-9?]" "asd" `shouldBe` False
