type type_t =
  | Bool_t
  | Int_t
  | Func_t of type_t * type_t list

let rec string_of_type_t t =
  match t with
  | Int_t  -> "int"
  | Bool_t -> "bool"
  | Func_t (r, a) ->
     (if (List.length a) > 1 then "(" else "")
     ^ (String.concat ", " (List.map string_of_type_t a))
     ^ (if (List.length a) > 1 then ")" else "")
     ^ " -> " ^ (string_of_type_t r)

module Syntax = struct
  type ident = string
  type value =
    | Bool of bool
    | Int  of int
  type expr =
    | Value of { value: value
               ; pos: Lexing.position }
    | Var   of { name: ident
               ; pos: Lexing.position }
    | Call  of { func: ident
               ; args: expr list
               ; pos: Lexing.position }
  type instr =
    | Decl   of { name: ident
                ; type_t: type_t
                ; pos: Lexing.position }
    | Assign of { var: ident
                ; expr: expr
                ; pos: Lexing.position }
  and block = instr list
end

module IR = struct
  type ident = string
  type value =
    | Bool of bool
    | Int  of int
  type expr =
    | Value of value
    | Var   of ident
    | Call  of ident * expr list
  type instr =
    | Decl   of ident
    | Assign of ident * expr
  and block = instr list

  let string_of_ir ast =
    let rec p_v = function
      | Bool b -> "Bool " ^ (string_of_bool b)
      | Int n  -> "Int " ^ (string_of_int n)
    and p_e = function
      | Value v     -> "Value (" ^ (p_v v) ^ ")"
      | Var v       -> "Var \"" ^ v ^ "\""
      | Call (f, a) -> "Call (\"" ^ f ^ "\", [ "
                       ^ (String.concat " ; " (List.map p_e a))
                       ^ " ])"
    and p_i = function
      | Decl v        -> "Decl \"" ^ v ^ "\""
      | Assign (v, e) -> "Assign (\"" ^ v ^ "\", " ^ (p_e e) ^ ")"
    and p_b b = "[ " ^ (String.concat " ; " (List.map p_i b)) ^ " ]"
    in p_b ast
end
