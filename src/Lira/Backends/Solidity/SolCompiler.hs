module Lira.Backends.Solidity.SolCompiler where

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

import Data.Text (Text)
import Text.RawString.QQ (r)
import NeatInterpolation (text)

assemble :: IntermediateContract -> Text
assemble = contract

head :: Text
head = [r|test1|]

activate :: Text
activate = [r|test2|]

execute :: Text
execute = [r|test3|]

contract :: Text
contract = [r|pragma solidity ^0.6.4;

contract Contract1 {
  ${head}

  ${activate}

  ${execute}
  }
}|]
