## function in c:
# bool prime_checker(int n) {
# 	bool flag = false;
#     for(int i = 2; i <= n/2; i++) {
#     	if ( (n % i) == 0) {
#         	flag = true;
#           break;
#         }
#     }
#     return (!flag);
# }


# number to check in a0
# output in v0 => 0 (is prime), v0 => 1 (not prime)
prime_checker:

	li $t0, 2		# $t0 = i = 2 to start with
	div $a0, $t0	# get the upper bound of the iteration
	mflo $t1		# $t1 = (n/2)
					
	move $v0, $zero	# flag = 0 to start with

prime_checker_loop:
	
	div $a0, $t0	
	mfhi $t2				# get n % i

	beq $t2, $zero, prime_checker_break	# if the remainer is 0, the number is not a prime

	addi $t0, $t0, 1		# get the next divisor

	bgt $t0, $t1, pc_exit	# if we have exceeded our boundary, exit
	j prime_checker_loop	# else loop again

prime_checker_break:
	addi $v0, $v0, 1

pc_exit:
	jr $ra