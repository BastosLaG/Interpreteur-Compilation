module Syntax = struct
  type expr =
    | Int of { value: int
             ; pos: Lexing.position }
    | Bool of { value : bool
             ; pos: Lexing.position }
end

module IR = struct
  type expr =
    | Int of int
    | Bool of bool
end
