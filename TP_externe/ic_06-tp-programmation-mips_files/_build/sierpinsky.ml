open Mips_helper
open Mips

let () =
  print_asm Stdlib.stdout
    {
      text =
        def "main"
          (push [RA]
           @ [ Li (T0, 1)
             ; Label "while_loop_1"
             ; Bgtu (T0, 2147483648, "exit_loop_1")
             ; Move (T1, T0)
             ; Label "while_loop_2"
             ; Blez (T1, "exit_loop_2")
             ; And (T2, T1, 1)
             ; Beqz (T2, "pair")
             ; Jal "print_hashtag"
             ; Jal "continue_while_loop_2"
             ; Label "pair"
             ; Jal "print_space"
             ; Label "continue_while_loop_2"
             ; Srl (T1, T1, 1)
             ; Jal "while_loop_2"
             ; Label "exit_loop_2"
             ; Jal "print_nl"
             ; Sll (T2, T0, 1)
             ; Xor (T0, T0, T2)
             ; Jal "while_loop_1"
             ; Label "exit_loop_1"]
           @ pop [RA]
           @ [Jr RA]);
      data =
        [
          ("hashtag", Asciiz "#");
          ("espace", Asciiz " ");
          ("nl", Asciiz "\n");
        ];
    }

let print_hashtag = print_str "hashtag"
let print_space = print_str "espace"
let print_nl = print_str "nl"
