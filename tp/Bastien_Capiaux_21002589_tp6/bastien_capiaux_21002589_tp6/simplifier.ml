open Ast

module MapString = Map.Make(String)

let collect_constant_strings code =
  let counter = ref 0 in
  let str_map = ref MapString.empty in
  let ccs_value = function
    | V1.Nil    -> V2.Nil, []
    | V1.Bool b -> V2.Bool b, []
    | V1.Int n  -> V2.Int n, []
    (*| V1.Str s  ->
                      incr counter;
                      V2.Data ("str" ^ string_of_int !counter),
                      ["str" ^ string_of_int !counter, s]*)
    | V1.Str s  ->
      let new_str, result =
        if MapString.mem s !str_map then
          let existing_value = MapString.find s !str_map in
          let prefixed_string = "string" ^ string_of_int existing_value in
          prefixed_string, []
        else
          let () = counter := !counter + 1 in
          let counter_value = !counter in
          let new_str = "string" ^ string_of_int counter_value in
          str_map := MapString.add s counter_value !str_map;
          new_str, [new_str, s]
      in
      V2.Data new_str, result
  in
  let rec ccs_expr = function
    | IR1.Value v ->
       let v, ccs = ccs_value v in
       IR2.Value v, ccs
    | IR1.Var v ->
       IR2.Var v, []
    | IR1.Call (f, args) ->
       let args2 = List.map ccs_expr args in
       let ccs = List.flatten (List.map (fun (_, s) -> s) args2) in
       IR2.Call (f, List.map (fun (e, _) -> e) args2), ccs
  in
  let ccs_lvalue = function
    | IR1.LVar v  ->
       IR2.LVar v, []
    | IR1.LAddr a ->
       let a2, ccs = ccs_expr a in
       IR2.LAddr a2, ccs
  in
  let rec ccs_instr = function
    | IR1.Decl v ->
       IR2.Decl v, []
    | IR1.Return e ->
       let e2, ccs = ccs_expr e in
       IR2.Return e2, ccs
    | IR1.Expr e ->
       let e2, ccs = ccs_expr e in
       IR2.Expr e2, ccs
    | IR1.Assign (lv, e) ->
       let lv2, ccs_lv = ccs_lvalue lv in
       let e2, ccs_e = ccs_expr e in
       IR2.Assign (lv2, e2), List.flatten [ ccs_lv ; ccs_e ]
    | IR1.Cond (t, y, n) ->
       let t2, ccs_t = ccs_expr t in
       let y2, ccs_y = ccs_block y in
       let n2, ccs_n = ccs_block n in
       IR2.Cond (t2, y2, n2), List.flatten [ ccs_t ; ccs_y ; ccs_n ]
  and ccs_block = function
    | [] -> [], []
    | i :: r ->
       let i2, ccs_i = ccs_instr i in
       let r2, ccs_r = ccs_block r in
       i2 :: r2, List.flatten [ ccs_i ; ccs_r ]
  in
  let ccs_def = function
    | IR1.Func (name, args, body) ->
       let body2, ccs = ccs_block body in
       IR2.Func (name, args, body2), ccs
  in
  let rec ccs_prog = function
    | [] -> [], []
    | d :: r ->
       let d2, ccs_d = ccs_def d in
       let r2, ccs_r = ccs_prog r in
       d2 :: r2, List.flatten [ ccs_d ; ccs_r ]
  in ccs_prog code

let simplify code =
  collect_constant_strings code

  