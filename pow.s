## pow.s

# 	Function to compute the (base) ^ (exponent) of integers
# 	arg1: exponent (in $a0)
# 	arg2: base (in $a1)

#	in your main call:
# 	move $a0, exp
# 	move $a1, base
# 	jal Power

# Power(exp, base)
pow:  
	move $a2, $a1				# hold the initial base in a register
pow_body:
	beqz $a0, pow_case_0    	# if power (exp) is zero, return 1
	li $t7, 1
	beq $a0, $t7, pow_case_1    # if the exp is 1, return
	mult $a1, $a2           	# multiply value so far ($a1) with the initial factor ($a2)
	mflo $a1                	# new value in a1
	addi $a0, $a0, -1   		# decrement exponent, so it stops then is gets to 1
	j pow_body					# compute again

pow_case_0:
	li $v0, 1   # set the result to 1
	jr $ra      # return 1

pow_case_1:
	move $v0, $a1
	jr $ra      # return calculated value