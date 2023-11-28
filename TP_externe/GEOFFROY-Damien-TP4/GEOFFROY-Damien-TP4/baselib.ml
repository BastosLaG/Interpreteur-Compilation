open Ast
module Env = Map.Make(String)

let baselib = Env.add "%add" (fun a b -> a + b) Env.empty

type native = value list -> value


type env_value =
  |V of value 
  |N of native 

  
  
  let baselib =
    List.fold_left (fun env (i, f) -> Env.add i f env) Env.empty
    (*pour les loop *)
    [ "%less", N (function [Int a ; Int b] -> Bool (a < b) | _ -> failwith "ERROR");
      "%lessequal", N (function [Int a ; Int b] -> Bool (a <= b) | _ -> failwith "ERROR");
      "%greater", N (function [Int a ; Int b] -> Bool (a > b) | _ -> failwith "ERROR");
      "%greaterequal", N (function [Int a ; Int b] -> Bool (a >= b) | _ -> failwith "ERROR");
      "%equal", N (function [Int a ; Int b] -> Bool (a = b) | _ -> failwith "ERROR");
      "%notequal", N (function [Int a ; Int b] -> Bool (a <> b) | _ -> failwith "ERROR");
      "%sub", N (function [ Int a ; Int b ] -> Int (a - b) | _ -> failwith "ERROR");
      "%add", N (function [ Int a ; Int b ] -> Int (a + b) | _ -> failwith "ERROR");
      (*pour lexo 2*)
      "%geti", N (function _ -> Int (read_int ()));
      "%puti", N (function [Int a] -> print_int a; Void | _ -> failwith "ERROR");
      "%puts", N (function [Str s] -> print_string s; Void | _ -> failwith "ERROR");
      "%rand", N (function [Int a] -> Int (17) | _ -> failwith "ERROR"); ]
  
      