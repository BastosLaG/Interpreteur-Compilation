open Ast
open Print
open Interp
open Baselib

(* 
let valeur1 = Bool true;;
let valeur2 = Int 42;;
let valeur3 = Str "Test";;

print_value valeur1 ;;
print_value valeur2;;
print_value valeur3;;

let resultat1 = eval_value valeur1;;
let resultat2 = eval_value valeur2;;
let resultat3 = eval_value valeur3;;

print_value resultat1;;
print_value resultat2;;
print_value resultat3;; *)

let () =
  let test1 = Str "Hello, world!"
    in Print.print_const(Interp.eval_const test1);

  let code = [	Assign ("a", Value (Int 1312));
		Assign ("b", Var "a");
		Return (Var "b") ]
  in Print.print_const(Interp.eval code);

  let autre_test = Int 42 in 
  print_endline "valeur original: ";
  print_const autre_test;

