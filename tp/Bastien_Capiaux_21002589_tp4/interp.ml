(* Interp *)
open Ast
open Baselib

type 'a res =
| Ret of value
| Env of 'a Env.t

let rec eval_const = function
| Void		-> Void
| Bool b	-> Bool b
| Int n 	-> Int n
| Str s	  -> Str s

let rec eval_expr e env =
  match e with
  | Value v     -> eval_const v
  | Var v       -> Env.find v env
  | Call (func, args) ->
    (match Env.find func Baselib.baselib with
     | Baselib.N f ->
        let arg_values = List.map (fun arg -> eval_expr arg env) args in
        f arg_values
     | _ -> failwith "ERROR: Function not found in the environment"
    )


let rec eval_instr i env =
  match i with
  | Return e 	      -> Ret (eval_expr e env)
  | Expr _          -> raise (Failure "Not implemented")
  | Assign (i, e)   -> let e_value = eval_expr e env in
    Env (Env.add i e_value env)
  | Cond (c, y, n)  -> (match (eval_expr c env ) with
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
and eval_block b env =
  match b with
  | []	    -> Env env
  | i :: r  ->
    match eval_instr i env with
    | Ret v 	-> Ret v
    | Env e 	-> eval_block r e 

let eval prog =
  match eval_block prog Env.empty with
  | Ret v -> v
  | Env e -> Void
      
