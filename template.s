#########################################################
#														#
#				unsigned numbers overflow 				#
#					check program		 				#
#														#
#########################################################

## know if addition of two unsigned ints overflowed
#	a0 => one int
# 	a1 => second int

#	$v0 = 0 if no overflow occured, or 1 if it did

unsigned_values_overflow:
	addu $t0, $a0, $a1
	nor $t3, $a0, $zero

	sltu $v0, $t3, $a1
	jr $ra


#########################################################
#														#
#				give ascii number character				#
#				return its int value 					#
#														#
#########################################################


##	Given a character of a number (0-9)
#	returns the actual int value of the number
# 	$a0 => ascii character
#	$v0 => int_value 

ascii_number_to_int:
	sub $v0, $a0, '0'
	jr $ra




#########################################################
#														#
#				give int value 							#
#				return its ascii character				#
#														#
#########################################################

# a0 => int number
# v0 => ascii character of the number

int_to_ascii_number:
	addi $v0, $a0, 48
	jr $ra





#########################################################
#														#
# 		check if a a number is prime or NOT 			#
#														#
#########################################################


## Tells if a number is prime
# $a0	The number to check if it's prime
# $v0	1 if the number is prime, 0 if it's not

is_prime:
	addi	$t0, $zero, 2				# int x = 2
	
is_prime_test:
	slt	$t1, $t0, $a0				# if (x > num)
	bne	$t1, $zero, is_prime_loop		
	addi	$v0, $zero, 1				# It's prime!
	jr	$ra						# return 1

is_prime_loop:						# else
	div	$a0, $t0					
	mfhi	$t3						# c = (num % x)
	slti	$t4, $t3, 1				
	beq	$t4, $zero, is_prime_loop_continue	# if (c == 0)
	add	$v0, $zero, $zero				# its not a prime
	jr	$ra							# return 0

is_prime_loop_continue:		
	addi $t0, $t0, 1				# x++
	j	is_prime_test				# continue the loop

###======= prime checker (mine)

prime_checker:
	# number in a0
	# output in v0 => 0 (is prime), v1 => not prime

	li $t0, 2		# i = 2 to start with
	div $a0, $t0	# get the upper bound
	mflo $t1		# πάρε το πηλίκο στον t1, και αυτός σηματοδοτεί το πού πρέπει να σταματήσει
					# $t1 = (n/2)
	move $v0, $zero	# flag = 0 to start with

pc_loop:
	
	div $a0, $t0	# get n % i
	mfhi $t2

	beq $t2, $zero, pc_break

	addi $t0, $t0, 1

	bgt $t0, $t1, pc_exit
	j pc_loop

pc_break:
	addi $v0, $v0, 1

pc_exit:
	jr $ra








#########################################################
#				power function (pow	)					#
#														#
#	   calculate the power of a base to an exponent		#
#														#
#########################################################

# arg1: exponent (in a0)
# arg2: base (in a1)

#in your main call:
# move $a0, exp
# move $a1, base
# jal Power

# Power(exp, base)
power: 
	addi $sp, $sp, -4
	sw $s7, 0($sp)

	move $a2, $a1

power_loop:
	beqz $a0, exp_0    	# if power is zero, return 1
	li $s7, 1
	beq $a0, $s7, exp_1    # if the exp is 1 go to return 
	mult $a1, $a2           # multiply value so far with the initial factor
	mflo $a1                # new value in a1
	addi $a0, $a0, -1   	# decrement exponent
	j power_loop

exp_0:
	li $v0, 1   # set the result to 1

	lw $s7, 0($sp)
	addi $sp, $sp, 4

	jr $ra      # return 1

exp_1:
	move $v0, $a1
	jr $ra      # return calculated value




# Program that calculates the sum of the digits in base 10 of an integer. 
#   The number is given in a variable n declared in the data initialization words 
#   in the program, the final amount will be stored in a word type variable s.



# digit sum

.text
main:
	lw $t0,n 		# place number into t0
	addi $t1,$zero,10
	move $t4, $zero

imparte:
	div $t0,$t1             #n/10 and n%10
	mflo $t0                #n=n/10
	mfhi $t3                #digit=n%10
	add $t4,$t4,$t3         #s=s+digit
	bne $t0,$zero,imparte   #if n!=0

sfarsit:
	sw $t4,s
	li $v0,10
	syscall


#########################################################
#				number of digits of an int				#
#														#
#	   get the number of digits of an integer function	#
#														#
#########################################################


####------ get number of digits function --------------
## in a0, put the number

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


###===========

#########################################################
#														#
# 	print binary representation inside a register      	#
#														#
#########################################################



# put the desired input into $a0
# and how many times you want to iterate into $a1 (max == 32)
# call jal print_binary
# it prints from LEFT to RIGHT

print_binary:
	addi	$sp, $sp, -20
	sw	$ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move	$s0, $a0
	addi	$s1, $zero, 31	# constant shift amount
	addi	$s2, $zero, 0	# variable shift amount
	move	 $s3, $a1		# exit condition
	
print_binary_loop:
	beq	$s2, $s3, print_binary_done
	sllv	$a0, $s0, $s2
	srlv	$a0, $a0, $s1
	li	$v0, 1		# PRINT_INT
	syscall
	addi	$s2, $s2, 1
	j	print_binary_loop
print_binary_done:
	li	$v0, 4
	la	$a0, newline_string
	syscall

	lw	$ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi	$sp, $sp, 20

	jr	$ra


#########################################################
## 		For Loop ::: ##
## for loops
# 
# for(int x = 0; x<=3; x++)
# {
#    // Do something!
# }
#


for_loop:

	li $t0, 0	# change 0 to any other starting position you could be at

	Actions:
		# loop body code
		# ...
	
	addi $t0, $t0, 1 # increment to what ever you have for incrementation

	# προσοχή, πρέπει να είναι το αντίθετο της συνθήκης
	bgt $t0, ... ,  for_loop_exit	# x = lt, gt, le, ge, eq, ne, eqz, ..., if false => exit

	j Actions 		# if we reached this we can iterate, so go back

for_loop_exit:
	# do ...

#########################################################
## 		Switch Case::: ##

	# in you main, call:
	jal switch_case

# =========== Start of switch case code ============

switch_case:

	# for jr $ra (break) to return correctly,make sure if you call any other function(s)
	# you first save the ra into the stack

	switch_case_save_ra:
			addi $sp, $sp, -4
			sw $ra, 0($sp)		# store the return address into the stack
	
	### cases:

	case1:	# action for case number 1
	

		b{x}, $t0, ... , case2	#branch condition, if false -> next case && don't execute the code below

		# case1 actions...

		j case2
		# OR
		j switch_case_break

	case2:	# action for case number 2

		b{x}, $t0, ... , case3	#branch condition, if false -> next case && don't execute the code below

		# case1 actions...
		j case3 
		# OR
		j switch_case_break

	case3:	# action for case number 3

		b{x}, $t0, ... , caseN	#branch condition, if false -> next case && don't execute the code below

		j caseN
		# OR
		j switch_case_break

switch_case_break:
		# break safely by restoring the sp
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra

# =========== End of Switch Case =================



# ============ Do While  loops ===================

### do_while() loop
# do {
#	// Actions
# } while (condition);

### do-while

do_while_body:
	# actions...

	b{x}, ..., ..., do_while_exit 	# if condition is false exit, else
	j do_while_body					# continue by looping

do_while_exit:
	# code after do_while loop...

## ======= end of do_while loops =============


switch_case:

	# for jr $ra (break) to return correctly,make sure if you call any other function(s)
	# you first save the ra into the stack

	switch_case_save_ra:
			addi $sp, $sp, -4
			sw $ra, 0($sp)		# store the return address into the stack
	
	### cases:

	case1:	# action for case number 1
	

		# case1 actions...

		j case2
		# OR
		j switch_case_break

	case2:	# action for case number 2

		b{x}, $t0, ... , case3	#branch condition, if false -> next case && don't execute the code below

		# case1 actions...
		j case3 
		# OR
		j switch_case_break

	case3:	# action for case number 3

		b{x}, $t0, ... , caseN	#branch condition, if false -> next case && don't execute the code below

		j caseN
		# OR
		j switch_case_break

switch_case_break:
		# break safely by restoring the sp
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra


#########################################################
#														#
#				Strlen Function::: 					   	#
#														#
#########################################################


## returns the length of a string (every character,  not counting the NULL)

# input: string (char*) into a0 BEFORE CALLING, preserve what is before at your own risk
# output: int into v0
# preserves t0, doesn't preserve ra because I don't call any other function inside it

	# in you main, call:
	# move $a0, ... # where ... is the location of the string to be counted
	# jal strlen

# ==== strlen start ================

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

# =============== end of strlen function =================





#########################################################
#														#
##	 		Clean String Read Function::: 			   ##
#														#
#########################################################

# removes ENTER that was put before the NULL character in a string
# inserted by the user. Using strlen it goes to the last character and if it a '\n'
# it sets it to NULL, complete preservance of all registers (it is a void function)

# in you main, call:
	move $a0, ... # where ... is the location of the string to be edited
	jal string_read_cl

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

# =============== end of string_read_cl function =================




#########################################################
#														#
##	 		Print '\n' character 			   		   ##
#														#
#########################################################

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





###########################
## read string function  ##
###########################

## input => a0 buffer, a1 length

# in you main, call:
	move $a0, ... 	# where ... is the location of the string to be read 
	# OR use la (if loading from memory)

	li $a1, amount	# where amount = length of the string + 1 for NULL char
	jal read_string

read_string:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 8
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

### === end of read string function========================






###############################
## print string function     ##
###############################

## input => a0 buffer

# in you main, call:
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

### === end of PRINT string function========================





############################################################
#			print integer                                  #
############################################################


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


############################################################
#			read integer	                               #
############################################################

## retrieve integer from v0

# in your main, call:
	# jal read_int
	# to retrieve number, do a move from v0 like:
	# move $t0, $v0

read_int:
	li $v0, 5
	syscall
	jr $ra

#############################################################
#           read float                                     ##
#############################################################


# result in $f0
read_float:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 6
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#############################################################
#           read double                                    ##
#############################################################

# result in $f0 & f1
# caution:::
# 0-31 (lower) in f0	
# 32-61 (high) in f1
read_double:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 7
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#############################################################
#           print float                                    ##
#############################################################

# place float in $f12
print_float:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 2
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#############################################################
#           print double                                   ##
#############################################################

# place float in $f12
print_double:
	addi $sp, $sp, -4
	sw $v0, 0($sp)

	li $v0, 3
	syscall

	lw $v0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#############################################################
#           print double immidiate                         ##
#############################################################

##	in your main call:
# li.d $f12, -1.5					# ???  --> immediate, e.g -1.2345678
# jal print_double_immidiate

print_double_immidiate:	
					li $v0, 3
					syscall
					jr $ra

#############################################################
#############################################################

	
### function to find the min and max of an array ============
## προσοχή στο ότι το a1 πρέπει να έχει μέσα τον integer του size, όχι διεύθυνση
## το a0 πρέπει να είναι η διεύθυνση του array στην μνήμη

find_min_max_array:
	# a0 => array position
	# a1 => length, NOT THE ADDRESS, it doesn't derefence it inside

	# returns v0 => min
	# v1 => max

	# preserve: t0, t1, t2, t3, s0, s1
	addi $sp, $sp, -24 # 6 * 4 = 24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $s0, 16 ($sp)
	sw $s1, 20($sp)

	lw $t0, 0($a0)	# load the first element into t0

	move $s0, $t0	# min = array[0]
	move $s1, $t0	# max = array[0]

	for_loop:

		li $t0, 1	# start from second position of the array

		Actions:
			sll $t1, $t0, 2		# get the bytes of the incrementation
			add $t2, $a0, $t1	# add the incremented pointer into the base
			lw $t3, 0($t2)		# get the element in the calculated position
			
			check_max:
				ble, $t3, $s1, check_min	# if current_element <= max, check min
				move $s1, $t3				# else (current_element > max) then max = current_element

			check_min:
				bge $t3, $s0, action_exit	# if (current_element >= min) exit
				move $s0, $t3				# else (current_element < min) then min = current_element

		action_exit:
		addi $t0, $t0, 1 		# increment to what ever you have for step

		# προσοχή, πρέπει να είναι το αντίθετο της συνθήκης
		bge $t0, $a1 , for_loop_exit

		j Actions 		# if we reached this we can iterate, so go back

	for_loop_exit:
		
		move $v0, $s0
		move $v1, $s1

		lw $s1, 20($sp)
		lw $s0, 16($sp)
		lw $t3, 12($sp)
		lw $t2, 8($sp)
		lw $t1, 4($sp)
		lw $t0, 0($sp)

		addi $sp, $sp, 24
		jr $ra

# ===== end of find_min_max_array ========================




#############################################################
#           get ascii number from integer                  ##
#############################################################

# gets ascii number in a0
# returns its ascii character in $v0

get_ascii_from_int:
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)

	switch_case_with_break:
		

		case00:		
						li $t0, 0	
						bne $a0 ,$t0, case01 	# this condition/case is not valid, check next case 	
		if_case00:		
						li $v0, '0'
						j switch_return
						
		case01:		
						li $t0, 1
						bne $a0 ,$t0, case02 	# this condition/case is not valid, check next case 	
		if_case01:		
						li $v0, '1'
						j switch_return

		case02:		
						li $t0, 2
						bne $a0 ,$t0, case03 	# this condition/case is not valid, check next case 	
		if_case02:		
						li $v0, '2'
						j switch_return

		case03:		
						li $t0, 3
						bne $a0 ,$t0, case04 	# this condition/case is not valid, check next case 	
		if_case03:		
						li $v0, '3'
						j switch_return

		case04:		
						li $t0, 4
						bne $a0 ,$t0, case05 	# this condition/case is not valid, check next case 	
		if_case04:		
						li $v0, '4'
						j switch_return

		case05:		
						li $t0, 5
						bne $a0 ,$t0, case06 	# this condition/case is not valid, check next case 	
		if_case05:		
						li $v0, '5'
						j switch_return

		case06:		
						li $t0, 6
						bne $a0 ,$t0, case07 	# this condition/case is not valid, check next case 	
		if_case06:		
						li $v0, '6'
						j switch_return

		case07:		
						li $t0, 7
						bne $a0 ,$t0, case08 	# this condition/case is not valid, check next case 	
		if_case07:		
						li $v0, '7'
						j switch_return

		case08:		
						li $t0, 8
						bne $a0 ,$t0, case09 	# this condition/case is not valid, check next case 	
		if_case08:		
						li $v0, '8'
						j switch_return
						
		case09:		li $v0, '9'
					j switch_return

		switch_return:

					lw $t0, 0($sp)
					addi $sp, $sp, 4

					jr $ra

#############################################################


#############################################################
#           get integer from ascii character          	   ##
#############################################################


#  a0 => ascii
#  v0 => character in ascii, -1 if a0 is not an int from 0-9

get_int_from_ascii_number_char:
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)

	switch_case_with_break:
		

		case00:		
						li $t0, '0'
						bne $a0 ,$t0, case01 	# this condition/case is not valid, check next case 	
		if_case00:		
						li $v0, 0
						j switch_return
						
		case01:		
						li $t0, '1'
						bne $a0 ,$t0, case02 	# this condition/case is not valid, check next case 	
		if_case01:		
						li $v0, 1
						j switch_return

		case02:		
						li $t0, '2'
						bne $a0 ,$t0, case03 	# this condition/case is not valid, check next case 	
		if_case02:		
						li $v0, 2
						j switch_return

		case03:		
						li $t0, '3'
						bne $a0 ,$t0, case04 	# this condition/case is not valid, check next case 	
		if_case03:		
						li $v0, 3
						j switch_return

		case04:		
						li $t0, '4'
						bne $a0 ,$t0, case05 	# this condition/case is not valid, check next case 	
		if_case04:		
						li $v0, 4
						j switch_return

		case05:		
						li $t0, '5'
						bne $a0 ,$t0, case06 	# this condition/case is not valid, check next case 	
		if_case05:		
						li $v0, 5
						j switch_return

		case06:		
						li $t0, '6'
						bne $a0 ,$t0, case07 	# this condition/case is not valid, check next case 	
		if_case06:		
						li $v0, 6
						j switch_return

		case07:		
						li $t0, '7'
						bne $a0 ,$t0, case08 	# this condition/case is not valid, check next case 	
		if_case07:		
						li $v0, 7
						j switch_return

		case08:		
						li $t0, '8'
						bne $a0 ,$t0, case09 	# this condition/case is not valid, check next case 	
		if_case08:		
						li $v0, 8
						j switch_return
						
		case09:		li $t0, '9'
					bne $a0, $t0, nan

		if_case09:
					li $v0, 9
					j switch_return

		nan:		li $v0, -1

		switch_return:

					lw $t0, 0($sp)
					addi $sp, $sp, 4

					jr $ra

#############################################################

#############################################################


### Condition thinking:

4) Έστω ότι θέλω να γράψω το ακόλουθο πρόγραμμα στην assembly:

	if($t0 == $t1 && $t2 == $t3 && $t4 == $t5 && $t6 == $t7)
	{
		do Actions
	}

	rest of the program
	...

Ουσιαστικά τα 'Actions' θα γίνουν μόνο αν ΚΑΙ οι τεσσερίς συνθήκες είναι αληθείς.
Αν έστω και μία ΔΕΝ είναι αληθής, τα 'Actions' ΔΕΝ θα γίνουν.

ΑΝΤΙΣΤΡΕΦΩ όλες τις συνθήκες (δηλαδή τις κάνω όλες "not Συνθήκη")
και τις βάζω τη μία κάτω από την άλλη. Αν έστω και μία (από τις αντίστροφες)
ΙΣΧΥΕΙ, τότε ΔΕΝ ΜΠΟΡΟΥΜΕ να κάνουμε τα 'Actions', οπότε θα πάμε στο 'Next'.

	bne $t0, $t1, Next
	bne $t2, $t3, Next
	bne $t4, $t5, Next
	bne $t6, $t7, Next

	do Actions

	Next: ...

5) Έστω ότι θέλω να γράψω το ακόλουθο πρόγραμμα στην assembly:

	if($t0 == $t1 || $t2 == $t3 || $t4 == $t5 || $t6 == $t7)
	{
		do Actions
	}

	rest of the program
	...

Ουσιαστικά τα 'Actions' θα γίνουν αν ΤΟΥΛΑΧΙΣΤΟΝ μία από τις τέσσερις είναι αληθής.
Αν ΚΑΜΙΑ δεν ισχύει, τα 'Actions' ΔΕΝ θα γίνουν.

Αν ισχύει έστω και ΜΙΑ, τα 'Actions' γίνονται σίγουρα. Παίρνω τις συνθήκες
"όπως είναι" (χωρίς να τις αντιστρέψω) και τις βάζω τη μία κάτω από την άλλη.
Αν έστω και μία ισχύει, τότε η ροή πρέπει να πάει στα 'Actions'.

Αν δεν ισχύει καμία, δεν πρέπει να κάνουμε τα 'Actions'. Σε αυτή την περίπτωση
η ροή του παρακάτω προγράμματος θα φτάσει στην εντολή "j Next" οπότε θα προσπεραστούν
τα 'Actions'. 

	beq $t0, $t1, Actions
	beq $t2, $t3, Actions
	beq $t4, $t5, Actions
	beq $t6, $t7, Actions

	j Next

	Actions: do Actions

	Next: ...