open Ast
open Baselib

type 'a res =
  | Ret of value
  | Env of 'a Env.t

let eval_const = function
  | Nil		-> Nil
  | Bool b	-> Bool b
  | Int n 	-> Int n
  | Str s	-> Str s

let eval_expr e env =
  match e with
  | Value v	-> eval_const v
  | Var v	-> Env.find v env

let eval_instr i env =
  match i with
  | Return e 	-> Ret (eval_expr e env)
  | Assign(v, e)-> Env (Env.add v (eval_expr e env) env)

let rec eval_block b env =
  match b with
  | []	-> Env env
  | i :: r ->
	match eval_instr i env with
	| Ret v 	-> Ret v
	| Env e 	-> eval_block r e 

let eval prog =
  match eval_block prog Env.empty with
  | Ret v -> v
  | Env e -> Nil

