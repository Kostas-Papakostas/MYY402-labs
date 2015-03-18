# Converts a (hex) ASCII string to a number
# lab03 of Computer Architecture course
#  at CSE.UoI.gr 

        .data
number:
        .word    0      # dummy initial value
inmsg:
        .asciiz "BADCAFE" 

        .globl main

        .text
main:   
        # Get address of input string
        la   $a0, inmsg
	lw  $s0, 0($a0)
	
        #################################
					        # Write your program here
        					# The following assumes the result is in $s0
       	#lw  $s0, 0($a0)
       	#li   $t0, 8
       	li   $t0, 7    	#7 ASCII characters
loop:
	srl  $t1, $s0, 24
        slti $t2, $t1,   57
        beq  $t2, $zero, over57
        j    save_i
over57:
        subi $t1, $t1, 55
        
save_i:
	sb   $t1, 0($a0)
        addi $a0, $a0, 1
        
        sll  $s0, $s0, 8   # Drop current leftmost digit
        addi $t0, $t0, -1  # Update loop counter
        bne  $t0, $0, loop # Still not 0?, go to loop
        
        #################################

        la   $a1, number # Address where the result should go to
	sw   $s0, 0($a1)

        # end the program
        li   $v0, 10
        syscall

