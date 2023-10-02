(*
Exercice 0.
Cas de base.
1. Dans le cas de base le plus simple, une expression arithmétique consiste simplement en un nombre (on se
limitera aux entiers, int en OCaml).
→ Définissez un type expr avec un seul constructeur Num qui gère ce cas de base.
2. On aura besoin d’une fonction d’affichage pour notre type expr.
→ En utilisant la fonction sprintf du module Printf, écrivez une fonction format : expr -> string.
On pourra alors l’utiliser en faisant par exemple print_endline (format e) dans le cas ou e contient une
valeur de type expr.
3. → Écrivez maintenant notre fonction eval : expr -> int.
*)

type expr =
  | Num of int
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | Mod of expr * expr

let rec format e = 
  match e with
  | Num n -> Printf.sprintf"%d" n
  | Add (a,b) -> Printf.sprintf"%s + %s" (format a) (format b)
  | Sub (a,b) -> Printf.sprintf"%s - %s" (format a) (format b)
  | Mul (a,b) -> Printf.sprintf"%s * %s" (format a) (format b)
  | Div (a,b) -> Printf.sprintf"%s / %s" (format a) (format b)
  | Mod (a,b) -> Printf.sprintf"%s ^ %s" (format a) (format b)

let rec eval e = 
  match e with
  | Num n -> n
  | Add (a,b) -> (eval a) + (eval b)
  | Sub (a,b) -> (eval a) - (eval b)
  | Mul (a,b) -> (eval a) * (eval b)
  | Div (a,b) -> 
      let eval_b = eval b in 
        if eval_b = 0 then raise (Failure "Division par zéro")
        else eval a / eval_b
  | Mod (a,b) -> 
      let eval_b = eval b in 
        if eval_b = 0 then raise (Failure "Modulo par zéro")
        else eval a mod eval_b


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
