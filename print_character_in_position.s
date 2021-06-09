## print_character_in_position.s
# 	Ask the user for a string
#	Then until terminated, ask for an integer and print in the console the corresponding character at the given position
#	E.g. if string is "abcdefg", for 1 print "a".
#	Terminate if: position asked for is 0, or position is larger than the string length


.data
	string:		.space 	21
	give_number:.asciiz "Position in string: "
	char_in_n: 	.asciiz "Character in that position is: "
	give_sting:	.asciiz	"Give a string: \n"


.text
 	.globl __start
__start:


main:
	# print prompt
	la $a0, give_sting
	jal print_string

	# reads the string
	la $a0, string	
	li $a1, 21	# where amount = length of the string + 1 for NULL char
	jal read_string
	jal string_read_cl
	jal strlen

	move $t7, $v0		# save the upper limit of the string character we can ask for

while_loop:
	
	# prompt for the int
	la $a0, give_number
	jal print_string

	jal read_int
	move $s0, $v0		# which character will be printed
	jal print_endl		# print new line character

	bgt $s0, $t7, while_loop_exit	# if we ask for a character larger than string length, terminate
	beqz $s0, while_loop_exit		# or if we ask for character 0
	# else continue

	addi $t0, $s0, -1	# get the actual position of the character (0-indexed)

	la $s1, string 		# load the base address
	add $t1, $s1, $t0	# add the corresponding offset

	la $a0, char_in_n	
	jal print_string

	lbu $t2, 0($t1)		# get the actual character in that position
	move $a0, $t2		# place it into a0, and call to print the character

	li $v0, 11			# prints character
	syscall

	jal print_endl		# and new line, for pretty formatting
	j while_loop

	
while_loop_exit:
	j Exit



# move $t0, $v0
read_int:
	li $v0, 5
	syscall
	jr $ra

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

print_string:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 4
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