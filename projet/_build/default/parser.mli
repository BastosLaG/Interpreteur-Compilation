
(* The type of tokens. *)

type token = 
  | Lint of (int)
  | Lend

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.Syntax.expr)
