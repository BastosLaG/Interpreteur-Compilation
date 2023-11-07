open Mips
open Mips_helper

let () =
  print_asm Stdlib.stdout
    { text =
        def "main"
        (
            [Li (T0, 1)]
          @ [Li (T1, 2147483648)] 
          @ (loop (BigOrEqualUsign(T0, T1)) 
            (
                [Move (T2, T0)] 
              @ (loop (LessOrEqual (T2, Zero))
                  (
                      [Andi (T3, T2, 1)]
                    @ (branch (NotEqual(T3, Zero))
                        ( print_str "diez" )
                        ( print_str "espace")
                      )
                      @  [Sra (T2, T2, 1)]
                  )
                )
              @ print_str "nl"
              @ [Sll (T4, T0, 1)]
              @ [Xor (T0, T0, T4)]
            )
          )
        )
    ; data = [
        ("nl", Asciiz "\n")
      ; ("diez", Asciiz "#")
      ; ("espace", Asciiz " ")
      ]
    }
