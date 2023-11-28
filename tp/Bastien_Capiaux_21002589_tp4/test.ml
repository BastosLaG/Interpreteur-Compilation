(* test.ml *)
open Ast
open Interp
open Baselib

let () =
  let main_def = Func ("main", [], [
    Assign ("x", Value (Int 5));  
    Cond (Call ("%lt", [Var "x"; Value (Int 10)]), 
      [ Return (Value (Str "x est inférieure à 10")) ], 
      [ Return (Value (Str "x n’est pas moins que 10")) ]  
    )
  ]) in

let loop_def = Func ("boucle", [], [
  Assign ("y", Value (Int 1));  
  Loop (Call ("%lt", [Var "y"; Value (Int 5)]), [  
    Assign ("y", Call ("%add", [Var "y"; Value (Int 1)]))  
  ]);
  Return (Var "y") 
]) in
let prog_defs = [main_def; loop_def] in
let result = Interp.eval prog_defs in
  match result with
  | Str s -> print_endline s
  | Int i -> print_int i; print_newline ()
  | _ -> print_endline "Erreur value"
