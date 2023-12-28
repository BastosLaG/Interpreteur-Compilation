open Ast.IR
open Mips

module Env = Map.Make(String)

let rec compile_expr e =
  match e with
  | Int n  -> [ Li (V0, n) ]
  | Bool b -> [ Li (V0, if b then 1 else 0) ]

let compile ir =
  { text = Baselib.builtins @ compile_expr ir
  ; data = [] }
