{-# LANGUAGE QuasiQuotes #-}

import Text.RawString.QQ

head :: String
head = [|test|]

activate :: String
activate = [|test|]

execute :: String
execute = [|test|]

contract :: String
contract = [r|<HTML>
<HEAD>
<TITLE>Auto-generated html formated source</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1252">
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080" BGCOLOR="#ffffff">
<P> </P>
<PRE>|]