
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | Lvar of (
# 6 "parser.mly"
       (string)
# 15 "parser.ml"
  )
    | Lsub
    | Lsc
    | Lreturn
    | Lopar
    | Lmul
    | Lint of (
# 5 "parser.mly"
       (int)
# 25 "parser.ml"
  )
    | Lend
    | Ldiv
    | Lcpar
    | Lassign
    | Ladd
  
end

include MenhirBasics

# 1 "parser.mly"
  
  open Ast.Syntax

# 41 "parser.ml"

type ('s, 'r) _menhir_state

and _menhir_box_block = 
  | MenhirBox_block of (Ast.Syntax.block) [@@unboxed]

let _menhir_action_1 =
  fun () ->
    (
# 20 "parser.mly"
         ( [] )
# 53 "parser.ml"
     : (Ast.Syntax.block))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | Ladd ->
        "Ladd"
    | Lassign ->
        "Lassign"
    | Lcpar ->
        "Lcpar"
    | Ldiv ->
        "Ldiv"
    | Lend ->
        "Lend"
    | Lint _ ->
        "Lint"
    | Lmul ->
        "Lmul"
    | Lopar ->
        "Lopar"
    | Lreturn ->
        "Lreturn"
    | Lsc ->
        "Lsc"
    | Lsub ->
        "Lsub"
    | Lvar _ ->
        "Lvar"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_0 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_block =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Lend ->
          let _v = _menhir_action_1 () in
          MenhirBox_block _v
      | _ ->
          _eRR ()
  
end

let block =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_block v = _menhir_run_0 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
