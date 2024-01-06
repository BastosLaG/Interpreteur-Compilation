.text
.globl main
main:
addi $sp, $sp, -28
sw $ra, 24($sp)
sw $fp, 20($sp)
addi $fp, $sp, 24
li $v0, 5
sw $v0, -8($fp)
li $v0, 10
sw $v0, -12($fp)
li $v0, -5
sw $v0, -16($fp)
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $v0, -16($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
sne $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -20($fp)
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $v0, -12($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
add $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -24($fp)
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
la $v0, str2
move $a0, $v0
li $v0, 1
  syscall
lw $v0, -16($fp)
move $a0, $v0
li $v0, 1
  syscall
la $v0, str1
move $a0, $v0
li $v0, 1
  syscall
la $v0, str3
move $a0, $v0
li $v0, 1
  syscall
lw $v0, -20($fp)
move $a0, $v0
li $v0, 1
  syscall
la $v0, str1
move $a0, $v0
li $v0, 1
  syscall
la $v0, str4
move $a0, $v0
li $v0, 1
  syscall
lw $v0, -12($fp)
move $a0, $v0
li $v0, 1
  syscall
la $v0, str1
move $a0, $v0
li $v0, 1
  syscall
la $v0, str5
move $a0, $v0
li $v0, 1
  syscall
lw $v0, -24($fp)
move $a0, $v0
li $v0, 1
  syscall
la $v0, str1
move $a0, $v0
li $v0, 1
  syscall
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
str0: .asciiz "La valeur de a est : "
str1: .asciiz "\n"
str2: .asciiz "L'inverse de a est : "
str3: .asciiz "a est différent de son inverse ? : "
str4: .asciiz "La valeur de b est : "
str5: .asciiz "La somme de a et b est : "
