import qualified Data.Aeson as A
import Bar (Bar)
import Test.Hspec (describe, hspec, it)
import Test.QuickCheck
import Test.QuickCheck (property)

main :: IO ()
main = hspec $ do
  describe "Basic Bar Properties" $ do
    it "prop_codec" $ property prop_codec
    it "dummy tesT" $ property True

prop_codec :: [Bar] -> Bool
prop_codec xs = traverse (A.eitherDecode . A.encode) xs == Right xs
