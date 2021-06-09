## number_of_digits.s

# 	Get the number of digits of a number (integer)
# 	In your main call:
#	move $a0, ... or la $a0, ... (where (...) is the position (register or memory address) of the integer)
# 	jal get_number_of_digits


#	$a0		input integer
#	$v0		number of digits of the integer

get_number_of_digits:
	addi $sp, $sp, -12
	sw $ra , 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	move $s1, $a0

	move $v0, $zero
	li $s0, 10

	gnd_loop:
		div $s1,$s0             # n/10 and n%10
		mflo $t0				# quotient in $t0
		mflo $s1				# what is left in $s1, (could also do move $s1, $t0)
		addi $v0, $v0, 1		# increment counter
		bnez $t0, gnd_loop		# if the quotiens is NOT zero, continue

	lw $ra , 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra