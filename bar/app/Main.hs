module Main where

import qualified Bar (someFunc)

main :: IO ()
main = do
  putStrLn "Hello, Bar Haskell!"
  Bar.someFunc
