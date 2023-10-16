.text
.globl main

countdown_rec:               # attend son argument n dans $a0
    add $sp, $sp, -4
    sw $ra, 0($sp)           # sauvegarde de $ra sur la pile (push)

    beq $a0, $zero, cdr_else # test n != 0, sinon sauter au else
    li $v0, 1
    syscall                  # afficher n
    move $t0, $a0            # backup n dans $t0
    li $v0, 4
    la $a0, nl               # afficher retour a la ligne
    syscall
    add $a0, $t0, -1         # $a0 = n-1
    jal countdown_rec        # appel recursif
    b cdr_end                # saut apres le block du else
cdr_else:
    li $v0, 4
    la $a0, boum
    syscall                  # afficher BOUM

cdr_end:
    lw $ra, 0($sp)           # retablir $ra depuis la pile (pop)
    add $sp, $sp, 4
    jr $ra                   # return
### end countdown_rec

countdown_loop:              # attend son argument n dans $a0
cdl_loop:
    beq $a0, $zero, cdl_end  # test n != 0, sinon sauter apres la boucle
    li $v0, 1
    syscall                  # afficher n
    move $t0, $a0            # backup n dans $t0
    li $v0, 4
    la $a0, nl               # afficher retour a la ligne
    syscall
    add $a0, $t0, -1         # $a0 = n-1
    b cdl_loop               # retour au debut de la boucle
cdl_end:
    li $v0, 4
    la $a0, boum
    syscall                  # afficher BOUM
    jr $ra                   # return
### end countdown_loop

main:
    add $sp, $sp, -4
    sw $ra, 0($sp)           # sauvegarde de $ra sur la pile (push)

    li $v0, 4
    la $a0, cf
    syscall                  # afficher la question

    li $v0, 5
    syscall                  # lire n dans $v0

    move $a0, $v0            # countdown attend son argument dans $a0
    jal countdown_rec

    li $v0, 0                # main renverra 0

    lw $ra, 0($sp)
    add $sp, $sp, 4          # retablir $ra depuis la pile (pop)
    
    jr $ra                   # return
### end main

.data
nl: .asciiz "\n"
boum: .asciiz "BOUM!\n"
cf: .asciiz "Count from? "
