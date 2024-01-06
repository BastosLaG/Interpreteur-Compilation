(*semantics.ml*)
open Ast
open Ast.IR1
open Ast.V1
open Baselib
open Errors

let analyze_value = function
  | Syntax.Void -> Void, Void_t
  | Syntax.Int n -> Int n, Int_t
  | Syntax.Bool b -> Bool b, Bool_t
  | Syntax.Str s -> Str s, Str_t

let rec analyze_expr env varsNonAssign t = function
  | Syntax.Val v ->
    let checked_value, new_t = analyze_value v.value in
      if not (List.exists (fun t2 -> List.mem t2 [new_t; AnyType_t]) t)
      then errt t [new_t] v.pos;
    Val checked_value, new_t
  | Syntax.Var v ->
    if not (Env.mem v.name env)
    then raise (SemanticsError ("Variable non liée\"" ^ v.name ^ "\"", v.pos));
    if List.mem v.name varsNonAssign then warn ("Variable non assignée \"" ^ v.name ^ "\"") v.pos;
    let new_t = Env.find v.name env in
      if not (List.mem new_t t) then errt t [new_t] v.pos;
    Var v.name, new_t
  | Syntax.Call c ->
    if not (Env.mem c.func env)
      then raise (SemanticsError ("Fonction non liée \"" ^ c.func ^ "\"", c.pos));
    (match Env.find c.func env with
    | Func_t (type_retour, t_list) ->
      if not (List.exists (fun t2 -> List.mem t2 [type_retour; AnyType_t]) t)
        then errt [type_retour] t c.pos;
      if List.length t_list != List.length c.args
        then raise (SemanticsError (Printf.sprintf "La fonction \"%s\" attend %d arguments mais %d ont été donnés" c.func (List.length t_list) (List.length c.args), c.pos));
      let args =
        List.map2 (fun t2 e ->
            let e2, new_t = analyze_expr env varsNonAssign [t2] e in
            if new_t = t2
            then e2
            else
              errt
                [t2]
                [new_t]
                (match e with
                | Syntax.Val v -> v.pos
                | Syntax.Var v -> v.pos
                | Syntax.Call c -> c.pos))
          t_list
          c.args
      in
      Call (c.func, args), type_retour
    | _ -> raise (SemanticsError ("\"" ^ c.func ^ "\" n'est pas une fonction", c.pos)))

  
let rec analyze_instr env varsNonAssign type_retour = function
  | Syntax.Decl d -> Decl d.name, Env.add d.name d.type_t env, [d.name] @ varsNonAssign
  | Syntax.Assign a ->
    if not (Env.mem a.var env)
      then raise (SemanticsError ("Variable non assigné \"" ^ a.var ^ "\"", a.pos));
    let checked_expr, _ = analyze_expr env varsNonAssign [Env.find a.var env] a.expr in
      Assign (a.var, checked_expr), env, List.filter (fun x -> x <> a.var) varsNonAssign
  | Syntax.Cond c ->
    let cond, _ = analyze_expr env varsNonAssign [Bool_t; Int_t] c.expr in
    let if_b, _ = analyze_block env varsNonAssign AnyType_t c.pos c.if_b in
    let else_b, _ = analyze_block env varsNonAssign AnyType_t c.pos c.else_b in
      Cond (cond, if_b, else_b), env, []
  | Syntax.Loop l ->
    let cond, _ = analyze_expr env varsNonAssign [Bool_t; Int_t] l.expr in
    let block, _ = analyze_block env varsNonAssign AnyType_t l.pos l.block in
      Loop (cond, block), env, []
  | Syntax.Return r ->
    let checked_expr, _ = analyze_expr env varsNonAssign [type_retour] r.expr in
      Return checked_expr, env, []
  | Syntax.Printf p ->
    let checked_expr, _ = analyze_expr env varsNonAssign [Str_t; Int_t; Bool_t] p.expr in
      Printf checked_expr, env, []
  |Syntax.Scanf s ->
    let checked_expr, _ = analyze_expr env varsNonAssign [Str_t; Int_t; Bool_t] s.expr in
      Scanf checked_expr, env, []
and analyze_block env varsNonAssign type_retour pos = function
| [] ->
  if type_retour != Void_t && type_retour != AnyType_t
  then warn "Fonction non-void sans retour" pos;
  [], varsNonAssign
| instr :: new_block ->
  let new_instr, new_env, new_varsNonAssign = analyze_instr env varsNonAssign type_retour instr in
  (match new_instr with
  | Return _ -> [new_instr], new_varsNonAssign
  | _ ->
    let new_block, new_varsNonAssign2 = analyze_block new_env new_varsNonAssign type_retour pos new_block in
    new_instr :: new_block, new_varsNonAssign2)

let analyze_func env varsNonAssign = function
  | Syntax.Func f ->
    let add_fn = let rec add_args env2 = function
        | [] -> env2
        | h :: t ->(match h with
          | Syntax.Arg a -> add_args (Env.add a.name a.type_t env2) t)in
      Env.add
        f.func
        (Func_t(f.type_t, List.map(fun a ->
                 match a with
                 | Syntax.Arg a -> a.type_t) f.args ))(add_args env f.args)
                in
    let block, _ = analyze_block add_fn varsNonAssign f.type_t f.pos f.code in
    ( Func( f.func, List.map(fun a ->
              match a with
              | Syntax.Arg a -> a.name)f.args, block ), Env.add f.func(Func_t( f.type_t, List.map(fun a ->
                 match a with
                 | Syntax.Arg a -> a.type_t)f.args )) env )

let rec analyze_prog env varsNonAssign default = function
  | [] ->
    if fst default then [] else raise (SemanticsError ("Aucune fonction \"" ^ snd default ^ "\"", Lexing.dummy_pos))
  | fn :: suite ->
    let fn, new_env = analyze_func env varsNonAssign fn in
    let main_lbl = snd default in
    fn
    :: analyze_prog
         new_env
         varsNonAssign
         (if fst default then default else Env.mem main_lbl new_env, main_lbl)
         suite

let analyze parsed = analyze_prog _types_ [] (false, "main") parsed
