module Bar (Bar, someFunc) where

import qualified Data.Aeson as A
import Foo (Foo)
import GHC.Generics (Generic)
import Test.QuickCheck (Arbitrary)
import Test.QuickCheck.Arbitrary.Generic (GenericArbitrary (..))

someFunc :: IO ()
someFunc = putStrLn "someFunc"

data Bar = Bar
  { bar1 :: Int,
    bar2 :: Foo
  }
  deriving stock (Eq, Show, Generic)
  deriving (Arbitrary) via (GenericArbitrary Bar)

instance A.ToJSON Bar

instance A.FromJSON Bar
