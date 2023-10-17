open Mips
open Mips_helper


let () =
  print_asm Stdlib.stdout
    { text =[
        def "while_inner_loop"
          (loop (LEZero(T2))
            (
              [Andi(T3,T2,1)]
              @(branch (Equal(T3, Zero))
                  ( print_str "espace")
                  ( print_str "hashtag" )
                )
                @[Srl (T2, T2, 1)]
            )
            )
        @def "while_outer_loop"
          (loop (GTEUnsigned(T0,T1))
            (
              [Move(T2,T0);
              Jal "while_inner_loop"]
              @ ( print_str "nl" )
              @  [Sll (T4, T0, 1)]
              @ [ Xor(T0, T0, T4)] 
            )
            )

      @ def "main"
          (
            push[RA]     
            @[Li (T0, 1)]
            @[Li (T1, 2147483648)]
            @ [Jal "while_outer_loop"]
            @ pop[RA]
            )
      ]
      ; data = [
      ("hashtag", Asciiz "#")
      ("espace", Asciiz " ")
      ("nl", Asciiz "\\n") 
      ]
    }