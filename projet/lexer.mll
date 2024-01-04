{
  open Lexing
  open Parser

  exception Error of char
}

let num = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let ident = alpha (alpha | num | '-' | '_')*

rule token = parse
| eof             { Lend }
| ";"			        { Lsc }
(* | ","             { Lvirgule } *)
| [ ' ' '\t' ]    { token lexbuf }
| '\n'            { Lexing.new_line lexbuf; token lexbuf }
| "//"          	{ comment lexbuf }

(* base *)
| num+ as n       { Lint    (int_of_string n) }
| "True"          { Ltrue   (true)}
| "False"         { Lfalse  (false)}
| '"' [^'"']* '"' { Lstring (Lexing.lexeme lexbuf) }


(* var *)
| ident+ as id    { Lvar (id) }
| "="			        { Lassign }
| "return"        { Lreturn }
| "printf"		    { Lprint }
| "scan"          { Lscan }

(* operateur *)
| "+"			        { Ladd }
| "-"             { Lsub }
| "*"			        { Lmul }
| "/"             { Ldiv }
| "=="			      {	Lequal }
| "!="		  	    { Lnequal }

(* condition *)
| "if"			      { Lif }
| "else"		      { Lelse }
| "while"		      { Lwhile }
| "("			        { LopenP }
| ")"			        { LcloseP }
| "{" 			      { LopenC }
| "}"			        { LcloseC }

| _ as c          { raise (Error c) }

and comment = parse
| eof  { Lend }
| '\n' { Lexing.new_line lexbuf; token lexbuf }
| _    { comment lexbuf }
