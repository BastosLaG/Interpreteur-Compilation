.text
.globl main

countdown:
    add $sp, $sp, -4
    sw $ra, 0($sp)

    # if
    beq $a0, $zero, cd_else

    # if true
    li $v0, 1
    syscall

    move $t0, $a0
    li $v0, 4
    la $a0, nl
    syscall

    addi $a0, $t0, -1
    jal countdown

    # end_if
    b return

    # else
cd_else:
    li $v0, 4
    la $a0, boum
    syscall

return:
    lw $ra, 0($sp)
    add $sp, $sp, 4

    jr $ra

main:
    add $sp, $sp, -4
    sw $ra, ($sp)

    # print "Count from? "
    li $v0, 4
    la $a0, cf
    syscall

    # store l'input dans $v0
    li $v0, 5
    syscall
    move $t0, $v0

    move $a0, $t0
    jal countdown

    li $v0, 0

    lw $ra, 0($sp)
    add $sp, $sp, 4

    jr $ra


.data
nl: .asciiz "\n"
boum: .asciiz "BOUM!\n"
cf: .asciiz "Count from? " 
