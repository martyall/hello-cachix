import qualified Data.Aeson as A
import Foo (Foo)
import Test.Hspec (describe, hspec, it)
import Test.QuickCheck
import Test.QuickCheck (property)

main :: IO ()
main = hspec $ do
  describe "Basic Foo Properties" $ do
    it "prop_codec" $ property prop_codec

prop_codec :: [Foo] -> Bool
prop_codec xs = traverse (A.eitherDecode . A.encode) xs == Right xs
