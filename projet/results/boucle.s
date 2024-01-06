.text
.globl main
main:
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $fp, 4($sp)
addi $fp, $sp, 8
li $v0, 100
sw $v0, -8($fp)
while1:
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 0
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
sgt $v0, $t0, $t1
addi $sp, $sp, 8
  beqz $v0, endwhile1
la $v0, str0
move $a0, $v0
li $v0, 1
  syscall
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, 1
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
sub $v0, $t0, $t1
addi $sp, $sp, 8
sw $v0, -8($fp)
  b while1
endwhile1:
lw $v0, -8($fp)
addi $sp, $sp, -4
sw $v0, 0($sp)
li $v0, -1
addi $sp, $sp, -4
sw $v0, 0($sp)
lw $t0, 4($sp)
lw $t1, 0($sp)
seq $v0, $t0, $t1
addi $sp, $sp, 8
  beqz $v0, else2
la $v0, str1
move $a0, $v0
li $v0, 1
  syscall
  b endif2
else2:
la $v0, str2
move $a0, $v0
li $v0, 1
  syscall
endif2:
li $v0, 0
  b ret0
ret0:
addi $sp, $sp, 12
lw $ra, 0($fp)
lw $fp, -4($fp)
  jr $ra
move $a0, $v0
li $v0, 1
  syscall
  jr $ra

.data
str0: .asciiz "Je déteste la compilation"
str1: .asciiz "Je déteste vraiment la compilation"
str2: .asciiz "c'est pas si mal enfaite"
