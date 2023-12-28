.text
.globl main
main:
  li $v0, 1312
  move $a0, $v0
  li $v0, 1
  syscall
  jr $ra

.data
