.text 

.globl main
.globl while_0

main : 
    addi $sp, $sp, -4 
    sw $ra, 0($sp)
    li $t0, 1  #x=1
while_0:
        bgtu $t0, 2147483648 , sortie_while_0
        move $t1, $t0           # n = x 
while_1:
    blez $t1, sortie_while_1 
    
    andi $t2, $t1, 1            # stock n&1

    beq $t2, 0, else_0          #if implicite , si t0 impaire

    li $v0, 4
    la $a0, diez                #print diez
    syscall

    j suite_0
    
    else_0: 
        li $v0, 4               #si t0 paire
        la $a0, space           #print space
        syscall 

    suite_0:
        srl $t1, $t1, 1 
        b while_1 
           
sortie_while_1:
    li $v0, 4
    la $a0, nl                  #print nl
    syscall 

    sll $t2, $t0, 1
    xor $t0, $t0, $t2
    b while_0

sortie_while_0:
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

.data 

diez:  .asciiz "#"
space: .asciiz " "
nl:  .asciiz "\n"