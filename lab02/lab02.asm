# Palindrome detection in MIPS assembly using MARS
# for MYΥ-402 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

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
        
        ########################################################################
        addi       $a0, $zero, 0	#$a0=1
        addi       $t4, $zero, 2	#$t4=1
        addu       $s3, $s1,   $zero	#$s3=$s1
        beq 	   $t1, $zero, even	#check if number of letters is even
        j odd				#if not it jumps to odd
even:	
	addiu      $s3, $s3, 1		#goes a letter ahead
	bne	   $s2, $s3, exit	#check if the letters are NOT THE SAME,if NOT it continues from below
	sub	   $t3, $s2, $s3	#finds the distance of the pointers of the letters
	beq 	   $t3, $t4, notpalen	#checks if the distance is 1, if yes it exits(this means we reached the center of the word)
	addiu      $s2, $s2,  -1	#goes the pointer of letter one bit back
	j even
        
odd:
	addiu      $s3, $s3, 1		#goes the pointer of letter one bit ahead
	bne	   $s2, $s3, exit	#check if the letters are NOT THE SAME,if NOT, it continues from below
	sub	   $t3, $s3, $s2	#finds the distance of the pointers of the letters
	beq 	   $t3, $t4, notpalen #checks if the distance is 0(because the number of letters is odd),if yes it exits(this means we reached the center of the word)
	addiu      $s2, $s2,  -1	#goes the pointer of letter one bit back
	j odd

notpalen:
	addi       $a0,$a0,1
	j exit                
        ########################################################################

        
exit: 
        addiu      $v0, $zero, 10    # system service 10 is exit
        syscall                      # we are outta here.
        
###############################################################################

        .data
mesg:   .asciiz "racecar"
