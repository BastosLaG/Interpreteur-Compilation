(* Interp *)
open Ast
open Baselib

let rec eval_value v = v 

let rec eval_expr e env =
  match e with
  | Value v -> eval_value v
  | Var v   -> Env.find v env
  | Call (func, args) ->
    (match Env.find func Baselib.baselib with
     | Baselib.N f ->
        let arg_values = List.map (fun arg -> eval_expr arg env) args in
        f arg_values
     | _ -> failwith "ERROR: Function not found in the environment"
    )

type 'a res =
  | Stop of value
  | Cont of 'a Env.t 

let eval_instr env = fonction
  | Return e 	      -> Stop (eval_expr env e)
  | Assign (v, e)   -> Cont (Env.add v (eval_expr env e) env)
  | Expr _          -> raise (Failure "Not implemented")
  | Cond (c, y, n)  -> (match (eval_expr env c) with
                        | Bool b -> (match b with
                                    | true -> eval_block y env
                                    | false -> eval_block n env)
                        | _ -> eval_block y env)
  | Loop (c, l)     -> (match (eval_expr c env) with
                        | Bool b -> (match b with
                                    | true -> (match (eval_block l env) with
                                              | Ret v -> Ret v
                                              | Env e -> eval_instr (Loop(c, l)) e)
                                    | false -> Env env)
                        | _ -> Env env)

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

