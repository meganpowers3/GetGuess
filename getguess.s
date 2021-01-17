#######################
# guess.s
# -------
# This program asks the user to enter a guess. It
# reprompts if the user's entry is either an invalid
# hexadecimal number or a valid hexadecimal number
# that is outside the range specified in the program
# by min and max.
#
	.data
min:        .word   1
max:        .word   10
msgguess:   .asciiz "Make a guess.\n"
msgnewline: .asciiz "\n"
	.text
	.globl main
main:
	# Make space for arguments and saved return address
	subi  $sp, $sp, 20
	sw    $ra,16($sp)

	# Get the guess
	la    $a0, msgguess
    lw    $a1, min
    lw    $a2, max
    jal   GetGuess
    
    # Print the guess
    move  $a0, $v0
    jal   PrintInteger
    
    
    # Print a newline character
    la    $a0, msgnewline
    jal   PrintString
    
    
    # Return
    lw    $ra, 16($sp)
    addi  $sp, $sp, 20
    jr    $ra

################################
# GetGuess
################################

    .data
invalid:    .asciiz "Not a valid hexadecimal number.\n"
badrange:   .asciiz "Guess not in range.\n"
    .text
    .globl  GetGuess

GetGuess:

   addi $sp, $sp, -48 #adjust sp
   sw $ra, 44($sp) 
   sw $t2, 36($sp) #question
   sw $t0, 32($sp) #theguess
   sw $t1, 16($sp) # 16 byte string that holds the argument
   sw $a0, 12($sp)
   sw $a1, 8($sp)
   sw $a2, 4($sp)


   lw $t6, 12($sp)
   lw $t4, 8($sp) # was $t4
   lw $t5, 4($sp) 
   
 #  move $s4, $t4
 #  move $s5, $t5
  
   
   # works
   move $a0, $t6 # buffer
   la $a1, 16($sp) # buffer
   li $a2, 16
   jal InputConsoleString
   move $t0, $v0
   beqz $t0, return_zero   
   
   # puts 
   
   la $a0, 32($sp)
   la $a1, 16($sp)
   jal axtoi
   move $t3, $v0
   beqz $t3, print_invalid 
   
   lw $t0, 32($sp)
   slt $t6, $t0, $t4
   sgt $t7, $t0, $t5
   
 #  move $t4, $a1
 #  move $t5, $a2
#  lw $t4, other_min
 # lw $t5, other_max
   beq $t6, 1, not_between
   beq $t7, 1, not_between
#   blt $s0, $t4, not_between
#   bgt $s0, $t5, not_between
   
   move $v0, $t0
   
   lw $ra, 44($sp) 
   lw $t2, 36($sp) #question
   lw $t0, 32($sp) #theguess
   lw $t1, 16($sp) # 16 byte string that holds the argument
   lw $a0, 12($sp)
   lw $a1, 8($sp)
   lw $a2, 4($sp)
   subi $sp, $sp, -48 #adjust sp
    
   jr      $ra
   
   return_zero:
   
    lw $ra, 44($sp) 
   lw $t2, 36($sp) #question
   lw $t0, 32($sp) #theguess
   lw $t1, 16($sp) # 16 byte string that holds the argument
   lw $a0, 12($sp)
   lw $a1, 8($sp)
   lw $a2, 4($sp)
   subi $sp, $sp, -48 #adjust sp
    
    li $t3, -1
    move $v0, $t3
    jr $ra
    
   print_invalid:
    
    la $a0, invalid
    jal PrintString
    
   lw $ra, 44($sp) 
   lw $t2, 36($sp) #question
   lw $t0, 32($sp) #theguess
   lw $t1, 16($sp) # 16 byte string that holds the argument
   lw $a0, 12($sp)
   la $a1, ($t4)
   la $a2, ($t5)
   subi $sp, $sp, -48 #adjust sp
   
    j GetGuess
  
    not_between:
    
    la $a0, badrange
    jal PrintString  
   
   lw $ra, 44($sp) 
   lw $t2, 36($sp) #question
   lw $t0, 32($sp) #theguess
   lw $t1, 16($sp) # 16 byte string that holds the argument
   lw $a0, 12($sp)
   la $a1, ($t4)
   la $a2, ($t5)
   subi $sp, $sp, -48 #adjust sp
   
  
    j GetGuess
   
    .include  "./util.s"