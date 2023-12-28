%{
  open Ast
  open Ast.Syntax
%}

%token <int> Lint
%token <bool> Ltrue
%token <bool> Lfalse
%token Lend

%start prog

%type <Ast.Syntax.expr> prog

%%

prog:
| e = expr; Lend { e }
;

expr:
| n = Lint {
  Int { value = n ; pos = $startpos(n) }
}
| b = Ltrue {
  Bool { value = b ; pos = $startpos(b) }
}
| b = Lfalse {
  Bool { value = b ; pos = $startpos(b) }
}
;
