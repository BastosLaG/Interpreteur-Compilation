%{
  open Ast.Syntax
%}

%token <int> Lint
%token <string> Lvar
%token Ladd Lsub Lmul Ldiv Lopar Lcpar
%token Lreturn Lassign Lsc Lend

%left Ladd Lsub
%left Lmul Ldiv

%start block

%type <Ast.Syntax.block> block

%%

block:
  | Lend { [] }
  | i = instr; b = block {i::b}
;

instr: 
  | Lreturn; r = expr; Lsc 
      { Return { expr = r; pos = $startpos($1)} }
  | v = Lvar ; Lassign ; d = expr; Lsc 
      { Assign { var = v ; expr = d ; pos = $startpos } }

expr:
  | Lopar ; e = expr ; Lcpar 
    { e }
  | n = Lint 
    { Int { value = n; pos = $startpos } }
  | v = Lvar 
    { Var { name = v ; pos = $startpos } }
  | e = expr; Lmul ; d = expr { Call {func = "%mul"; args=[e;d] ; pos = $startpos} }
  | e = expr; Ladd ; d = expr { Call {func = "%add"; args=[e;d] ; pos = $startpos} }
  | e = expr; Lsub ; d = expr { Call {func = "%sub"; args=[e;d] ; pos = $startpos} }
  | e = expr; Ldiv ; d = expr { Call {func = "%div"; args=[e;d] ; pos = $startpos} }
;