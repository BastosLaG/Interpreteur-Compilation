.text
.globl main
main:
  move $fp, $sp
  addi $fp, $sp, -16
printi:
  lw $a0, 0($sp)
  li $v0, 1
  syscall
  jr $ra
scani:
  lw $a0, 0($sp)
  li $v0, 5
  syscall
  jr $ra
printf:
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  jr $ra
scanf:
  lw $a0, 0($sp)
  li $v0, 8
  syscall
  jr $ra
_add:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  add $v0, $t0, $t1
  jr $ra
_sub:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  sub $v0, $t0, $t1
  jr $ra
_mul:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  mul $v0, $t0, $t1
  jr $ra
_div:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  div $v0, $t0, $t1
  jr $ra
_eq:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  beq $t0,$t1,equal
  li $v0, 0
  jr $ra
equal:
  li $v0, 1
  jr $ra
_neq:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  beq $t0,$t1,notequal
  li $v0, 0
  jr $ra
notequal:
  li $v0, 1
  jr $ra
prog:
  la $a0, str1
  sw $v0, 0($fp)
  li $v0, 15326
  sw $v0, -4($fp)
  li $v0, 0
  sw $v0, -8($fp)
  li $v0, 1
  sw $v0, -12($fp)

  move $a0, $v0
  li $v0, 1
  syscall
  jr $ra

.data
str1: .asciiz "Hello world !"
