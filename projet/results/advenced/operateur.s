.text
.globl main
main:
addi $sp, $sp, -20
sw $ra, 16($sp)
sw $fp, 12($sp)
addi $fp, $sp, 16
li $v0, 1
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 2
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
add $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -8($fp)
li $v0, 2
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 1
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
sub $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -12($fp)
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $v0, -12($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
mul $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -16($fp)
lw $v0, -16($fp)
  b ret0
ret0:
addi $sp, $sp, 20
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
move $a0, $v0
li $v0, 1
  syscall
  jr $ra

.data
