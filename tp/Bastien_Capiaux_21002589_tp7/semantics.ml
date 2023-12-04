open Ast
open Ast.IR
open Baselib

exception Error of string * Lexing.position

(* fonctions d'aide à la gestion des erreurs *)

let expr_pos expr =
  match expr with
  | Syntax.Value v -> v.pos
  | Syntax.Var v   -> v.pos
  | Syntax.Call c  -> c.pos

let errt expected given pos =
  raise (Error (Printf.sprintf "expected %s but given %s"
                  (string_of_type_t expected)
                  (string_of_type_t given),
                pos))

(* analyse sémantique *)

let analyze_value value =
  match value with
  | Syntax.Bool b -> Bool b
  | Syntax.Int n  -> Int n

let rec analyze_expr env expr =
  match expr with
  | Syntax.Value v ->
      Value (analyze_value v.value)
  | Syntax.Var v ->
      if Env.mem v.name env then
          Var v.name
      else
          raise (Error ("Unbound variable: " ^ v.name, expr_pos expr))
  | Syntax.Call c ->
      let args = List.map (analyze_expr env) c.args in
      Call (c.func, args)
    
  
let analyze_instr env instr =
  match instr with
  | Syntax.Decl d ->
      let env = Env.add d.name d.type_t env in
      env, Decl d.name
  | Syntax.Assign a ->
      let ae = analyze_expr env a.expr in
      if Env.mem a.var env 
      then env, Assign (a.var, ae)
      else raise (Error ("Unbound variable in assignment: " ^ a.var, a.pos))

let rec analyze_block env block =
  match block with
  | [] -> env, []
  | instr :: rest ->
      let env, ai = analyze_instr env instr in
      let env, rest_ir = analyze_block env rest in
      env, ai :: rest_ir
let analyze parsed =
  let initial_env = Baselib._types_ in  
  let _, ir = analyze_block initial_env parsed in
  ir
