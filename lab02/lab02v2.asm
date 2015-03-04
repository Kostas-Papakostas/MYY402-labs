# Palindrome detection in MIPS assembly using MARS
# for MYΥ-402 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou
#Konstantinos Papakostas 2399

        .globl main # declare the label main as global. 
        
        .text 
     
main:
        la         $s1, mesg         # get address of mesg to $s1
        addu       $s2, $s1,   $zero # $s2=$s1
loop:
        addiu      $s2, $s2,   1     # $s2=$s1 + 1
        lbu        $t0, 0($s2)       # get next character
        bne        $t0, $zero, loop  # repeat if char not '\0'
        # end of loop here
	andi 	   $t1, $s2, 0x1     
        addiu      $s2, $s2,  -1     # Adjust $s2 to point to last char
        lbu        $t9, 0($s2)
        
    ########################################################################
		addi	   $s4, $zero, 32   	#ascii code for space ($s4=32)
        addi       $a0, $zero, 1		#$a0=1
        addi       $t4, $zero, 1		#$t4=1
        addu       $s3, $s1,   $zero	#$s3=$s1
        beq 	   $t1, $zero, even		#check if number of letters is even
        j odd				#if not it jumps to odd
even:	
	lbu        $t8, 0($s3)		#finds the next character
	beq        $t8,$s4,sp1		#when it finds space branch with sp1
	lbu        $t9, 0($s2)		#finds the prevous character
	beq        $t9,$s4,sp2		#when it finds space branch with sp2
	bne	   $s2, $s3, exit	#check if the letters are NOT THE SAME,if NOT it continues from below
	sub	   $t3, $s2, $s3	#finds the distance of the pointers of the letters
	beq 	   $t3, $t4, palindrome	#checks if the distance is 1, if yes it exits(this means we reached the center of the word)
	addiu      $s2, $s2,  -1	#goes the pointer of letter one bit back
	addiu      $s3, $s3, 1		#goes a letter ahead
	j even

sp1: 
	addiu      $s3, $s3, 1     #ignores the space
	beq 	   $t1, $zero, even		#checks where to branch
	j odd							#again even or odd

sp2:
	addiu      $s2, $s2, -1    		#ignores the space
	beq 	   $t1, $zero, even		#checks where to branch
	j odd							#again even or odd
	
odd:

	lbu        $t8, 0($s3)		#finds the next character
	beq        $t8,$s4,sp1		#when it finds space branch with sp1
	lbu        $t9, 0($s2)		#finds the previous character
	beq        $t9,$s4,sp2		#when it finds space branch with sp2
	bne	   $t8, $t9, exit	#check if the letters are NOT THE SAME,if NOT, it continues from below
	sub	   $t3, $s3, $s2	#finds the distance of the pointers of the letters
	beq 	   $t3, $zero, palindrome #checks if the distance is 0(because the number of letters is odd),if yes it exits(this means we reached the center of the word)
	addiu      $s2, $s2,  -1	#goes the pointer of letter one bit back
	addiu      $s3, $s3, 1		#goes the pointer of letter one bit ahead
	j odd

palindrome:
	subi       $a0,$a0,1
	j exit                
        ########################################################################

        
exit: 
        addiu      $v0, $zero, 10    # system service 10 is exit
        syscall                      # we are outta here.
        
###############################################################################

        .data
mesg:   .asciiz "racecar"
