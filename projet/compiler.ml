open Ast.IR
open Mips

module Env = Map.Make(String)

let labelCounter = ref 0

let newLabel prefix =
  incr labelCounter;
  Printf.sprintf "%s%d" prefix !labelCounter

let compileString s =
    let label = newLabel "str" in
    let formattedString = String.sub s 1 (String.length s - 2) in 
    [ La (A0, Lbl label) ], (label, Asciiz formattedString)

let rec compileExpr e =
  match e with
  | Int n  -> [ Li (V0, n) ], []
  | Bool b -> let value = if b then 1 else 0 in
              [ Li (V0, value) ], []
  | String s ->
    let instrs, dataDecl = compileString s in
    instrs, [dataDecl]

let compile expr =
  let exprs = [expr] in  
  let text, data = List.fold_left (fun (textAcc, dataAcc) expr ->
    let instrs, dataDecl = compileExpr expr in
    (instrs @ textAcc, dataDecl @ dataAcc)
  ) ([], []) exprs in
  { text = Baselib.builtins @ List.rev text; data = List.rev data }