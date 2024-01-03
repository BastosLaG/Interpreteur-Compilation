open Ast
open Ast.IR
open Baselib

exception Error of string * Lexing.position

let rec analyze_expr env expr =
  match expr with
  | Syntax.Int n -> Int n.value
  | Syntax.String s -> String s.value
  | Syntax.Bool b -> Bool b.value
  | Syntax.Call c -> let args = List.map (analyze_expr env) c.args in
                     Call (c.func,args)

let rec analyze_instr instr env =
  match instr with
  | Syntax.Decl d -> (Decl d.var, env)
  | Syntax.Assign a ->
        let ae = analyze_expr env a.expr in
        (Assign (a.var, ae), env)

  | Syntax.Return r ->
        let re = analyze_expr env r.expr in
        (Return re, env)

  | Syntax.Print { args = print_args; pos = _ } ->
        let analyzed_args = List.map (analyze_expr env) print_args in
        (Print analyzed_args, env)

  | Syntax.Cond c ->
        let cif = analyze_expr env c.cond in
        let cthen = List.map (fun i -> fst (analyze_instr i env)) c.then_block in
        let celse = List.map (fun i -> fst (analyze_instr i env)) c.else_block in
        (Cond (cif,cthen,celse),env)
  | Syntax.Loop l ->
    let lwhile = analyze_expr env l.cond in
    let b = List.map (fun i -> fst(analyze_instr i env)) l.block in
    (Loop(lwhile,b),env)


let rec analyze_block block env =
  match block with
  | [] -> []
  | instr :: rest -> let ai, new_env = analyze_instr instr env in
                    ai :: (analyze_block rest new_env)

let analyze parsed =
  analyze_block parsed Baselib._types_

