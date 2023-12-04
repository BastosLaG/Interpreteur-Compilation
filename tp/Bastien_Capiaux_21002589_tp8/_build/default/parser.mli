
(* The type of tokens. *)

type token = 
  | Lvar of (string)
  | Lsub
  | Lsc
  | Lreturn
  | Lopar
  | Lmul
  | Lint of (int)
  | Lend
  | Ldiv
  | Lcpar
  | Lassign
  | Ladd

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val block: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.Syntax.block)
