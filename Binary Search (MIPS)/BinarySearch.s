.data 

original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of original list: "
str3: .asciiz "Enter a key to search for: "
str4: .asciiz "Content of sorted list: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"
strSpace: .asciiz "\n"
strSpacebar: .asciiz " "



.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	addi $sp, $sp -8
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	#read size of list from user
	syscall
	move $s0, $v0
	move $t0, $0
	la $s1, original_list
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	#read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	move $a0, $s1
	move $a1, $s0
	
	jal inSort	#Call inSort to perform insertion sort in original list
	
	sw $v0, 4($sp)
	li $v0, 4 
	la $a0, str2 
	syscall 
	la $a0, original_list
	move $a1, $s0
	jal printList	#Print original list
	li $v0, 4 
	la $a0, str4 
	syscall 
	lw $a0, 4($sp)
	jal printList	#Print sorted list
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	li $v0, 5	#read search key from user
	syscall
	move $a3, $v0
	lw $a0, 4($sp)
	jal bSearch	#call bSearch to perform binary search
	
	beq $v0, $0, notFound
	li $v0, 4 
	la $a0, strYes 
	syscall 
	j end
	
notFound:
	li $v0, 4 
	la $a0, strNo 
	syscall 
end:
	lw $ra, 0($sp)
	addi $sp, $sp 8
	li $v0, 10 
	syscall
	
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
#$a0 holds array pointer
#$a1 holds array size
printList:
	addi $sp, $sp, -12	#prolouge
	sw $ra, 0($sp)
	sw $a0, 4($sp)		#array pointer stored on 4($sp)
	sw $a1, 8($sp)		#size stored on 8($sp)
	
	move $t0, $zero		#clearing $t0 and $t1
	move $t1, $zero		#temp array pointer
	lw $t3, 4($sp)
	
printLoop:
	slt $t1, $t0, $a1
	beq $t1, $zero, printFinish
	li $v0, 1
	lw $a0, 0($t3)
	syscall			#prints ith array value
	la $a0, strSpacebar
	addi $v0, $zero, 4
	syscall			#prints a space
	addi $t3, $t3, 4
	addi $t0, $t0, 1
	j printLoop
	
printFinish:
	addi $v0, $zero, 4
	la $a0, strSpace 	#printing new line
	syscall
	lw $ra, 0($sp)		#epilouge
	addi $sp, $sp, 12
	jr $ra
	
	
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort:
	add $sp, $sp, -20	#prolouge
	sw $ra, 0($sp)
	sw $a0, 4($sp)		#pointer
	sw $a1, 8($sp)		#size
	lw $t0, 8($sp)
	la $s1, sorted_list	#empty list to store sorted array
	sw $s1, 16($sp)
inSetup:
	lw $t1, 0($a0)
	sw $t1, 0($s1)
	addi $a0, $a0, 4
	addi $s1, $s1, 4
	addi $t0, $t0, -1
	bgt $t0, $zero, inSetup
	lw $s1, 16($sp)		#refreshing sorted_list pointer to head
	add $t0, $zero, $a1	#new counter for swapping...
	addi $t0, $t0, -1	#...
swap:	
	ble $t0, $zero, sortFin
	lw $t1, 0($s1)
	lw $t2, 4($s1)							#NEED TO SWAP MORE###############################
	blt $t2, $t1, swapping
	addi $s1, $s1, 4
	addi $t0, $t0, -1
	j swap
swapping:
	ori $t7, $zero, 1	#probe that says that at least one of the values was out of place
	sw $t1, 4($s1)
	sw $t2, 0($s1)
	addi $s1, $s1, 4
	addi $t0, $t0, -1
	j swap
sortFin:
	move $t6, $t7		#saving probe for comparison...
	move $t7, $zero		#refresh probe
	add $t0, $zero, $a1	#new counter for swapping...
	addi $t0, $t0, -1	#...
	lw $s1, 16($sp)		#refreshing sorted_list pointer to head
	bne $t6, $zero, swap	#back to swapping if not everything is not sorted yet
	
	lw $v0, 16($sp)		#returning pointer to sorted_list
	add $s1, $zero, $zero	#flushing saved reg
	lw $ra, 0($sp)		#epilouge
	addi $sp, $sp, 20
	jr $ra
	
	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.
#a0 is list pointer, a1 is size, a3 is key value

#***//****IF $T1 and $T2 DONT CARRY OVER TRY USING SAVED REGISTERS****//*****
bSearch:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	lw $t2, 8($sp)		#getting current length / top
	bne $s7, $0, passSetup
	move $v0, $zero		#flusing $v0
	addi $s7, $zero, 1	#initial value of $s7
	j passScont
passSetup:
	mul $s7, $s7, 2		#exponentiating a counter for the bgt...bDone line
passScont:	
	sub $t3, $t2, $t1	#$t1 is the bottom
	div $t3, $t3, 2
	beq $t4, $zero, bAdd 
	mul $t3, $t3, 4
	sub $a0, $a0, $t3	#next position if lesser
	div $t3, $t3, 4
	j bCont			#next position if greater
bAdd:	mul $t3, $t3, 4
	add $a0, $a0, $t3
	div $t3, $t3, 4
bCont:  lw $t0, 0($a0)
	beq $a3, $t0, bDoneTRUE	#key found!
	bge $s7, $a1, bDone	#evaluating at the same place as last iteration; exit
	blt $a3, $t0, bLesser
#bGreater
	move $t4, $zero		#next position added
	add $t1, $t1, $t3	#bottom is old middle
	jal bSearch
	
bLesser:
	addi $t4, $zero, 1	#next position is subtracted
	sub $a1, $a1, $t3 
	jal bSearch
	j bDone
bDoneTRUE:
	addi $v0, $zero, 1
bDone:
	ori $v0, $v0, 0		#return value (0 or 1) in $v0
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
