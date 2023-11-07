.text
.globl main
main:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  li $t0, 1
  li $t1, 2147483648
loop003:
  bgeu $t0, $t1, loop003_end
  move $t2, $t0
loop002:
  ble $t2, $zero, loop002_end
  andi $t3, $t2, 1
  beq $t3, $zero, branch001_else
  li $v0, 4
  la $a0, diez
  syscall
  b branch001_end
branch001_else:
  li $v0, 4
  la $a0, espace
  syscall
branch001_end:
 sra $t2, $t2, 1
  b loop002
loop002_end:
  li $v0, 4
  la $a0, nl
  syscall
 sll $t4, $t0, 1
 xor $t0, $t0, $t4
  b loop003
loop003_end:
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

.data
nl: .asciiz "
"
diez: .asciiz "#"
espace: .asciiz " "
