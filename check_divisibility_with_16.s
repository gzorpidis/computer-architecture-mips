## check_divisibily_with_16.s

# Check if a number if divisible by 16 without using the 'div' function in mips

# Theory:
# For a number to be divisible by 16, the last 4 bits must be all zero's (2 ^ 4 = 16)
# Else the number is NOT divisible by 16
# (Same way a number is divisible by 2 if the last bit (2^0) is zero, else it not)
# In the same way, a number is divisible by 8 if the last 3 (2^3 = 8) bits are all zero

# Examples: 654,320 is, 16 is, 32 is, 123,457 is NOT, 17 is NOT

.data
	give_number:	.asciiz	"Give a number: \n"
	is_div: 		.asciiz "Number is divisible by 16!"
	is_not:			.asciiz "Number is NOT divisible by 16!"

.text
 	.globl __start
__start:


main:
	# print prompt text
	la $a0, give_number
	jal print_string

	# read the number, stores it in $v0
	jal read_int
	move $s0, $v0

	andi $s0, $s0, 0x0000000f
	beqz $s0, is	# if all digits are zero, the number is zero so divisible else not
	# Not divisible:
    la $a0, is_not
	jal print_string
	j Exit

is:
	la $a0, is_div
	jal print_string
	j Exit

Exit:
	li $v0, 10
	syscall

print_string:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 4
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

read_int:
	li $v0, 5
	syscall
	jr $ra