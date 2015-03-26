# Converts a (hex) ASCII string to a number
# lab03 of Computer Architecture course
#  at CSE.UoI.gr 
#Konstantinos Papakostas 2399

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
       	li   $t0, 8    	#7 ASCII characters
       	li   $t3, 4	#half word
loop:
	srl  $t1, $s0, 24  #choose the two digit number(which is the ASCII code for a letter)
        slti $t2, $t1,   57  #$t1<58 whuck means it is not a letter
        beq  $t2, $zero, over57 #check if $t2 = 0 which means $t1 > 57 (so it is a letter)  
        beq  $t3, $zero, save_i2 #check if $t3 = 0 which means we check the rest of the letters
        j    save_i
over57:
        subi $t1, $t1, 55
        beq  $t3, $zero, save_i2 #the same as in line 26
        
save_i:
	 #store the byte in $t1
	add  $t4, $t4, $t1
	sll  $t4, $t4, 8
	sb   $t1, 0($a0)
	sll  $t1, $t1, 24			#move the hexadecimal character 6 bytes left
        addi $a0, $a0, 1
        
        sll  $s0, $s0, 8   # Drop current leftmost digit
        addi $t0, $t0, -1  # Update loop counter
        bne  $t0, $t3, loop # Still not 4?, go to loop
        
        subi  $t3, $t3, 4  #$t2=$t2-4=0
        lw  $s0, 0($a0)    #get the rest characters of the word
save_i2:
        #store the byte in $t1
	sb   $t1, 0($a0)
        addi $a0, $a0, 1
        
        sll  $s0, $s0, 8   # Drop current leftmost digit
        addi $t0, $t0, -1  # Update loop counter
        bne  $t0, $t3, loop # Still not 0?, go to loop
        #################################

        la   $a1, number # Address where the result should go to
	sw   $s0, 0($a1)

        # end the program
        li   $v0, 10
        syscall

