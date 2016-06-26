{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}


module Imprecise ( Imprecise(..) ) where

import Data.Complex ( Complex(..) )
import Foreign.C.Types ( CDouble, CFloat )
import Numeric.IEEE ( epsilon )


class Ord (Precision a) => Imprecise a where
    type Precision a
    precision :: a -> Precision a
    limiting :: a -> Precision a
    scale :: Precision a -> a -> a


instance Imprecise Double where
    type Precision Double = Double
    precision x = abs x * epsilon
    limiting = abs
    scale = (*)


instance Imprecise Float where
    type Precision Float = Float
    precision x = abs x * epsilon
    limiting = abs
    scale = (*)


instance Imprecise CDouble where
    type Precision CDouble = CDouble
    precision x = abs x * epsilon
    limiting = abs
    scale = (*)


instance Imprecise CFloat where
    type Precision CFloat = CFloat
    precision x = abs x * epsilon
    limiting = abs
    scale = (*)


instance (Floating (Precision a), Imprecise a) => Imprecise (Complex a) where

    type Precision (Complex a) = Precision a

    precision (re :+ im) =
        let
            pr = precision re
            pi = precision im
        in
          sqrt (pr * pr + pi * pi)

    limiting (re :+ im) =
        let
            lr = limiting re
            li = limiting im
        in
          sqrt (lr * lr + li * li)

    scale a (re :+ im) = scale a re :+ scale a im