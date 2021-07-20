## This program is dedicated to make you better understand 
## how pseudo-instructions are turned into native machine code in MIPS

.data
		sth:		.word		0x55555555
        sth2:		.word		0x12345678

##	main program

.text
 	.globl __start
__start:

main:
	
    ##################################################
    ##  		move <dest> <source>				##
    ##################################################

    # copies the content of <source> register into <dest>
	
    li $t0, 5		# place 5 into t0
    move $t1, $t0	# and then copy that into t1

	# so the addition with the $zero register is enough!


	
    ##################################################
    ##  		li <dest> <immed>					##
    ##################################################

	# loads immediate into <dest> register
    
    ##################################################
	##												##
    ##  loading into register is extremely tricky 	##
    ## 			let's explain why that is!			##
    ##################################################

    # because li is a I-type instruction, its immediate can be up to 16 bits
    # however that would mean that we can only place immediate numbers in the range [-32678, 32767]
    # which is extremely limiting. But we can place numbers bigger than that. 

    li $s0, 1		# this only needs 1 instruction, ori, as it is inside the range

    # but for numbers out of the range we said before, 2 or *even 1* instruction are needed:
    # in the common case, 2 instructions are needed:

    li $s1, 12341234 	# translates to 2 instructions lui, ori

    # ORI is used to load the first 16 bits, and LUI is used for the upper 16 bits
    # *BUT* ori is only used if the first 16 bits actually have something other than 0's 
    # to be filled with!
	# example:

    li $s2, 65536		# translates to only 1 instruction, lui
	   
    # 65536 = 1 | 0000000000000000 , so as ALL the first 16 bits are 0's they are filled from the lui
    # so we don't need an ori (try it yourself, ori with $zero doesn't do anything and is practically and no operation instruction!)
    # same goes for all numbers whose ALL first 16 bits are 0's, e.g. li $s2, 131072)

    ##################################################################################
	#																				 #
	##	 				This is true for all instructions 			   		   		##
	#				discussed below, so we won't explain it again later!			 #
	##################################################################################

    
    ##################################################
    ##  		la <dest> <label>					##
    ##################################################

    ## UP TO 2 instructions! (1 for the exception discussed for li)
	# as you can see, in the data section I only have 2 words. Let's see how they will get loaded!
	# we can see in the data section that:
    # sth 	=> 	0x10010000
    # sth2 	=> 	0x10010004

    la $s0, sth		# 1 instruction, because the first 16 bits are all zero!
    la $s1, sth2	# 2 instructions, because the first 16 bits are NOT all zero, so we have to use ori!



	##################################################
    ##  		addi <dest> <source> <immed>		##
    ##################################################


	# again, if the <immed> is under 16 bits ( so in the range [-32678, 32767] ), only 1 instruction is needed
    # and that is the addition it self
	
    addi $s3, $s3, 151

    # if <immed> > 16 bits, 2 or 3 instructions are needed (lui, ori, add)
    # again ori can be ommited for the reasons discussed in the li instruction.
	# to temporarily hold the number that is loaded (lui & ori), a special register is used: $at (1)
    # addition is then performed on THAT register, as it's the one that holds the desired value

    addi $s4, $s4, 12345123		# 3 instructions

    addi $s5, $s5, 524288		# 2 instructions, no ori is needed

	##################################################
    ##  		not <dest> <source> 				##
    ##################################################

    not $s6, $zero				# nor with the $zero register, as "or" with $zero does nothing

    ##########################################################
    ##  		branch <source1> <source2> <label>			##
    ##########################################################
	
    # ommiting their immediate versions:
    # all branch instructios are a combination of slt and (beq or bne) instructions so 2 instructions
	# except beq and bne themselves which are 1 instructions

    # else it gets complicated due to loading!