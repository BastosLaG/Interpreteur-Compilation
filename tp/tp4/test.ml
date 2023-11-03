open Ast
open Interp
open Print 

let () = 
  let valeur1 = Int 54 in
  print_value valeur1;
  print_endline "";
  let valeur2 = Str "hola" in 
  print_value valeur2;
  print_endline "";
  let valeur4 = Void in 
  print_value valeur4;
  print_endline "";