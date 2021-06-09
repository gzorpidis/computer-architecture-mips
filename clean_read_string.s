## 	clean_read_string.s

# 	Removes ENTER character that is inserted before the NULL character in a string
# 	read by the user. Using strlen it goes to the last character and if it a '\n'
# 	it sets it to NULL
#	Complete preservance of all registers (it is a void function)
# 	In you main, call:
	# move $a0, ... # where ... is the location of the string to be edited
	# jal string_read_cl

# 	$a0 string input
# 	output: void(null), it replaces the '\n' character with NULL

string_read_cl:

	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $v0, 4($sp)		# save the v0 that's already here, it will be changed by strlen but we don't need to keep it
	sw $a0, 8($sp)		# save the v0 that's already here, it will be changed by strlen but we don't need to keep it
	sw $t0, 12($sp)		

	# no need to change the input of strlen, it gets a0 and we already have the string there
	jal strlen

	addi $v0, $v0, -1
	add $a0, $a0, $v0	# get the address of the byte what we will check to see if there is a \n there

	lbu $t0, 0($a0)						# place the character in the position we calculated into a0
	bne $t0, '\n', string_read_cl_exit	# if it's not a new_line exit, else
	sb $zero, 0($a0)					# store NULL into the position

	string_read_cl_exit:
		lw $t0, 12($sp)
		lw $a0, 8($sp)
		lw $v0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		jr $ra

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