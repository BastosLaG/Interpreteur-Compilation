.text
.globl main
_add:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  add $v0, $t0, $t1
  jr $ra
_mul:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  mul $v0, $t0, $t1
  jr $ra
puti:
  lw $a0, 0($sp)
  li $v0, 1
  syscall
  jr $ra
geti:
  lw $a0, 0($sp)
  li $v0, 5
  syscall
  jr $ra
puts:
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  jr $ra
main:
  addi $sp, $sp, -16
  sw $ra, 12($sp)
  sw $fp, 8($sp)
  addi $fp, $sp, 12
  la $v0, string1
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puts
  addi $sp, $sp, 4
  jal geti
  addi $sp, $sp, 0
  sw $v0, -8($fp)
  la $v0, string1
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puts
  addi $sp, $sp, 4
  jal geti
  addi $sp, $sp, 0
  sw $v0, -12($fp)
  la $v0, string2
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puts
  addi $sp, $sp, 4
  lw $v0, -12($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $v0, -8($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal _add
  addi $sp, $sp, 8
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puti
  addi $sp, $sp, 4
  la $v0, string3
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puts
  addi $sp, $sp, 4
  la $v0, string4
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puts
  addi $sp, $sp, 4
  lw $v0, -12($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  lw $v0, -8($fp)
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal _mul
  addi $sp, $sp, 8
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puti
  addi $sp, $sp, 4
  la $v0, string3
  addi $sp, $sp, -4
  sw $v0, 0($sp)
  jal puts
  addi $sp, $sp, 4
  li $v0, 0
  b ret0
ret0:
  addi $sp, $sp, 16
  lw $ra, 0($fp)
  lw $fp, -4($fp)
  jr $ra

.data
string1: .asciiz "Enter a number: "
string2: .asciiz "The sum of your numbers is: "
string3: .asciiz "\n"
string4: .asciiz "The product of your numbers is: "
