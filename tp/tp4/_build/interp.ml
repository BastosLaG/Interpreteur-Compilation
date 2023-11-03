open Ast
open Baselib

let eval_value v = v

let eval_expr e env =
  match e with
  | Value e -> eval_value e
  | Var e -> Env.find e env

(* let eval_instr e env = 
  match e with
  | Return e  -> eval_expr e
  | Expr e    -> eval_expr e
  | Assign  of ident * expr
  | Cond    of expr * block * block
  | Loop    of expr * block

let eval_block b = function
  match b with
  | *)