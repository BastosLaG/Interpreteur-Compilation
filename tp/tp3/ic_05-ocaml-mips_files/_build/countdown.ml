open Mips
open Mips_helper

let () =
  print_asm Stdlib.stdout
    { text =
        def "countdown_rec"
          (branch (NotEqual (A0, Zero))
             (print_int A0
              @ [ Move (T0, A0) ]
              @ print_str "nl"
              @ [ Addi (A0, T0, -1)
                ; Jal "countdown_rec" ])
             (print_str "boum"))
        @ def "countdown_loop"
            (loop (NotEqual (A0, Zero))
               (print_int A0
                @ [ Move (T0, A0) ]
                @ print_str "nl"
                @ [ Addi (A0, T0, -1) ])
             @ print_str "boum")
        @ def "main"
            (print_str "from"
             @ read_int A0
             @ [ Jal "countdown_rec" ])
    ; data = [
        ("nl", Asciiz "\\n")
      ; ("boum", Asciiz "BOUM!\\n")
      ; ("from", Asciiz "Count from? ")
      ]
    }
