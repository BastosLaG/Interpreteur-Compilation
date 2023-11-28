(* print.ml *)
open Ast

let print_value v = match v with
| Void -> print_endline "Void"
| Bool b -> print_endline (string_of_bool b)
| Int i -> print_endline (string_of_int i)
| Str s -> print_endline s
