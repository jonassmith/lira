module Lira.Backends.Solidity.SolCompiler where

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

import NeatInterpolation
import Data.Text (Text)

assemble :: Text
assemble = contract

head :: Text
head = [trimming|test1|]

activate :: Text
activate = [trimming|test2|]

execute :: Text
execute = [trimming|test3|]

contract :: Text
contract = [trimming|pragma solidity ^0.6.4;

contract Contract1 {
  $head

  $activate

  $execute
  }
}|]
