## print_character_n_times.s

#	Given a string and an integer (n) , print each character of the string "n" times
#	E.g.: if string is: "abcdefg", and n = 2
# 	Output is:
#	aabbccddeeffgg

.data
	string: .space 21
	prompt:	.asciiz "Give how many times a character will be printed: "
	give_sting:	.asciiz	"Give a string: \n"

###################################################
.text
 	.globl __start
__start:


main:
	la $a0, give_sting
	jal print_string

	# reads the string
	la $a0, string	
	li $a1, 21			# where amount = length of the string + 1 for NULL char
	jal read_string

	jal string_read_cl
	jal strlen
	move $t1, $v0

	la $a0, prompt
	jal print_string

	jal read_int
	move $s0, $v0		# how many times will each character be printed

	jal print_endl
	
    # nested for loops approach
    # we need an outter loop to keep track of where to stop printing
    # and an inner for loop to print each character "n" times

for_loop_outter:

	la $t3, string	# save the base address of the string
	li $t0, 0		# i = 0, starting from character 0

outter_for_actions:
	
	add $t4, $t3, $t0	# get the address of the character
	lbu $s1, 0($t4)		# load the byte that is in that position, to get the character

	move $a0, $s1		# get the character
	li $t2, 0			# j = 0, starting from 0

	print_characters:
		li $v0, 11
		syscall

	addi $t2, $t2, 1 		# j++
	bge $t2, $s0 , continue	#  if we have printed more or equal times as n break, else keep printing
	j print_characters

continue:
	addi $t0, $t0, 1 		# i++, move on to the next character

	bge $t0, $t1 , for_loop_exit	# if ( i < strlen(string) ) continue, else exit
	j outter_for_actions 		# if we reached this we can iterate, so go back

for_loop_exit:
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