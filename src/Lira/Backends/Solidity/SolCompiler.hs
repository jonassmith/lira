{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Lira.Backends.Solidity.SolCompiler where

import NeatInterpolation
import Data.Text (Text)

assemble :: Text
assemble = contract

headContract :: Text
headContract = [text|test1|]

activate :: Text
activate = [text|test2|]

execute :: Text
execute = [text|test3|]

contract :: Text
contract = [text|pragma solidity ^0.6.4;

contract Contract1 {
  $headContract

  $activate

  $execute
  }
}|]
