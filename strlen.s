## strlen.s
# Get the number of characters in the string, excluding the '\0' character
# In you main function call:

# move $a0, ... or la $a0, ... (where (...) the position of the string in the memory)
# jal strlen


## Returns the number of character in the string, exluding the '\0' character
#  	$a0		String of characters that is NULL-TERMINATED
# 	$v0		String length of string in $a0

strlen:
	addi $sp, $sp, -8	# save t0, a0 starting memory location
	sw $t0, 0($sp)
	sw $a0, 4($sp)		# save the starting memory location as it increments it inside it

	li $v0, -1			# initialize counter with -1

	strlen_iter:
		lbu $t0, ($a0)			# get the current character
		addi $a0, $a0, 1		# add one to the current address (remember that characters are 8 bits = 1 byte long)
		addi $v0, $v0, 1		# add to the counter
		bnez $t0, strlen_iter	# if not zero, continue, else exit because we reached the end of the string

	strlen_exit:
		lw $t0, 0($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		jr $ra