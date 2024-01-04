open Ast.Syntax
open Mips

module Env = Map.Make(String)

let _types_ = Env.of_seq(
  List.to_seq[
    ("%add", Func_t(Int_t,[Int_t;Int_t]));
    ("%sub", Func_t(Int_t,[Int_t;Int_t]));
    ("%mul", Func_t(Int_t,[Int_t;Int_t]));
    ("%div", Func_t(Int_t,[Int_t;Int_t]));
    ("%eq" , Func_t(Bool_t,[Int_t;Int_t]));
    ("%neq", Func_t(Bool_t,[Int_t;Int_t]));
  ]
)


let builtins =
  [
    Label "_printf"
    ; Lw (A0, Mem (SP, 0))
    ; Li (V0, Syscall.print_str)
    ; Syscall
    ; Jr RA

    ; Label "_scanf"
    ; Lw (A0, Mem (SP, 0))
    ; Li (V0, Syscall.read_str)
    ; Syscall
    ; Jr RA
    
    ; Label "_add"
    ; Lw (T0, Mem (SP, 0))
    ; Lw (T1, Mem (SP, 4))
    ; Add (V0, T0, T1)
    ; Jr RA

    ; Label "_sub"
    ; Lw (T0, Mem (SP, 0))
    ; Lw (T1, Mem (SP, 4))
    ; Sub (V0, T0, T1)
    ; Jr RA

    ; Label "_mul"
    ; Lw (T0, Mem (SP, 0))
    ; Lw (T1, Mem (SP, 4))
    ; Mul (V0, T0, T1)
    ; Jr RA
 
    ; Label "_div"
    ; Lw (T0, Mem (SP, 0))
    ; Lw (T1, Mem (SP, 4))
    ; Div (V0, T0, T1)
    ; Jr RA
 
    ; Label "_eq"
    ; Lw (T0, Mem (SP, 0))
    ; Lw (T1, Mem (SP, 4))
    ; Beq (T0, T1, "equal")
    ; Li (V0, 0)
    ; Jr RA
 
    ; Label "equal"
    ; Li (V0, 1)
    ; Jr RA
 
    ; Label "_neq"
    ; Lw (T0, Mem (SP, 0))
    ; Lw (T1, Mem (SP, 4))
    ; Beq (T0, T1, "notequal")
    ; Li (V0, 0)
    ; Jr RA
 
    ; Label "notequal"
    ; Li (V0, 1)
    ; Jr RA 
    
    ; Label "prog"

  ]

