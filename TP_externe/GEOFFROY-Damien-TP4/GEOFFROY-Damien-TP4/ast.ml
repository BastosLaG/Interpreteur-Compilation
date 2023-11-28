type value =
| Void  
| Bool of bool 
| Int of int  
| Str of string ;; 

type ident = string;;

type expr = 
| Value of value
| Var of ident
| Call of ident * expr list

type instr = 
| Assign of ident * expr
| Return of expr
| Cond of expr * block *block
| Expr of expr 
| Loop of expr * block

and block = instr list  (*liste de instr*)

type def =  
| Func of ident * ident list * block ;;

type prog = def list
