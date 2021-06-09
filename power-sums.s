## Power sums.s
# Given a positive integer, print the number as sums of power of 10
# e.g. 137 = 1 * 10^2 + 3 * 10 ^ 1 + 7 * 10 ^ 0
# If zero is given, terminate
# Don't check for negative input

.data
		give:			.asciiz "Give a positive integer: \n"
		string_input:	.space	32			# space + 1 for NULL, και αν διαβάσεις αριθμό το length πάλι +1 αυτού που θέλουμε για το NULL character (άρα length == δεσμευμένες θέσεις)
		tens:			.asciiz "*10 ^"
		plus:			.asciiz " + "
		power_sums:		.asciiz "Power-Sum: "

##	main program

.text
 	.globl __start
__start:


main:
	
while:

	# prompt to give an integer
	la $a0, give
	jal print_string

	# read the integer
	jal read_int

	# and print it
	move $a0, $v0
	jal print_int

	# now time for the main process
	move $s0, $v0
	beqz $s0, exit 		# if it's zero, exit, else start the main loop

	jal print_endl
	la $a0, power_sums
	jal print_string

	move $t0, $zero		# $t0 = 0 to start off the iterator
	li 	 $t1, 10		# $t1 = 10 as we will keep dividing with 10

body:
 
	divu $s0, $t1				# divide current number with 10
	mfhi $t2					# t2 = (s0 % 10), we will have to store that later
	mflo $s0					# s0 = (s0 // 10), the remainder of the division is what is left of the number

	move $a0, $t2				# get the ascii number from the int and store that inside
	jal int_to_ascii_number

	sb $v0, string_input($t0)	# store into correct position
	addi $t0, $t0, 1			# increment counter for the address of the saving
	bnez $s0, body				# if quotient is not zero, keep going else print the results

	j print_results

while_exit:
	jal print_endl				# print new line after the power-sums
	j while						# and iterate, get the next number


print_results:
	# we want to start from the end of the string in which we save, and print backwords

	beqz $t0, while_exit
	addi $t0, $t0, -1	# t2-= 1

	lbu $a0, string_input($t0)
	li $v0, 11
	syscall

	la $a0, tens
	jal print_string

	move $a0, $t0
	jal print_int

	beqz $t0, print_results

	la $a0, plus
	jal print_string

	j print_results


int_to_ascii_number:
	addi $v0, $a0, 48
	jr $ra
						
###### terminate ###########
exit:
 		li $v0,10
 		syscall 	# bye!!

#############################################################


#### function to print new line character

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
#############################################################



####	print string function

## input => a0 buffer

# in your main, call:
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


#############################################################

####	print_int


# in your main, call:
	# move $a0, ... #where a0 it the position of the integer
	# jal print_int

print_int:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 1
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#############################################################

##########	read_int	####################################

## retrieve integer from v0

# in your main, call:
	# jal read_int
	# to retrieve number, do a move from v0 like:
	# move $t0, $v0

read_int:
	li $v0, 5
	syscall
	jr $ra
