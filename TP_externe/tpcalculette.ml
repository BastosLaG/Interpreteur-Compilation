type expr = 
  | Num of int
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | Mod of expr * expr

let rec format a =
  match a with
  | Num n -> Printf.sprintf "%d" n
  | Add (e1, e2) -> Printf.sprintf "(%s + %s)" (format e1) (format e2)
  | Sub (e1, e2) -> Printf.sprintf "(%s - %s)" (format e1) (format e2)
  | Mul (e1, e2) -> Printf.sprintf "(%s * %s)" (format e1) (format e2)
  | Div (e1, e2) -> Printf.sprintf "(%s / %s)" (format e1) (format e2)
  | Mod (e1, e2) -> Printf.sprintf "(%s %% %s)" (format e1) (format e2)


  let rec eval a =
    match a with
    | Num n -> n
    | Add (e1, e2) -> eval e1 + eval e2
    | Sub (e1, e2) -> eval e1 - eval e2
    | Mul (e1, e2) -> eval e1 * eval e2
    | Div (e1, e2) ->
        let eval_e2 = eval e2 in
        if eval_e2 = 0 then raise (Failure "Division par zero")
        else eval e1 / eval_e2
    | Mod (e1, e2) ->
        let eval_e2 = eval e2 in
        if eval_e2 = 0 then raise (Failure "Modulo par zero")
        else eval e1 mod eval_e2
  

let () = 
  let exp1 = Mul (Num 3, Add (Num 4, Num 5)) in
  let exp2 = Div (Num 8, Mod (Num 9, Num 2)) in
  let exp3 = Sub (Num 10, Mul (Num 2, Add (Num 3, Sub (Num 4, Num 5)))) in
  print_endline (format exp1);
  print_endline (format exp2);
  print_endline (format exp3);
  Printf.printf "%d\n" (eval exp1);
  Printf.printf "%d\n" (eval exp2);
  Printf.printf "%d\n" (eval exp3);

