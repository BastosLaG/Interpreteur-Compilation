open Ast.IR1

let () =
  let code =
    [ Func ("main", [],
            [ Decl "a"
            ; Decl "b"
            ; Expr (Call ("puts", [ Value (Str "Enter a number: ") ]))
            ; Assign (LVar "a", Call ("geti", []))
            ; Expr (Call ("puts", [ Value (Str "Enter a number: ") ]))
            ; Assign (LVar "b", Call ("geti", []))
            ; Expr (Call ("puts", [ Value (Str "The sum of your numbers is: ") ]))
            ; Expr (Call ("puti", [ Call ("_add", [ Var "a" ; Var "b" ])]))
            ; Expr (Call ("puts", [ Value (Str "\\n") ]))
            ; Expr (Call ("puts", [ Value (Str "The product of your numbers is: ") ]))
            ; Expr (Call ("puti", [ Call ("_mul", [ Var "a" ; Var "b" ])]))
            ; Expr (Call ("puts", [ Value (Str "\\n") ]))
            ; Return (Value (Int 0)) ])
    ] in
  try
    let simplified = Simplifier.simplify code in
    let compiled = Compiler.compile simplified in
    Mips.print_asm Stdlib.stdout compiled
  with
  | Match_failure (m, _, _) ->
     Printf.eprintf "Vous devez compléter le module %s.\n" m
  | _ -> failwith "WTF?"
