module Foo (someFunc, Foo (..)) where

import qualified Data.Aeson as A
import GHC.Generics (Generic)
import Test.QuickCheck (Arbitrary)
import Test.QuickCheck.Arbitrary.Generic (GenericArbitrary (..))

someFunc :: IO ()
someFunc = putStrLn "someFunc"

data Foo = Foo
  { foo1 :: Int,
    foo2 :: String
  }
  deriving stock (Eq, Show, Generic)
  deriving (Arbitrary) via (GenericArbitrary Foo)

instance A.ToJSON Foo

instance A.FromJSON Foo
