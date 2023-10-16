.text

.globl main

main:
    add $sp, $sp, -4
    sw $ra, ($sp)

    li $t0, 1  # x=1

while_loop_1:    # while x < 2147483648: # = 2**31

    bgtu $t0, 2147483648, exit_loop_1 
    move $t1, $t0

while_loop_2: # n > 0

    blez $t1, exit_loop_2 #si n <= 0 on quit la boucle 2
    and $t2, $t1, 1
    beqz $t2, pair 

    li $v0, 4
    la $a0, hashtag
    syscall
    jal continue_while_loop_2

pair:

    li $v0, 4
    la $a0, espace
    syscall

continue_while_loop_2:

    srl ,$t1, $t1, 1
    jal while_loop_2

exit_loop_2:

    li $v0, 4
    la $a0, nl
    syscall

    sll $t2, $t0, 1
    xor $t0, $t0, $t2
    jal while_loop_1

exit_loop_1:

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra




.data

hashtag:  .asciiz "#"
espace: .asciiz " "
nl:    .asciiz "\n"