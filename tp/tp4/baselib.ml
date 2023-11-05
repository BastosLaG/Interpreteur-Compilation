open Ast

module Env = Map.Make(String)

type native = value list -> value

type env_value = 
  | v of value
  | n of native

let baselib = Env.add"%add"
                (N (function[ Int a ; Int b ] -> Int (a + b)
                    | _ -> failwith "ERROR"))
                Env.empty
