.text
.globl main
main:
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $fp, 4($sp)
addi $fp, $sp, 8
li $v0, 1312
sw $v0, -8($fp)
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 2
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
add $v0, $t0, $t1
addi $sp, $sp, 8
  b ret0
ret0:
addi $sp, $sp, 12
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
move $a0, $v0
li $v0, 1
  syscall
  jr $ra

.data
