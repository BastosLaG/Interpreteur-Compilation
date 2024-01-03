%{
  open Ast
  open Ast.Syntax
%}

%token Lsc 
%token Lend 
%token Lvirgule
// base
%token <int> Lint
%token <bool> Lbool
%token <string> Lstring
%token <string> Lvar

// var
%token Lassign
%token Lreturn 
%token Lprint
// %token Lscan

// operateur
%token Ladd 
%token Lsub 
%token Lmul 
%token Ldiv 
%token Lequal 
%token Lnequal

// condition
%token Lif
%token Lelse
%token Lwhile
%token LopenP
%token LcloseP
%token LopenC 
%token LcloseC


%start prog

%type <Ast.Syntax.block> prog

%%
block:
| Lend { [] }
| i = instr; b = block { i @ b }
| i = instr; Lsc { i }
;

expr_list:
  | e = expr                            { [e] }
  | e = expr; Lvirgule; el = expr_list   { e :: el }
;

prog:
|i = instr; Lsc; b =  prog{i@b}
|i = instr; Lsc; Lend {i}
;

instr:
| Lvar; id = Lvar 
  { [ Decl { var = id; pos = $startpos(id) }] }
| Lvar; id = Lvar; Lassign; e = expr 
  { [ Decl { var = id; pos = $startpos(id) }
    ; Assign { var = id; expr = e; pos = $startpos($3) }] }
| id = Lvar; Lassign; e = expr 
  { [ Assign { var = id; expr = e; pos = $startpos($2) }] }
| Lprint; LopenP; e = expr_list; LcloseP
  { [Print { args = e; pos = $startpos }] }
| Lreturn; e = expr 
  { [Return { expr = e;pos = $startpos($1)}] }
| Lif; LopenP ; c = expr; LcloseP ; LopenC ; t= block ; LcloseC ; Lelse ; LopenC; e = block ; LcloseC ; 
  {	[Cond { cond = c; then_block = t; else_block = e; pos= $startpos(c) }] }
| Lif; LopenP ; e = expr ; LcloseP ; LopenC ; b = block; LcloseC 
  { [Cond { cond = e; then_block = b; else_block = []; pos = $startpos }] }
| Lwhile; LopenP ; l = expr ; LcloseP ; LopenC; b = block ; LcloseC ;
  { [Loop { cond = l; block = b; pos = $startpos(l)}] }

expr:
| n = Lint    { Int { value = n; pos = $startpos(n) } }
| s = Lstring { String { value = s; pos = $startpos(s) } }
| b = Lbool   { Bool { value = b; pos = $startpos(b) } }
| id = Lvar   {	String { value = id;pos = $startpos(id)} }
| LopenP; e = expr; LcloseP 
  {e}
| e = expr; Ladd; d = expr 
  { Call { func = "_add"; args = [e; d]; pos = $startpos($2) } }
| e = expr; Lsub; d = expr 
  { Call { func = "_sub"; args = [e; d]; pos = $startpos($2) } }
| e = expr; Lmul; d = expr 
  { Call { func = "_mul"; args = [e; d]; pos = $startpos($2) } }
| e = expr; Ldiv; d = expr 
  { Call { func = "_div"; args = [e; d]; pos = $startpos($2) } }
| e = expr; Lequal; d = expr 
  { Call { func = "_eq"; args = [e;d]; pos = $startpos($2) } }
| e = expr; Lnequal; d = expr 
  { Call { func = "_neq"; args = [e;d]; pos = $startpos($2)} }
;
