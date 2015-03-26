# Calculates gcd of 2 numbers
# lab04 of Computer Architecture course
#  at CSE.UoI.gr 
# Konstantinos Papakostas 2399
        .data
n1:
        .word  462
n2:
        .word  1071
result:
        .word 0

        .globl main

        .text
main:   
        
        la   $s0, n1       # Get address of n1
        lw   $a0, 0($s0)   # Get n1
	
	#la   $s1, n2       # Get address of n1
        lw   $a1, 4($s0)   # Get n2
	
	add  $s0, $a0, $zero # x=n1
	add  $s1, $a0, $zero # x=n2
        
        jal  gcd

        la   $t0, result  # Address where the result should go to
        sw   $v0, 0($t0)

        # end the program
        li   $v0, 10
        syscall

		######################################
        # Write your code here for mod and gcd
mod:
	sw   $ra, 8($sp) #save the return address
	slt $t4, $a0, $a1  #is n1<n2?
	beq  $t4, $zero, gcd #checks if $t4 is 0, which means n1>=n2
	sub  $a0, $a0, $a1   #n1=n1=n2
	j mod #loop

gcd:
	sw   $ra, 4($sp) #save the return address
	slt $t1, $s0, $s1   # is n1<n2?
        bne  $t1, $zero, end     # checks if t1 is 0, then swaps
        
        # swap(a,b)
        add  $t2, $s0, $zero # temp=n1
        add  $s0, $s1, $zero # n1=n2
        add  $s1, $t2, $zero # n2=temp
	
	add  $s2, $a0, $zero # x=n1
	add  $s3, $a0, $zero # x=n2
	
	bne  $a1, $zero, mod #else :return gcd(b, mod(a,b))
	add $t3, $a1, $zero #if b==0 :return n1     
	
end:
	add $t8, $zero, $a0