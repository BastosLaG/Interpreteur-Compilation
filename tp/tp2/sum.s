.text
.globl main

main:
	li $v0, 4
  la $a0, num1q
  syscall

	li $v0, 5
  syscall
	move $t0, $v0

	li $t1, 0
	li $t2, 0
loop:
  beq $t2, $t0, end_loop
	addi $t2, $t2, 1
	add $t1, $t1, $t2
	b loop
end_loop:
	li $v0, 4
	la $a0, sum
	syscall

	move $a0, $t1
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, nl
	syscall
	
  li $v0, 10
  syscall

.data
num1q: .asciiz "Please enter a number: "
sum:   .asciiz "The sum of these numbers is: "
nl:    .asciiz "\n"
