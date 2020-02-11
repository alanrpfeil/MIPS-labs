main:
	li	$a0,4
	li	$a1,0
	jal	nchoosek		# evaluate C(4,0); should be 1
	jal	printv0
	li	$a0,4
	li	$a1,1
	jal	nchoosek		# evaluate C(4,1); should be 4
	jal	printv0
	li	$a0,4
	li	$a1,2
	jal	nchoosek		# evaluate C(4,2); should be 6
	jal	printv0
	li	$a0,4
	li	$a1,3
	jal	nchoosek		# evaluate C(4,3); should be 4
	jal	printv0
	li	$a0,4
	li	$a1,4
	jal	nchoosek		# evaluate C(4,4); should be 1
	jal	printv0
	li	$a0,4
	li	$a1,5
	jal	nchoosek		# evaluate C(4,5); should be 0
	jal	printv0
	li	$v0,10
	syscall

nchoosek:	# you fill in the prologue
	
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

  #Save $s0, $s1, $s2, #ra on $sp

	beq	$a1,$0,return1
	beq	$a0,$a1,return1
	beq	$a0,$0,return0
	blt	$a0,$a1,return0

	addi	$a0,$a0,-1		# C(n,k) = C(n-1,k) + C(n-1,k-1)
	move	$s0,$a0
	move	$s1,$a1
	jal	nchoosek
	move	$s2,$v0
	move	$a0,$s0
	addi	$a1,$s1,-1
	jal	nchoosek
	add	$v0,$v0,$s2
	j	return
return0:
	move	$v0,$0
	j	return
return1:
	addi	$v0,$0,1
	
return:		# you fill in the epilog
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra

printv0:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	move	$a0,$v0
	li	$v0,1
	syscall
	li	$a0,'\n'
	li	$v0,11
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra
