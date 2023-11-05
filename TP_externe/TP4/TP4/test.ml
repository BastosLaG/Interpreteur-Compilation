open Ast

let () =
(*let code = Str "Hello, world!"
  in Print.print_const(Interp.eval_const code)*)

  let code = [	Assign ("a", Value (Int 1312));
		Assign ("b", Var "a");
		Return (Var "b") ]
  in Print.print_const(Interp.eval code)