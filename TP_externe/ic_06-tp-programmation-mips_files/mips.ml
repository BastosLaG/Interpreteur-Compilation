type reg =
  | Zero
  | SP
  | RA
  | V0
  | A0
  | A1
  | T0
  | T1
  | T2

type label = string

type loc =
  | Lbl of label
  | Reg of reg
  | Mem of reg * int

type instr =
  | Label of label
  | Li    of reg * int
  | La    of reg * loc
  | Sw    of reg * loc
  | Lw    of reg * loc
  | Sb    of reg * loc
  | Lb    of reg * loc
  | Srl   of reg * reg * int
  | Sll   of reg * reg * int
  | Move  of reg * reg
  | Addi  of reg * reg * int
  | Add   of reg * reg * reg
  | And   of reg * reg * int
  | Syscall
  | B     of label
  | Beq   of reg * reg * label
  | Bne   of reg * reg * label
  | Beqz  of reg * label  
  | Bgtu  of reg * int * label
  | Blez  of reg * label
  | Jal   of label
  | Jr    of reg
  | Xor   of reg * reg * reg

type directive =
  | Asciiz of string

type decl = label * directive

type asm = { text: instr list ; data: decl list }

module Syscall = struct
  let print_int = 1
  let print_str = 4
  let read_int = 5
  let read_str = 8
end

let ps = Printf.sprintf (* alias raccourci *)

let fmt_reg = function
  | Zero -> "$zero"
  | SP   -> "$sp"
  | RA   -> "$ra"
  | V0   -> "$v0"
  | A0   -> "$a0"
  | A1   -> "$a1"
  | T0   -> "$t0"
  | T1   -> "$t1"
  | T2   -> "$t2"

let fmt_loc = function
  | Lbl (l)    -> l
  | Reg (r)    -> fmt_reg r
  | Mem (r, o) -> ps "%d(%s)" o (fmt_reg r)

let fmt_instr = function
  | Label (l)        -> ps "%s:" l
  | Li (r, i)        -> ps "  li %s, %d" (fmt_reg r) i
  | La (r, a)        -> ps "  la %s, %s" (fmt_reg r) (fmt_loc a)
  | Sw (r, a)        -> ps "  sw %s, %s" (fmt_reg r) (fmt_loc a)
  | Lw (r, a)        -> ps "  lw %s, %s" (fmt_reg r) (fmt_loc a)
  | Sb (r, a)        -> ps "  sb %s, %s" (fmt_reg r) (fmt_loc a)
  | Lb (r, a)        -> ps "  lb %s, %s" (fmt_reg r) (fmt_loc a)
  | Srl (rd, rs ,i)  -> ps "  srl %s ,%s, %d" (fmt_reg rd) (fmt_reg rs) i
  | Sll (rd, rs ,i)  -> ps "  sll %s, %s, %d" (fmt_reg rd) (fmt_reg rs) i
  | Move (rd, rs)    -> ps "  move %s, %s" (fmt_reg rd) (fmt_reg rs)
  | Addi (rd, rs, i) -> ps "  addi %s, %s, %d" (fmt_reg rd) (fmt_reg rs) i
  | Add (rd, rs, rt) -> ps "  add %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Syscall          -> ps "  syscall"
  | And (rd, rs, i)  -> ps "  and %s, %s, %d" (fmt_reg rd) (fmt_reg rs) i
  | B (l)            -> ps "  b %s" l
  | Beq (rs, rt, l)  -> ps "  beq %s, %s, %s" (fmt_reg rs) (fmt_reg rt) l
  | Bne (rs, rt, l)  -> ps "  bne %s, %s, %s" (fmt_reg rs) (fmt_reg rt) l
  | Beqz (r, l)      -> ps "  beqz %s , %s" (fmt_reg r) l
  | Bgtu (r, i, l)   -> ps "  bgtu %s, %d, %s" (fmt_reg r) i l
  | Blez (r, l)      -> ps "  blez %s, %s" (fmt_reg r) l
  | Jal (l)          -> ps "  jal %s" l
  | Jr (r)           -> ps "  jr %s" (fmt_reg r)
  | Xor (rd, rs, ra) -> ps "  xor %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg ra)

let fmt_dir = function
  | Asciiz (s) -> ps ".asciiz \"%s\"" s

let print_asm oc asm =
  Printf.fprintf oc ".text\n.globl main\n" ;
  List.iter (fun i -> Printf.fprintf oc "%s\n" (fmt_instr i)) asm.text ;
  Printf.fprintf oc "\n.data\n" ;
  List.iter (fun (l, d) -> Printf.fprintf oc "%s: %s\n" l (fmt_dir d)) asm.data
