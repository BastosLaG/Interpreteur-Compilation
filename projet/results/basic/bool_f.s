.text
.globl main
main:
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $fp, 4($sp)
addi $fp, $sp, 8
li $v0, 0
sw $v0, -8($fp)
li $v0, 0
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
