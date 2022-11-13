module Main where

import qualified Foo (someFunc)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  Foo.someFunc
