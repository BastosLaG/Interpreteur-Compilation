type type_t =
  | Int_t
  | Func_t of type_t * type_t list

let rec string_of_type_t t =
  match t with
  | Int_t  -> "int"
  | Func_t (r, a) ->
     (if (List.length a) > 1 then "(" else "")
     ^ (String.concat ", " (List.map string_of_type_t a))
     ^ (if (List.length a) > 1 then ")" else "")
     ^ " -> " ^ (string_of_type_t r)

module Syntax = struct
  type ident = string
  type expr =
    | Int  of { value: int
              ; pos: Lexing.position }
    | Var  of { name: ident
              ; pos: Lexing.position }
    | Call of { func: ident
              ; args: expr list
              ; pos: Lexing.position }
  type instr =
    | Assign of { var: ident
                ; expr: expr
                ; pos: Lexing.position }
    | Return of { expr: expr
                ; pos: Lexing.position }
  and block = instr list
end

module IR = struct
  type ident = string
  type expr =
    | Int  of int
    | Var  of ident
    | Call of ident * expr list
  type instr =
    | Assign of ident * expr
    | Return of expr
  and block = instr list

  let string_of_ir ast =
    let rec fmt_e = function
      | Int n       -> "Int " ^ (string_of_int n)
      | Var v       -> "Var \"" ^ v ^ "\""
      | Call (f, a) -> "Call (\"" ^ f ^ "\", [ "
                       ^ (String.concat " ; " (List.map fmt_e a))
                       ^ " ])"
    and fmt_i = function
      | Assign (v, e) -> "Assign (\"" ^ v ^ "\", " ^ (fmt_e e) ^ ")"
      | Return e      -> "Return (" ^ (fmt_e e) ^ ")"
    and fmt_b b = "[ " ^ (String.concat "\n; " (List.map fmt_i b)) ^ " ]"
    in fmt_b ast
end
