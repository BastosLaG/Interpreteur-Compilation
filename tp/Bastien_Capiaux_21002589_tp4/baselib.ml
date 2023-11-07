(* Baselib *)
module Env = Map.Make(String)
let baselib = Env.add "%add" (fun a b -> a + b) Env.empty

open Ast

type native = value list -> value
    
type env_value = 
  | V of value
  | N of native
      
  let baselib = List.fold_left (fun r (i, f) -> Env.add i f r) Env.empty
  [("%add", (N (function [ Int a ; Int b ] -> Int (a + b) | _ -> failwith "ERROR")));
   ("%sub", (N (function [ Int a ; Int b ] -> Int (a - b) | _ -> failwith "ERROR")));
   ("%notEqual", (N (function [ Int a ; Int b ] -> Bool (a <> b) | _ -> failwith "ERROR")))]
