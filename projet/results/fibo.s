.text
.globl main
main:
addi $sp, $sp, -28
sw $ra, 24($sp)
sw $fp, 20($sp)
addi $fp, $sp, 24
li $v0, 5
sw $v0, -8($fp)
li $v0, 0
sw $v0, -12($fp)
li $v0, 1
sw $v0, -16($fp)
la $v0, str0
move $a0, $v0
li $v0, 1
  syscall
li $v0, 0
sw $v0, -24($fp)
while1:
lw $v0, -24($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
slt $v0, $t0, $t1
addi $sp, $sp, 8
  beqz $v0, endwhile1
lw $v0, -24($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 1
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
sle $v0, $t0, $t1
addi $sp, $sp, 8
  beqz $v0, else2
lw $v0, -24($fp)
sw $v0, -20($fp)
  b endif2
else2:
lw $v0, -12($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $v0, -16($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
add $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -20($fp)
lw $v0, -16($fp)
sw $v0, -12($fp)
lw $v0, -20($fp)
sw $v0, -16($fp)
endif2:
lw $v0, -20($fp)
move $a0, $v0
li $v0, 1
  syscall
la $v0, str1
move $a0, $v0
li $v0, 1
  syscall
lw $v0, -24($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 1
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
add $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -24($fp)
  b while1
endwhile1:
li $v0, 0
  b ret0
ret0:
addi $sp, $sp, 28
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
move $a0, $v0
li $v0, 1
  syscall
  jr $ra

.data
str0: .asciiz "Fibonacci Series:\n"
str1: .asciiz "\n"
