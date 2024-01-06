.text
.globl main
main:
addi $sp, $sp, -8
sw $ra, 4($sp)
sw $fp, 0($sp)
addi $fp, $sp, 4
la $v0, str0
move $a0, $v0
li $v0, 1
  syscall
li $v0, 0
  b ret0
ret0:
addi $sp, $sp, 8
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
move $a0, $v0
li $v0, 1
  syscall
  jr $ra

.data
str0: .asciiz "5"
