(* Interp *)
open Ast
open Baselib

let rec eval_value v = v 

let rec eval_expr e env =
  match e with
  | Value v -> eval_value v
  | Var n   -> 
    (match Env.find n env with
      | V v -> v 
      | _   -> failwith "Should not happen")
  | Call (f, a) -> 
    (match Env.find f env with
     | N f -> f (List.map (eval_expr env) a)
     | _ -> failwith "ERROR: Function not found in the environment")

type 'a res =
  | Stop of value
  | Cont of 'a Env.t 

let eval_instr env = fonction
  | Return e 	      -> Stop (eval_expr env e)
  | Assign (v, e)   -> Cont (Env.add v (eval_expr env e) env)

let eval_block env = fonction
  | [] -> Cont env
  | i :: rest -> 
    match eval_instr env i with
    | Stop v -> Stop v
    | Cont e -> eval_block e b

let eval prog = 
  match eval_block Env.empty prog with
  | Stop v -> v 
  | Cont _ -> Void

