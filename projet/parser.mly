%{
  open Ast
  open Ast.Syntax
%}

%token Lsc 
%token Lend 
// %token Lvirgule
// base
%token <int> Lint
%token <bool> Ltrue
%token <bool> Lfalse
%token <string> Lstring
%token <string> Lvar

// var
%token Lassign
%token Lreturn 
%token Lprint
%token Lscan

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
| Lreturn; e = expr 
  { [Return { expr = e;pos = $startpos($1)}] }
| Lif; LopenP ; c = expr; LcloseP ; LopenC ; t= block ; LcloseC ; Lelse ; LopenC; e = block ; LcloseC 
  {	[Cond { cond = c; then_block = t; else_block = e; pos= $startpos(c) }] }
| Lif; LopenP ; e = expr ; LcloseP ; LopenC ; b = block; LcloseC 
  { [Cond { cond = e; then_block = b; else_block = []; pos = $startpos }] }
| Lwhile; LopenP ; l = expr ; LcloseP ; LopenC; b = block ; LcloseC
  { [Loop { cond = l; block = b; pos = $startpos(l)}] }

expr:
| n = Lint    { Int { value = n; pos = $startpos(n) } }
| s = Lstring { String { value = s; pos = $startpos(s) } }
| b = Ltrue   { Bool { value = b; pos = $startpos(b) } }
| b = Lfalse  { Bool { value = b; pos = $startpos(b) } }
| id = Lvar   {	String { value = id;pos = $startpos(id)} }

| Lprint; LopenP; s = Lint; LcloseP 
  { Call {func = "_printf"; args = [Int { value = s; pos = $startpos(s) }]; pos = $startpos(s) } }
| Lprint; LopenP; s = Lstring; LcloseP 
  { Call {func = "_printf"; args = [String { value = s; pos = $startpos(s) }]; pos = $startpos(s) } }
| Lprint; LopenP; b = Ltrue; LcloseP 
  { Call {func = "_printf"; args = [Bool { value = b; pos = $startpos(b) }]; pos = $startpos(b) } }
| Lprint; LopenP; b = Lfalse; LcloseP 
  { Call {func = "_printf"; args = [Bool { value = b; pos = $startpos(b) }]; pos = $startpos(b) } }
| Lprint; LopenP; v = Lvar; LcloseP 
  { Call {func = "_printf"; args = [String { value = v; pos = $startpos(v) }]; pos = $startpos(v) } }

| LopenP; e = expr; LcloseP 
  { e }

| Lscan; LopenP; s = expr; LcloseP 
  { Call {func = "_scanf"; args = [s]; pos = $startpos(s) } }
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
