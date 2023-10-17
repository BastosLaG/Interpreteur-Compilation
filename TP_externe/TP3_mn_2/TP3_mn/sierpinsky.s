.data
    # Initialisation des variables
    hashtag: .asciiz "#"
    espace: .asciiz " "
    nl: .asciiz "\n"

.text
    main:
        addi $sp, $sp, -4
        sw   $ra, 0($sp)       # Sauvegarde du contexte de l'appelant sur le stack
        # Initialisation
        li $t0, 1             # x = 1
        li $t1, 2147483648            # $t1 = 2147483648 (condition de sortie)
        

    while_outer_loop:
        # Condition de sortie
        bgeu $t0, $t1, end_prog  # Si x >= 2147483648, sortir de la boucle
        move $t2, $t0  # n = x

        while_inner_loop:
            #condition de sortie 
            blez $t2, end_outer_loop # n <= 0 (condition de sortie)
            #condition if 
            andi $t3, $t2,1 #n & 1
            beq $t3,$zero,cd_else 
                cd_if : 
                    li $v0, 4
                    la $a0, hashtag
                    syscall
                    j end_inner_loop
                cd_else:
                    li $v0, 4
                    la $a0, espace
                    syscall
                
        end_inner_loop:
            srl $t2, $t2, 1
            j while_inner_loop

    end_outer_loop:
    # Le code après la boucle
        li $v0, 4
        la $a0, nl
        syscall
        sll $t4, $t0, 1
        xor $t0, $t0, $t4  #x ^= x << 1
        # Retourner au début de la boucle
        j while_outer_loop
    end_prog: 
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
                



        

    
