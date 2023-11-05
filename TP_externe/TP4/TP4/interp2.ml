open Ast

type native = value list -> value

type env_value =
  | V of value
  | N of native

let baselib = Env.add "%add"
  (N (function [ Int a ; Int b ] -> Int (a + b)
  | _ -> failwith "ERROR")) (* should never happen *)
  Env.empty