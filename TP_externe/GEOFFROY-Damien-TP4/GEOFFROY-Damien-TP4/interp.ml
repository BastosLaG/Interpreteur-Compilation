open Ast
open Baselib 


type 'a res = 
  | Ret of value
  | Env of 'a Env.t

let eval_const = function
  | Void -> Void
  | Bool b -> Bool b
  | Int n -> Int n
  | Str s -> Str s

let eval_expr e env =
  match e with
  | Value c -> eval_const c
  | Var x -> Env.find x env

let eval_instr i env =
  match i with 
  | Return e -> Ret (eval_expr e env)
  | Assign (v, e) -> Env(Env.add v (eval_expr e env) env )
  (* | Expr e -> eval_expr e env Env env *)

let rec eval_block b env=
  match b with 
  | [] -> Env env 
  | i :: r ->
      match eval_instr i env with 
        | Ret v -> Ret v
        | Env e -> eval_block r e 

let eval prog =
  match eval_block prog Env.empty with
  |Ret v -> v
  |Env e -> Void  