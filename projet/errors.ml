(*errors.ml*)
open Ast
open Lexing

exception LexerErrorC of char
exception LexerErrorS of string
exception SemanticsError of string * Lexing.position

let err msg pos =
  Printf.eprintf
    "Erreur: Ligne %d, Colonne %d : %s.\n"
    pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol)
    msg;
  exit 1
;;

let rec string_of_type_t = function
  | AnyType_t -> "anytype"
  | Void_t -> "void"
  | Int_t -> "int"
  | Bool_t -> "bool"
  | Str_t -> "str"
  | Func_t (return_type, arg_types) ->
    let args_str =
      if List.length arg_types > 1 then
        "(" ^ String.concat ", " (List.map string_of_type_t arg_types) ^ ")"
      else
        String.concat ", " (List.map string_of_type_t arg_types)
    in
    args_str ^ " -> " ^ string_of_type_t return_type
;;

let errt expected given pos =
  raise
    (SemanticsError
       ( Printf.sprintf
           "Erreur sémantique : Attendu %s, mais obtenu %s."
           (String.concat " ou " (List.map string_of_type_t expected))
           (String.concat " ou " (List.map string_of_type_t given))
       , pos ))
;;

let warn msg (pos : Lexing.position) =
  Printf.eprintf
    "Avertissement: Ligne %d, Colonne %d : %s.\n"
    pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol)
    msg
;;
