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

let rec format e = 
  match e with
  | Num n -> Printf.sprintf"%d" n
  | Add (a,b) -> Printf.sprintf"%s + %s" (format a) (format b)

let rec eval e = 
  match e with
  | Num n -> n
  | Add (a,b) -> (eval a) + (eval b)


let () = 
  let exp = Add(Num 1300, Add(Num 2, Num 4)) in
  print_endline(format exp) ;
  Printf.printf "%d\n" (eval exp) 


