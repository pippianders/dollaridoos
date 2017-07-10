{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Data.Money
  (
    Money(Money)
  , money
  , ($+$)
  , ($-$)
  , (*$)
  , ($*)
  , ($/)
  , ($/$)
  , ($^)
  , ($^^)
  , ($**)
  ) where

import Control.Lens (_Wrapped, Iso, iso, over, view)
import Data.Monoid (Monoid, Sum(Sum))
import Data.Semigroup (Semigroup, (<>))

-- | A representation of monetary values.
--
--   The @Semigroup@ instance allows amounts of money to be added together.
--
--   Any num instances present are hidden, as multiplying money by money,
--   for example, doesn't make any sense.
newtype Money num = Money (Sum num)
                    deriving (Semigroup, Monoid, Eq, Ord)

instance Show num => Show (Money num) where
  show m = '$': (show $ view money m)

-- | The raw numeric value inside monetary value
money :: Iso (Money a) (Money b) a b
money = iso (\(Money a) -> a) Money . _Wrapped

infixl 6 $+$
($+$) :: Num a => Money a -> Money a -> Money a
($+$) = (<>)

infixl 6 $-$
($-$) :: Num a => Money a -> Money a -> Money a
($-$) n m = over money (subtract (view money m)) n

infixr 7 *$
(*$) :: Num a => a -> Money a -> Money a
(*$) = over money . (*)

infixl 7 $*
($*) :: Num a => Money a -> a -> Money a
($*) = flip (*$)

infixl 7 $/
($/) :: Fractional a => Money a -> a -> Money a
($/) m x = over money (/x) m

infixl 7 $/$
($/$) :: Fractional a => Money a -> Money a -> a
($/$) n m = view money n / view money m

infixr 8 $^
($^) :: (Num a, Integral b) => Money a -> b -> Money a
($^) m x = over money (^x) m

infixr 8 $^^
($^^) :: (Fractional a, Integral b) => Money a -> b -> Money a
($^^) m x = over money (^^x) m

infixr 8 $**
($**) :: Floating a => Money a -> a -> Money a
($**) m x = over money (**x) m

