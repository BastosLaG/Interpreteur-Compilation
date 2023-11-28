(* baselib.ml*)
open Ast

type native = value list -> value

type env_value =
  | V of value
  | N of native
  | F of string list * block

module Env = Map.Make(String)

let add_func = N (function
  | [Int a; Int b] -> Int (a + b)
  | _ -> failwith "Erreur arguments invalides pour %add"
)
let lt_func = N (function
  | [Int a; Int b] -> Bool (a < b)
  | _ -> failwith "Erreur arguments invalides pour %add"
)
let eq_func = N (function
  | [Int a; Int b] -> Bool (a = b)
  | [Str a; Str b] -> Bool (a = b)
  | [Bool a; Bool b] -> Bool (a = b)
  | _ -> failwith "Erreur arguments invalides pour %eq"
)
let neq_func = N (function
  | [Int a; Int b] -> Bool (a <> b)
  | [Str a; Str b] -> Bool (a <> b)
  | [Bool a; Bool b] -> Bool (a <> b)
  | _ -> failwith "Erreur arguments invalides pour %neq"
)
let geti_func = N (function
  | [] -> Int (read_int ())  
  | _ -> failwith "Erreur arguments invalides pour geti"
)
let puti_func = N (function
  | [Int n] -> 
    print_int n;
    Void
  | _ -> failwith "Erreur arguments invalides pour puti"
)
let puts_func = N (function
  | [Str s] -> print_endline s; Void  
  | _ -> failwith "Erreur arguments invalides pour puts"
)
let rand_func = N (function
  | [Int n] -> Int (Random.int n)  
  | _ -> failwith "Erreur arguments invalides pour rand"
)
let gt_func = N (function
  | [Int a; Int b] -> Bool (a > b)
  | _ -> failwith "Erreur arguments invalides pour %gt"
)
let and_func = N (function
  | [Int a; Int b] -> Int (a land b)
  | _ -> failwith "Erreur arguments invalides pour %and"
)
let shr_func = N (function
  | [Int a; Int b] -> Int (a lsr b)
  | _ -> failwith "Erreur arguments invalides pour %shr"
)
let xor_func = N (function
  | [Int a; Int b] -> Int (a lxor b)
  | _ -> failwith "Erreur arguments invalides pour %xor"
)
let shl_func = N (function
  | [Int a; Int b] -> Int (a lsl b)
  | _ -> failwith "Erreur arguments invalides pour %shl"
)
let and_func = N (function
  | [Int a; Int b] -> Int (a land b)
  | _ -> failwith "Erreur arguments invalides pour %and"
)

let baselib = Env.(empty
  |> add "%add" add_func
  |> add "%lt" lt_func
  |> add "%eq" eq_func
  |> add "%neq" neq_func
  |> add "%gt" gt_func
  |> add "%and" and_func
  |> add "%shr" shr_func
  |> add "%xor" xor_func
  |> add "%shl" shl_func
  |> add "geti" geti_func
  |> add "puts" puts_func
  |> add "rand" rand_func
  |> add "puti" puti_func
  |> add "and" and_func
)
