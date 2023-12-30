module Syntax = struct
  type expr =
    | Int    of { value : int     ; pos : Lexing.position }
    | Bool   of { value : bool    ; pos : Lexing.position }
    | String of { name : string  ; pos : Lexing.position }
    (* | Var    of { name : string ; pos : Lexing.position } *)

  (* type type_t = Bool_t | Int_t | String_t 

  type instr = 
    | DeclVar of { name : string ; pos : Lexing.position }
    | Assign  of { name : string ; pos : Lexing.position }
    | Return of { expr : expr; pos : Lexing.position }
  and block = instr list *)
end

module IR = struct
  type expr =
    | Int     of int
    | Bool    of bool
    | String  of string
    (* | Var     of string *)

  
end
