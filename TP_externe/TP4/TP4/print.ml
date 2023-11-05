open Ast

let fmt_const = function
	| Nil -> "nil"
	| Bool b -> string_of_bool b
	| Int n -> string_of_int n
	| Str s -> Printf.sprintf "\"%s\"" s

let print_const c = Printf.printf "%s\n" (fmt_const c)