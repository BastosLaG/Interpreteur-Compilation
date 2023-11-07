(* Print *)
open Ast

let print_value v =
  match v with
  | Ast.Void    -> Printf.printf "NULL"
  | Ast.Bool b  -> Printf.printf "%s" (if b then "True" else "False") 
  | Ast.Int i   -> Printf.printf "%d" i
  | Ast.Str s   -> Printf.printf "%s" s
