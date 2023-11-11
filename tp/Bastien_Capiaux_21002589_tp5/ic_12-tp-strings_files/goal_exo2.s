.text
.globl main
main:
  addi $sp, $sp, -16
  sw $ra, 12($sp)
  sw $fp, 8($sp)
  addi $fp, $sp, 12
  la $v0, str4
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  addi $sp, $sp, 4
  lw $a0, 0($sp)
  li $v0, 5
  syscall
  addi $sp, $sp, 0
  sw $v0, -8($fp)
  la $v0, str4
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  addi $sp, $sp, 4
  lw $a0, 0($sp)
  li $v0, 5
  syscall
  addi $sp, $sp, 0
  sw $v0, -12($fp)
  la $v0, str3
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  addi $sp, $sp, 4
  lw $v0, -12($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $v0, -8($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  add $v0, $t0, $t1
  addi $sp, $sp, 8
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 1
  syscall
  addi $sp, $sp, 4
  la $v0, str1
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  addi $sp, $sp, 4
  la $v0, str2
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  addi $sp, $sp, 4
  lw $v0, -12($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $v0, -8($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  mul $v0, $t0, $t1
  addi $sp, $sp, 8
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 1
  syscall
  addi $sp, $sp, 4
  la $v0, str1
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  addi $sp, $sp, 4
  li $v0, 0
  b ret0
ret0:
  addi $sp, $sp, 16
  lw $ra, 0($fp)
  lw $fp, -4($fp)
  jr $ra

.data
str4: .asciiz "Enter a number: "
str2: .asciiz "The product of your numbers is: "
str3: .asciiz "The sum of your numbers is: "
str1: .asciiz "\n"
