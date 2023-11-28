(*interp.ml*)
open Ast
open Baselib

type 'a res =
  | Ret of value
  | Env of 'a Env.t

let rec eval_expr expr env =
  match expr with
  | Value v -> 
    V v
  | Var name ->
    (match Env.find_opt name env with
     | Some (V value) -> V value
     | Some _ -> failwith ("Erreur type inattendu : " ^ name)
     | None ->
       failwith ("Erreur variable non trouvée : " ^ name))
    | Call (fname, args) ->
    (match Env.find_opt fname env with
      | Some (N f) ->
        let arg_values = List.map (fun e -> match eval_expr e env with V v -> v | _ -> failwith ("Argument invalide dans l'appel à " ^ fname)) args in
        V (f arg_values)
      | Some (F (params, block)) ->
        let new_env = List.fold_left2 (fun acc_env param arg -> Env.add param (V arg) acc_env)
                                      env params (List.map (fun e -> match eval_expr e env with V v -> v | _ -> failwith ("Argument invalide dans l'appel à " ^ fname)) args) in
        (match eval_block block new_env with
          | Ret v -> V v
          | Env _ -> failwith ("Fonction utilisateur n'a pas retourné correctement : " ^ fname))
      | Some (V _) -> failwith ("Tentative d'appel d'une valeur comme une fonction : " ^ fname)
      | None ->
        failwith ("Fonction non trouvée : " ^ fname))
      
    
and eval_block block env =
  match block with
  | [] -> Env env
  | instr :: rest ->
    match eval_instr instr env with
    | Ret v ->
      Ret v
    | Env new_env ->
      eval_block rest new_env

and eval_instr instr env =
  match instr with
  | Return expr ->
    Ret (match eval_expr expr env with V v -> v | _ -> failwith "Erreur ret invalide")
  | Assign (name, expr) ->
    Env (Env.add name (eval_expr expr env) env)
  | Cond (cond, then_block, else_block) ->
    (match eval_expr cond env with
      | V (Bool true) ->
        eval_block then_block env
      | V (Bool false) ->
        eval_block else_block env
      | _ -> failwith "Erreur !bool")
  | Loop (cond, block) ->
    let rec loop () =
      match eval_expr cond env with
      | V (Bool true) ->
        (match eval_block block env with
          | Ret v -> Ret v  
          | Env new_env -> loop ())
      | V (Bool false) -> Env env
      | _ -> failwith "Erreur !bool"
    in
    loop ()
  
  | Expr e ->
    (match eval_expr e env with
      | V _ -> Env env
      | _ -> failwith "Evaluation invalide de l'expression")

let eval_def def env =
  match def with
  | Func (name, params, block) ->
    Env.add name (F (params, block)) env

let eval prog =
  let env_with_funcs = List.fold_left (fun env def -> eval_def def env) baselib prog in
  match Env.find_opt "main" env_with_funcs with
  | Some (F (params, block)) when params = [] ->
    (match eval_block block env_with_funcs with
    | Ret v ->
      v
    | Env _ ->
      Void)
  | _ ->
    failwith "Aucune fonction 'main' valide trouvée"
