module type Parameters = sig
  type value
end

module V1 = struct
  type value =
    | Nil
    | Bool of bool
    | Int  of int
    | Str  of string
end

module V2 = struct
  type value =
    | Nil
    | Bool of bool
    | Int  of int
    | Data of string
end

module IR (P : Parameters) = struct
  type ident = string
  type expr =
    | Value of P.value
    | Var   of ident
    | Call  of ident * expr list
  type lvalue =
    | LVar  of ident
    | LAddr of expr
  type instr =
    | Decl   of ident
    | Return of expr
    | Expr   of expr
    | Assign of lvalue * expr
    | Cond   of expr * block * block
  and block = instr list
  type def =
    | Func of ident * ident list * block
  type prog = def list
end

module IR1 = IR(V1)
module IR2 = IR(V2)
