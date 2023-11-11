(* test *)
open Ast

let () =
  let prog =[

  Assign ("hw", Value (Str "Hello World!"))
  ; Assign ("truc", Var "hw")
  ; Return (Var "truc")

  ] in Print.print_value (Interp.eval prog)