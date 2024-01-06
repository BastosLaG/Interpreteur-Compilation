(*parser.mly*)
%{
  open Ast
  open Ast.Syntax
%}


%token <int> Lint
%token <bool> Lbool
%token <string> Lstr
%token <Ast.type_t> Ltype
%token <string> Lvar
%token Lend Lassign Lsc Lreturn
// Accolade 
%token LopenAcc LcloseAcc
// parentheses
%token LopenP LcloseP
// operateur
%token Ladd Lsub Lmul Ldiv Lrem Lseq Lsge Lsgt Lsle Lslt Lsne
%token Land Lor
// Condition
%token Lif Lelse Lwhile
%token Lprintf Lscanf
%token Lvirgule

%left Ladd Lsub Lseq Lsge Lsgt Lsle Lslt Lsne
%left Lmul Ldiv Lrem
%left Land Lor

%start prog

%type <Ast.Syntax.prog> prog

%%
prog:
  | f = def ; b = prog { f @ b }
  | Lend { [] }

def:
  | t = Ltype; f = Lvar; LopenP; a = separated_list(Lvirgule, arg); LcloseP; b = block 
    { [ Func { func = f ; type_t = t ; args = a ; code = b ; pos = $startpos(f) } ] }

arg:
  | t = Ltype ; v = Lvar { Arg { type_t = t ; name = v } }

block:
  | LopenAcc ; b = block { b }
  | i = instr ; b = block { i @ b }
  | LcloseAcc { [] }
;

instr:
| Lreturn ; e = expr ; Lsc { [ Return { expr = e ; pos = $startpos } ] }

| Lreturn ; Lsc {
  [ Return { expr = Val { value = Void ; pos = $startpos($2) }
            ; pos = $startpos } ]
  }
| Lprintf; LopenP; e = expr; LcloseP ; Lsc { 
  [ Printf { expr = e; pos = $startpos(e) } ]
  }
| Lscanf; LopenP; e = expr; LcloseP ; Lsc { 
  [ Scanf { expr = e; pos = $startpos(e) } ]
  }
| t = Ltype ; v = Lvar ; Lsc {
  [ Decl { name = v ; type_t = t ; pos = $startpos } ]
}
| t = Ltype ; v = Lvar ; Lassign ; e = expr ; Lsc
  { [ Decl { name = v ; type_t = t ; pos = $startpos(v) }
  ; Assign { var = v ; expr = e ; pos = $startpos($3) } ]
  }
| v = Lvar ; Lassign ; e = expr ; Lsc {
  [ Assign { var = v ; expr = e ; pos = $startpos($2) } ]
}
| Lif ; LopenP ; e = expr ; LcloseP ; b1 = block ; Lelse ; b2 = block {
  [ Cond { expr = e ; if_b = b1 ; else_b = b2 ; pos = $startpos } ]
}
| Lif ; LopenP ; e = expr ; LcloseP ; b = block {
  [ Cond { expr = e ; if_b = b ; else_b = [] ; pos = $startpos } ]
}
| Lwhile ; LopenP ; e = expr ; LcloseP ; b = block {
  [ Loop { expr = e ; block = b ; pos = $startpos } ]
}
;


expr:
| Lsub ; n = Lint { Val { value = Int (-n) ; pos = $startpos($1) } }
| Lint            { Val { value = Int ($1) ; pos = $startpos($1) } }
| Lbool           { Val { value = Bool ($1) ; pos = $startpos($1) } }
| Lstr            { Val { value = Str ($1) ; pos = $startpos($1) } }
| Lvar            { Var { name = $1 ; pos = $startpos($1) } }
| LopenP; e = expr; LcloseP { e }


| a = expr ; Ladd ; b = expr {
  Call { func = "%add" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lsub ; b = expr {
  Call { func = "%sub" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lmul ; b = expr {
  Call { func = "%mul" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Ldiv ; b = expr {
  Call { func = "%div" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lrem ; b = expr {
  Call { func = "%rem" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lseq ; b = expr {
  Call { func = "%seq" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lsge ; b = expr {
  Call { func = "%sge" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lsgt ; b = expr {
  Call { func = "%sgt" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lsle ; b = expr {
  Call { func = "%sle" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lslt ; b = expr {
  Call { func = "%slt" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lsne ; b = expr {
  Call { func = "%sne" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Land ; b = expr {
  Call { func = "%and" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| a = expr ; Lor ; b = expr {
  Call { func = "%or" ; args = [ a ; b ] ; pos = $startpos($2) }
}
| f = Lvar ; LopenP ; a = separated_list(Lvirgule, expr) ; LcloseP {
  Call { func = f ; args = a ; pos = $startpos }
}
;
