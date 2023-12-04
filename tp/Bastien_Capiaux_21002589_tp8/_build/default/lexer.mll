{
  open Parser

  exception Error of char
}

let alpha = ['a'-'z' 'A'-'Z']
let num = ['0'-'9']
let identifier = alpha (alpha | num | '-' | '_')*

rule token = parse
| eof             { Lend }
| [ ' ' '\t' ]    { token lexbuf }
| '\n'            { Lexing.new_line lexbuf; token lexbuf }
| '#'             { comment lexbuf }
| _ as c          { raise (Error c) }

and comment = parse
| eof  { Lend }
| '\n' { Lexing.new_line lexbuf; token lexbuf }
| _    { comment lexbuf }
