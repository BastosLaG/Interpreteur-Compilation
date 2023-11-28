(* guessing_game.ml *)
open Ast
open Baselib
open Interp
let () = Random.self_init ()

let prog =
  [
    Func ("guessing_game", ["n"],
      [ Assign ("x", Call ("rand", [Var "n"]));
        Assign ("guess", Value (Int (-1)));
        Loop (Call ("%neq", [Var "guess"; Var "x"]),
          [ Expr (Call ("puts", [Value (Str "Devinez le nombre : ")]));
            Assign ("guess", Call ("geti", []));
            Cond (Call ("%eq", [Var "guess"; Var "x"]),
              [Expr (Call ("puts", [Value (Str "Bien joué !")]));
               Return (Value (Void))],
              [Cond (Call ("%lt", [Var "guess"; Var "x"]),
                [Expr (Call ("puts", [Value (Str "Trop bas !")]))],
                [Cond (Call ("%gt", [Var "guess"; Var "x"]),
                  [Expr (Call ("puts", [Value (Str "Trop haut !")]))],
                  [])])
              ])
          ])
      ]);

    Func ("main", [],
      [ Expr (Call ("puts", [Value (Str "Entrez le nombre maximum : ")]));
        Assign ("max", Call ("geti", []));
        Expr (Call ("guessing_game", [Var "max"]))
      ])
  ]

let () =
  match eval prog with
  | Void -> ()
  | _ -> failwith "La fonction principale doit retourner Void"
