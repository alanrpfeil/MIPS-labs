        .data
n:      .word 12


        .text
main: 	add     $t0, $0, $zero
	addi    $t1, $zero, 1
	la      $t3, n
	lw      $t3, 0($t3)
fib: 	beq     $t3, $0, finish
	add     $t2,$t1,$t0
	move    $t0, $t1
	move    $t1, $t2
	subi    $t3, $t3, 1
	j       fib
finish: addi    $a0, $t0, 0
	li      $v0, 1		# you will be asked about what the purpose of this line for syscall 
	syscall			
	li      $v0, 10		
	syscall			

#Q1.) Under “.data” you put the values you’ll use. “.word” includes the size of the data, and .text is the code.
#Q2.) You check-off the box next to line 15 in the “execute” tab
#Q3.) You can press “F7“ or go to run > step once paused at a breakpoint.
#Q4.) You can check the value of the contents on the register tab's column of values (in hex)
#     You can modify the value by double-clicking on the value in hex and editing it.
#Q5.) n is at address 0x1001 (or 4097th address).  
#     You editline 2 to be:  n: .word 12 to retrieve the 13th fibonacci number (since it starts at 0).
#Q6.) It returns to the Operating System's control. You use it when you want to finish your program.