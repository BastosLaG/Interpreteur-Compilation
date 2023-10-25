open Mips
open Mips_helper


let () =
  print_asm Stdlib.stdout
    { text =
        def "main"
          (    
            [Li (T0, 1)]
            @[Li (T1, 2147483648)]
            @(loop (GTEUnsigned(T0,T1))
              (
                [Move(T2,T0)]
                @(loop (LEZero(T2))
                (
                    [Andi(T3,T2,1)]
                  @ (branch (NotEqual(T3, Zero))
                      ( print_str "hashtag")
                      ( print_str "espace" )
                    )
                  @[Srl (T2, T2, 1)]
                )
                )
                @ ( print_str "nl" )
                @  [Sll (T4, T0, 1)]
                @ [ Xor(T0, T0, T4)] 
              )
            )
          )
      
      ; data = [
      ("hashtag", Asciiz "#")
      ;("espace", Asciiz " ")
      (* ;("test", Asciiz "M") *)
      ;("nl", Asciiz "\\n") 
      ]
    }