(* Ce fichier contient une version du programme sierpinsky.py (vu lors du précédent TP)
 * écrite en utilisant la représentation intermédiaire vue dans ce cours.
 * Une fois le TP 4 terminé, vous pourrez exécuter ce programme avec votre interpréteur.
 *)

let prog =
  [ Func ("main", [],
          [ Assign ("x", Value (Int 1))
          ; Loop (Call ("%lt", [ Var "x" ; Value (Int 2147483648) ]),
                  [ Assign ("n", Var "x")
                  ; Loop (Call ("%gt", [ Var "n" ; Value (Int 0) ]),
                          [ Cond (Call ("%and", [ Var "n" ; Value (Int 1) ]),
                                  [ Expr (Call ("puts", [ Value (Str "#") ])) ],
                                  [ Expr (Call ("puts", [ Value (Str " ") ])) ])
                          ; Assign ("n", Call ("%shr", [ Var "n" ; Value (Int 1) ]))
                      ])
                  ; Expr (Call ("puts", [ Value (Str "\n") ]))
                  ; Assign ("x",
                            Call ("%xor", [ Var "x"
                                          ; Call ("%shl", [ Var "x" ; Value (Int 1) ]) ]))
              ])
      ])
  ]
