.text
.globl main
f_func:
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $fp, 4($sp)
addi $fp, $sp, 8
lw $v0, 8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $v0, 4($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
mul $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -8($fp)
lw $v0, -8($fp)
  b ret0
ret0:
addi $sp, $sp, 12
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
main:
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $fp, 4($sp)
addi $fp, $sp, 8
li $v0, 1
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 2
addi $sp, $sp, -4
sw $v0, 0($sp)
  jal f_func
addi $sp, $sp, 8
sw $v0, -8($fp)
la $v0, str0
move $a0, $v0
li $v0, 1
  syscall
lw $v0, -8($fp)
move $a0, $v0
li $v0, 1
  syscall
la $v0, str1
move $a0, $v0
li $v0, 1
  syscall
li $v0, 0
  b ret1
ret1:
addi $sp, $sp, 12
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
move $a0, $v0
li $v0, 1
  syscall
  jr $ra

.data
str0: .asciiz "x = "
str1: .asciiz "\n"
