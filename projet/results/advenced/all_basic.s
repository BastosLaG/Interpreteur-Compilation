.text
.globl main
main:
addi $sp, $sp, -24
sw $ra, 20($sp)
sw $fp, 16($sp)
addi $fp, $sp, 20
la $v0, str0
sw $v0, -8($fp)
li $v0, 15326
sw $v0, -12($fp)
li $v0, 1
sw $v0, -16($fp)
li $v0, 0
sw $v0, -20($fp)
li $v0, 0
  b ret0
ret0:
addi $sp, $sp, 24
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
move $a0, $v0
li $v0, 1
  syscall
  jr $ra

.data
str0: .asciiz "Hello world !"
