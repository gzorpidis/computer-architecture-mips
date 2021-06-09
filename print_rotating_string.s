## print_rotating_string.s
#	Given a string from the user, print all its rotated versions
#	one character at a time
#	e.g. if string is "abcefgh"
# 	Output must be:
# 	bcdefgha
# 	cdefghab
# 	defghabc
# 	efghabcd
# 	fghabcde
# 	ghabcdef
# 	habcdefg

.data
	string: .space 21


.text
 	.globl __start
__start:


main:
	la $a0, string
	li $a1, 21
	jal read_string
	jal string_read_cl
	jal strlen

	move $t1, $v0
	la $a0, string

for_loop:

	li $t0, 1		# start from position 1
	move $s1, $a0	# move starting position in $s1, we will need it later

	Actions:
		add $s0, $a0, $t0	# $s0 will store the address at which the first part of the string should be printed

		move $a0, $s0		
		jal print_string	# print starting from that position, until the end
		# now we will print right from where we left off, starting from the start of the string this time

		lbu $s2, 0($s0)		# save the character in the position we started the previous printing from
		sb $zero, 0($s0)	# put the NULL character there so the print from the starting position will stop there

		move $a0, $s1		# place the reserved position
		jal print_string
		jal print_endl

		sb $s2, 0($s0)		# restore the character we removed to put NULL

	addi $t0, $t0, 1 		# increment by 1 byte to get to the next character

	bge $t0, $t1 ,  for_loop_exit	# while ( i < strlen(string) ) continue, else exit

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


