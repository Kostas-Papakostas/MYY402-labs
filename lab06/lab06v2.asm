
        .data
number:
        .word  15
       
        .globl main

        .text
main:   
	add $t1, $zero, $zero
	lw $t0,268500992($zero)
	add $t1,$t0,$t0
	sub $t3,$t1,$t0
	and $t5,$t3,$t0
	or $t6,$t3,$t1

	
	beq $zero,$zero,label1
label1:
	j label2
	
label2:
	sw $t0,($s0)
	beq $t4,$zero,label2
