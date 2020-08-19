{-# LANGUAGE CPP #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE FlexibleContexts #-}
-- |
-- Module      : Data.Array.Accelerate.Numeric.Sum.LLVM.Native
-- Copyright   : [2017] Trevor L. McDonell
-- License     : BSD3
--
-- Maintainer  : Trevor L. McDonell <tmcdonell@cse.unsw.edu.au>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--

module Data.Array.Accelerate.Numeric.Sum.LLVM.Native (

  fadd, fsub, fmul,

) where

import Data.Array.Accelerate                                        as A
import Data.Array.Accelerate.Type
import qualified Data.Array.Accelerate.Sugar.Elt                    as Sugar

#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
import Data.Array.Accelerate.LLVM.CodeGen.Sugar
import Data.Array.Accelerate.LLVM.Native.Foreign                    as A
import qualified Data.Array.Accelerate.Numeric.Sum.LLVM.Prim        as Prim
#endif

#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
wrap2 :: (Elt a, Elt b, Elt c)
      => String                                                 -- name of the operation
      -> IRFun1 Native () (Sugar.EltR (a, b) -> Sugar.EltR c)   -- foreign implementation
      -> (Exp a -> Exp b -> Exp c)                              -- fallback implementation
      -> Exp a
      -> Exp b
      -> Exp c
wrap2 str f g = A.curry (foreignExp (ForeignExp str f) (A.uncurry g))
#endif

fadd :: forall a . (IsFloating (Sugar.EltR a), Elt a) => (Exp a -> Exp a -> Exp a) -> Exp a -> Exp a -> Exp a
#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
fadd = wrap2 "fadd" (Prim.fadd @a floatingType)
#else
fadd = id
#endif

fsub :: forall a . (IsFloating (Sugar.EltR a), Elt a) => (Exp a -> Exp a -> Exp a) -> Exp a -> Exp a -> Exp a
#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
fsub = wrap2 "fsub" (Prim.fsub @a floatingType)
#else
fsub = id
#endif

fmul :: forall a . (IsFloating (Sugar.EltR a), Elt a) => (Exp a -> Exp a -> Exp a) -> Exp a -> Exp a -> Exp a
#ifdef ACCELERATE_LLVM_NATIVE_BACKEND
fmul = wrap2 "fmul" (Prim.fmul @a floatingType)
#else
fmul = id
#endif

