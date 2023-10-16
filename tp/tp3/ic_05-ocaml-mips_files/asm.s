.text
.globl main
countdown_rec:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  beq $a0, $zero, branch002_else
  li $v0, 1
  move $a0, $a0
  syscall
  move $t0, $a0
  li $v0, 4
  la $a0, nl
  syscall
  addi $a0, $t0, -1
  jal countdown_rec
  b branch002_end
branch002_else:
  li $v0, 4
  la $a0, boum
  syscall
branch002_end:
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
countdown_loop:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
loop001:
  beq $a0, $zero, loop001_end
  li $v0, 1
  move $a0, $a0
  syscall
  move $t0, $a0
  li $v0, 4
  la $a0, nl
  syscall
  addi $a0, $t0, -1
  b loop001
loop001_end:
  li $v0, 4
  la $a0, boum
  syscall
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
main:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  li $v0, 4
  la $a0, from
  syscall
  li $v0, 5
  syscall
  move $a0, $v0
  jal countdown_rec
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

.data
nl: .asciiz "\n"
boum: .asciiz "BOUM!\n"
from: .asciiz "Count from? "
