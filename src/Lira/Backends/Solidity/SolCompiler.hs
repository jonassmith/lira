{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Lira.Backends.Solidity.SolCompiler where

import           NeatInterpolation
import           Data.Text (Text)
import           Control.Monad.Reader
import           Lira.Contract.Intermediate
import           Lira.TypeChecker
import           Control.Monad
import           Lira.Contract
import qualified Data.Text as Text
import           Data.Text.Conversions

assemble :: IntermediateContract -> Text
assemble intermediateContract = contract intermediateContract

headContract :: Text
headContract = [text| |]

activate :: IntermediateContract -> Text
activate ic = "function activate() {\n" <> transferCalls' (getTransferCalls ic)
  where
    transferCalls' :: [TransferCall] -> Text
    transferCalls' [] = ""
    transferCalls' (tc:tcs) = [text|common_token.transferFrom($fromPortion, address(this), $maxAmountPortion)|] <> "\n" <> transferCalls' tcs
      where
        fromPortion = Text.pack (show (_from tc))
        maxAmountPortion = Text.pack (show (_maxAmount tc))

execute :: IntermediateContract -> Text
execute ic = "function execute() {\n" <> transferCalls' (getTransferCalls ic)
  where
    transferCalls' :: [TransferCall] -> Text
    transferCalls' [] = ""
    transferCalls' (tc:tcs) = [text|common_token.transfer($toPortion, $amountPortion)|] <> "\n" <> transferCalls' tcs
      where
        toPortion = Text.pack (show (_to tc))
        amountPortion = ppSolExpr (_amount tc)

ppSolExpr :: Expr -> Text
ppSolExpr (Lit e1) = ppSolLiteral e1
ppSolExpr (MinExp e1 e2) =
  let s1 = ppSolExpr e1
      s2 = ppSolExpr e2
  in Text.concat [ "((", s1, " < ", s2, ") ? (", s1, ") : (", s2, "))" ]
ppSolExpr (MaxExp e1 e2) =
  let s1 = ppSolExpr e1
      s2 = ppSolExpr e2
  in Text.concat [ "((", s1, " > ", s2, ") ? (", s1, ") : (", s2, "))" ]
ppSolExpr (MultExp e1 e2) = "(" <> ppSolExpr e1 <> " * " <> ppSolExpr e2 <> ")"
ppSolExpr (DiviExp e1 e2) = "(" <> ppSolExpr e1 <> " / " <> ppSolExpr e2 <> ")"
ppSolExpr (AddiExp e1 e2) = "(" <> ppSolExpr e1 <> " + " <> ppSolExpr e2 <> ")"
ppSolExpr (SubtExp e1 e2) = "(" <> ppSolExpr e1 <> " - " <> ppSolExpr e2 <> ")"
ppSolExpr (LtExp e1 e2) = "(" <> ppSolExpr e1 <> " > " <> ppSolExpr e2 <> ")"
ppSolExpr (GtExp e1 e2) = "(" <> ppSolExpr e1 <> " < " <> ppSolExpr e2 <> ")"
ppSolExpr (EqExp e1 e2) = "(" <> ppSolExpr e1 <> " == " <> ppSolExpr e2 <> ")"
ppSolExpr (GtOrEqExp e1 e2) = "(" <> ppSolExpr e1 <> " <= " <> ppSolExpr e2 <> ")"
ppSolExpr (LtOrEqExp e1 e2) = "(" <> ppSolExpr e1 <> " >= " <> ppSolExpr e2 <> ")"
ppSolExpr (NotExp e1) = "(!" <> ppSolExpr e1 <> ")"
ppSolExpr (AndExp e1 e2) = "(" <> ppSolExpr e1 <> " && " <> ppSolExpr e2 <> ")"
ppSolExpr (OrExp e1 e2) = "(" <> ppSolExpr e1 <> " || " <> ppSolExpr e2 <> ")"
ppSolExpr (IfExp e1 e2 e3) = "((" <> ppSolExpr e1 <> ") ? (" <> ppSolExpr e2 <> ") : (" <> ppSolExpr e2 <> "))"

ppSolLiteral :: Literal -> Text
ppSolLiteral (IntVal e1) = convertText (show e1)
ppSolLiteral (BoolVal e1) = boolToString e1
-- TODO: Observerables
-- ppSolLiteral (e1 e2 e3 e4 e5) =

boolToString :: Bool -> Text
boolToString True = "True"
boolToString False = "False"

contract :: IntermediateContract -> Text
contract ic = [text|pragma solidity ^0.6.4;

contract Contract1 {
  $headContract

  $activatePortion
  }
  $executePortion
  }
}|]
  where
    activatePortion = activate ic
    executePortion = execute ic
