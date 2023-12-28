
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | Lint of (
# 6 "parser.mly"
       (int)
# 15 "parser.ml"
  )
    | Lend
  
end

include MenhirBasics

# 1 "parser.mly"
  
  open Ast
  open Ast.Syntax

# 28 "parser.ml"

type ('s, 'r) _menhir_state

and _menhir_box_prog = 
  | MenhirBox_prog of (Ast.Syntax.expr) [@@unboxed]

let _menhir_action_1 =
  fun _startpos_n_ n ->
    (
# 20 "parser.mly"
           (
  Int { value = n ; pos = _startpos_n_ }
)
# 42 "parser.ml"
     : (Ast.Syntax.expr))

let _menhir_action_2 =
  fun e ->
    (
# 16 "parser.mly"
                 ( e )
# 50 "parser.ml"
     : (Ast.Syntax.expr))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | Lend ->
        "Lend"
    | Lint _ ->
        "Lint"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_0 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_prog =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Lint _v ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let (_startpos_n_, n) = (_startpos, _v) in
          let _v = _menhir_action_1 _startpos_n_ n in
          (match (_tok : MenhirBasics.token) with
          | Lend ->
              let e = _v in
              let _v = _menhir_action_2 e in
              MenhirBox_prog _v
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
end

let prog =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_prog v = _menhir_run_0 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
