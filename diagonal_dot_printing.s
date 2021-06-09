## diagonal_dot_printing.s
#	Print a given string with dots in diagonal
#	E.g.: "abcefgh"
#	Output:
# 	abcdefgh
# 	.bcdefgh
# 	a.cdefgh
# 	ab.defgh
# 	abc.efgh
# 	abcd.fgh
# 	abcde.gh
# 	abcdef.h
# 	abcdefg.


.data
	string: .space 21

.text
 	.globl __start
__start:


main:
	la $a0, string
	li $a1, 21	# where amount = length of the string + 1 for NULL char
	jal read_string
	jal string_read_cl
	jal strlen

	move $t1, $v0
	la $a0, string
	jal print_string
	jal print_endl

for_loop:
	move $t3, $a0

	li $t0, 0		# i = 0, start from character in position 0

Actions:
	
	add $s0, $a0, $t0	# get the address of the corresponding character
	lbu $s1, 0($s0)		# load the byte that is in that position
	li $t2, '.'			# load the dot character
	sb $t2, 0($s0)		# store in position
	
    # print the dotted string
	move $a0, $t3
	jal print_string
	jal print_endl

	sb $s1, 0($s0)		# restore the changed character

	addi $t0, $t0, 1 	# increment to what ever you have for incrementation

	bge $t0, $t1 , for_loop_exit
	j Actions 		# if we reached this we can iterate, so go back

for_loop_exit:

	j Exit

print_endl:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $v0, 4($sp)

	li $a0, '\n'
	li $v0, 11
	syscall

	lw $v0, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

string_read_cl:
	# input: a0 string
	# output: void(null), it replaces the enter will 0 IF IT'S THERE

	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $v0, 4($sp)		# save the v0 that's already here, it will be changed by strlen but we don't need to keep it
	sw $a0, 8($sp)		# save the v0 that's already here, it will be changed by strlen but we don't need to keep it
	sw $t0, 12($sp)		

	# no need to change the input of strlen, it gets a0 and we already have the string there
	jal strlen

	addi $v0, $v0, -1
	add $a0, $a0, $v0	# get the address of the byte what we will check to see if there is a \n there

	lbu $t0, 0($a0)		# place the character in the position we calculated into a0
	bne $t0, '\n', string_read_cl_exit	# if it's not a new_line, place null into it else exit
	sb $zero, 0($a0)		# store NULL into the position

	string_read_cl_exit:
		lw $t0, 12($sp)
		lw $a0, 8($sp)
		lw $v0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		jr $ra


read_string:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 8
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# move $a0, ... 	# where ... is the location of the string to be read OR use la (if loading from memory)
# jal print_string

print_string:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 4
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

print_int:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 1
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

strlen:
	addi $sp, $sp, -8	# save t0, a0 starting memory location
	sw $t0, 0($sp)
	sw $a0, 4($sp)		# save the starting memory location as it increments it inside it

	li $v0, -1

	strlen_iter:
		lbu $t0, ($a0)
		addi $a0, $a0, 1
		addi $v0, $v0, 1
		bnez $t0, strlen_iter

	strlen_exit:
		lw $t0, 0($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		jr $ra


Exit:
	li $v0, 10
	syscall



