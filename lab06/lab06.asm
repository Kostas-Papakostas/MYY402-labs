
        .data
number:
        .word  15
       
        .globl main

        .text
main:   
	add $t1, $zero, $zero
	lw $t0,268500992($zero)
	addi $t1,$t0,5
	sub $t3,$t1,$t0
	andi $t5,$t3,100
	ori $t6,$t3,1000
	slti $t4,$t3,4
	beq $t4,$zero,label1
	
	
label1:
	j label2
	
label2:
	addi $t4,$t3,9
