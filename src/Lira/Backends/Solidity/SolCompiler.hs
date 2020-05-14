module Lira.Backends.Solidity.SolCompiler where

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

import NeatInterpolation
import Data.Text (Text)

assemble :: Text
assemble = contract

head :: Text
head = [text|test1|]

activate :: Text
activate = [text|test2|]

execute :: Text
execute = [text|test3|]

contract :: Text
contract = [text|pragma solidity ^0.6.4;

contract Contract1 {
  $head

  $activate

  $execute
  }
}|]
