(* Sierpinsky.ml *)
open Ast
open Baselib
open Interp

let prog =
  [ Func ("main", [],
          [ Assign ("x", Value (Int 1));
            Loop (Call ("%lt", [Var "x"; Value (Int 2147483648)]),
              [ Assign ("n", Var "x");
                Loop (Call ("%gt", [Var "n"; Value (Int 0)]),
                  [ Cond (Call ("%neq", [Call ("%and", [Var "n"; Value (Int 1)]); Value (Int 0)]),
                      [Expr (Call ("puts", [Value (Str "#")]))],
                      [Expr (Call ("puts", [Value (Str " ")]))]);
                      
                    Assign ("n", Call ("%shr", [Var "n"; Value (Int 1)]))
                  ]);
                Expr (Call ("puts", [Value (Str "\n")]));
                Assign ("x", Call ("%xor", [Var "x"; Call ("%shl", [Var "x"; Value (Int 1)])]))
              ]);
            Expr (Call ("puts", [Value (Str "Hello, World!")])) (* Ajout de l'instruction d'affichage *)
          ])
  ]

(* Fonction principale d'exécution *)
let () =
  match eval prog with
  | Void -> ()
  | _ -> failwith "Main function should return Void"
