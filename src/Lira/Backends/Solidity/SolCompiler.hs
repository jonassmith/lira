{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Lira.Backends.Solidity.SolCompiler where

import           NeatInterpolation
import           Data.Text (Text)
import           Control.Monad.Reader
import           Lira.Contract.Intermediate

assemble :: IntermediateContract -> Text
assemble intermediateContract = contract

headContract :: Text
headContract = [text| |]

activate :: Text
activate = [text|function activate() {

}|]

execute :: Text
execute = [text|function execute() {

}|]

contract :: Text
contract = [text|pragma solidity ^0.6.4;

contract Contract1 {
  $headContract

  $activate

  $execute
  }
}|]
