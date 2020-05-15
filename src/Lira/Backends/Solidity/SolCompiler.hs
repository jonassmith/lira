{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Lira.Backends.Solidity.SolCompiler where

import           NeatInterpolation
import           Data.Text (Text)
import           Control.Monad.Reader
import           Lira.Contract.Intermediate
import           Lira.TypeChecker
import           Control.Monad

assemble :: IntermediateContract -> Text
assemble intermediateContract = contract intermediateContract

headContract :: Text
headContract = [text| |]

activate :: IntermediateContract -> Text
activate ic = transferCalls' (getTransferCalls ic)
  where
    transferCalls' :: [TransferCall] -> Text
    transferCalls' text = ""
    transferCalls' (tc:tcs) = [text|common_token.transferFrom(${_from tc}, address(this), ${_amount tc})\n|] <> transferCalls' tcs

execute :: IntermediateContract -> Text
execute ic = transferCalls' (getTransferCalls ic)
  where
    transferCalls' :: [TransferCall] -> Text
    transferCalls' text = ""
    transferCalls' (tc:tcs) = [text|common_token.transfer(${_to tc}, ${_amount tc})\n|] <> transferCalls' tcs

contract :: IntermediateContract -> Text
contract ic = [text|pragma solidity ^0.6.4;

contract Contract1 {
  $headContract

  ${activate ic}

  ${execute ic}
  }
}|]
