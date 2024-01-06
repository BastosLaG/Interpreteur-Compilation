(*mips.ml*)

type reg =
| Zero
| V0
| V1
| A0
| A1
| A2
| A3
| T0
| T1
| T2
| T3
| T4
| T5
| T6
| T7
| T8
| T9
| S0
| S1
| S2
| S3
| S4
| S5
| S6
| S7
| GP
| SP
| FP
| RA

type label = string

type loc =
  | Lbl of label
  | Mem of reg * int

  type instr =
  | Label of label
  | Li of reg * int
  | La of reg * loc
  | Sw of reg * loc
  | Lw of reg * loc
  | Move of reg * reg
  | Addi of reg * reg * int
  | Add of reg * reg * reg
  | Mul of reg * reg * reg
  | Sub of reg * reg * reg
  | Div of reg * reg * reg
  | Rem of reg * reg * reg
  | Abs of reg * reg
  | Seq of reg * reg * reg
  | Sge of reg * reg * reg
  | Sgt of reg * reg * reg
  | Sle of reg * reg * reg
  | Slt of reg * reg * reg
  | Sne of reg * reg * reg
  | And of reg * reg * reg
  | Or of reg * reg * reg
  | Syscall
  | B of label
  | Beq of reg * reg * label
  | Beqz of reg * label
  | Jal of label
  | Jr of reg
  


type directive =
  | Asciiz of string

type decl = label * directive

type asm = { text: instr list ; data: decl list }

module Syscall = struct
  let print_int = 1
  let print_str = 4
  let read_int = 5
  let read_str = 8
  let print_any = 7
  let sbrk = 9
  let exit = 10
end

let ps = Printf.sprintf (* alias raccourci *)

let fmt_reg = function
| Zero -> "$zero"
| V0 -> "$v0"
| V1 -> "$v1"
| A0 -> "$a0"
| A1 -> "$a1"
| A2 -> "$a2"
| A3 -> "$a3"
| T0 -> "$t0"
| T1 -> "$t1"
| T2 -> "$t2"
| T3 -> "$t3"
| T4 -> "$t4"
| T5 -> "$t5"
| T6 -> "$t6"
| T7 -> "$t7"
| T8 -> "$t8"
| T9 -> "$t9"
| S0 -> "$s0"
| S1 -> "$s1"
| S2 -> "$s2"
| S3 -> "$s3"
| S4 -> "$s4"
| S5 -> "$s5"
| S6 -> "$s6"
| S7 -> "$s7"
| GP -> "$gp"
| SP -> "$sp"
| FP -> "$fp"
| RA -> "$ra"
;;


let fmt_loc = function
  | Lbl l -> l
  | Mem (r, o) -> Printf.sprintf "%d(%s)" o (fmt_reg r)
;;

let fmt_instr = function
  | Label l           -> ps "%s:" l
  | Li (r, i)         -> ps "li %s, %d" (fmt_reg r) i
  | La (r, l)         -> ps "la %s, %s" (fmt_reg r) (fmt_loc l)
  | Sw (r, l)         -> ps "sw %s, %s" (fmt_reg r) (fmt_loc l)
  | Lw (r, l)         -> ps "lw %s, %s" (fmt_reg r) (fmt_loc l)
  | Move (rd, rs)     -> ps "move %s, %s" (fmt_reg rd) (fmt_reg rs)
  | Addi (rd, rs, i) -> ps "addi %s, %s, %d" (fmt_reg rd) (fmt_reg rs) i
  | Add (rd, rs, rt)   -> ps "add %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Mul (rd, rs, rt)   -> ps "mul %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sub (rd, rs, rt)   -> ps "sub %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Div (rd, rs, rt)   -> ps "div %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Rem (rd, rs, rt)   -> ps "rem %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Abs (rd, rs)      -> ps "abs %s, %s" (fmt_reg rd) (fmt_reg rs)
  | Seq (rd, rs, rt)   -> ps "seq %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sge (rd, rs, rt)   -> ps "sge %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sgt (rd, rs, rt)   -> ps "sgt %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sle (rd, rs, rt)   -> ps "sle %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Slt (rd, rs, rt)   -> ps "slt %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sne (rd, rs, rt)   -> ps "sne %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | And (rd, rs, rt)   -> ps "and %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Or (rd, rs, rt)    -> ps "or %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Syscall           -> ps "  syscall"
  | B l -> ps "  b %s" l
  | Beq (rd, rs, l)   -> ps "  beq %s, %s, %s" (fmt_reg rd) (fmt_reg rs) l
  | Beqz (r, l)       -> ps "  beqz %s, %s" (fmt_reg r) l
  | Jal l             -> ps "  jal %s" l
  | Jr r              -> ps "  jr %s" (fmt_reg r)
;;

let fmt_dir = function
  | Asciiz (s) -> ps ".asciiz \"%s\"" s

let emit oc asm =
  Printf.fprintf oc ".text\n.globl main\n";
  List.iter (fun i -> Printf.fprintf oc "%s\n" (fmt_instr i)) asm.text;
  Printf.fprintf
    oc
    "%s\n%s\n%s\n%s\n"
    (fmt_instr (Move (A0, V0)))
    (fmt_instr (Li (V0, 1)))
    (fmt_instr Syscall)
    (fmt_instr (Jr RA));
  Printf.fprintf oc "\n.data\n";
  List.iter (fun (l, d) -> Printf.fprintf oc "%s: %s\n" l (fmt_dir d)) asm.data
;;
