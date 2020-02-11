	.text
main:
	la	$a0,n1
	la	$a1,n2
	jal	swap
	li	$v0,1	# print n1 and n2; should be 27 and 14
	lw	$a0,n1
	syscall
	li	$v0,11
	li	$a0,' '
	syscall
	li	$v0,1
	lw	$a0,n2
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	li	$v0,10	# exit
	syscall

swap:	
	addi $sp, $sp, -4
	lw $t0, 0($sp)
	lw $v0, 0($a0)
	sw $v0, 0($t0)
	lw $v0, 0($a1)
	lw $v1, 0($t0)
	sw $v1, 0($a1)
	sw $v0, 0($a0)
	addi $sp, $sp, 4
	jr $ra

	.data
n1:	.word	14
n2:	.word	27
