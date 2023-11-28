(* ast.ml*)
type value =
  | Void
  | Bool of bool
  | Int of int
  | Str of string

type expr =
  | Value of value
  | Var of string
  | Call of string * expr list

type instr =
  | Assign of string * expr
  | Return of expr
  | Cond of expr * block * block
  | Loop of expr * block
  | Expr of expr 
and block = instr list

type def =
  | Func of string * string list * block

type prog = def list
