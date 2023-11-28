open Ast (*import de Ast*)
let print_const v  =   (* v aura le type value*)
  match v with 
  | Ast.Void   -> Printf.printf "Void"
  | Ast.Bool b -> Printf.printf "%s" (if b then "yes" else "False")
  | Ast.Int i  -> Printf.printf "%d" i
  | Ast.Str s  -> Printf.printf "%s" s