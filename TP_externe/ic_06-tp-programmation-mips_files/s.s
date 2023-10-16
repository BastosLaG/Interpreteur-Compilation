.text
.globl main
main:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  li $t0, 1
while_loop_1:
  bgtu $t0, 2147483648, exit_loop_1
  move $t1, $t0
while_loop_2:
  blez $t1, exit_loop_2
  and $t2, $t1, 1
  beqz $t2 , pair
  jal print_hashtag
  jal continue_while_loop_2
pair:
  jal print_space
continue_while_loop_2:
  srl $t1 ,$t1, 1
  jal while_loop_2
exit_loop_2:
  jal print_nl
  sll $t2, $t0, 1
  xor $t0, $t0, $t2
  jal while_loop_1
exit_loop_1:
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

.data
hashtag: .asciiz "#"
espace: .asciiz " "
nl: .asciiz "
"
