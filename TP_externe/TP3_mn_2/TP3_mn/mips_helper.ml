open Mips

let print_str s =
  [ Li (V0, Syscall.print_str)
  ; La (A0, Lbl s)
  ; Syscall ]

let print_int r =
  [ Li (V0, Syscall.print_int)
  ; Move (A0, r)
  ; Syscall ]

let read_int r =
  [ Li (V0, Syscall.read_int)
  ; Syscall
  ; Move (r, V0) ]

let uniq =
  let counter = ref 0 in
  let gen_uniq_symbol s =
    incr counter ;
    Printf.sprintf "%s%03d" s !counter
  in gen_uniq_symbol

type cond_expr =
  | Equal of reg * reg
  | NotEqual of reg * reg
  | LTUnsigned of reg * reg
  | BiggerThan of reg * reg
  | GTEUnsigned of reg * reg
  | LEZero of reg 
   
let compile_cond expr lbl =
  match expr with
  | Equal (r1, r2) -> Bne (r1, r2, lbl)
  | NotEqual (r1, r2) -> Beq (r1, r2, lbl)
  | LTUnsigned (r1, r2) -> Bltu (r1, r2, lbl)
  | GTEUnsigned (r1, r2) -> Bgeu (r1, r2, lbl)
  | BiggerThan (r1, r2) -> Bgt (r1, r2, lbl)
  | LEZero (r1) -> Blez (r1, lbl)

let loop cond body =
  let name = uniq "loop" in
  [ Label name
  ; compile_cond cond (name ^ "_end") ]
  @ body
  @ [ B name
    ; Label (name ^ "_end") ]

let branch cond yes no =
  let name = uniq "branch" in
  [ compile_cond cond (name ^ "_else") ]
  @ yes
  @ [ B (name ^ "_end")
    ; Label (name ^ "_else") ]
  @ no
  @ [ Label (name ^ "_end") ]

let push lr =
  [ Addi (SP, SP, -4 * (List.length lr)) ]
  @ (List.mapi (fun i r -> Sw (r, Mem (SP, i * 4))) lr)

let pop lr =
  (List.mapi (fun i r -> Lw (r, Mem (SP, i * 4))) lr)
  @ [ Addi (SP, SP, 4 * (List.length lr)) ]

let def name body =
  [ Label name ]
  @ push [ RA ]
  @ body
  @ pop [ RA ]
  @ [ Jr RA ]
