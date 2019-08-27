.data
array1:	.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
array2: .word 17, -49, 213, 37, -643, 83, 333, -8459
array3: .word -70, -99, -13, -42, -954
msg1: .asciiz "Function One: Finding the smallest integer."
msg2: .asciiz "\n\nFunction Two: Performing a Combination."
prompt1: .asciiz "\n\nPlease enter an n: "
prompt2: .asciiz "Please enter an r: "
t1: .asciiz "\n\nFirst Array: "
t2: .asciiz "\n\nSecond Array: "
t3: .asciiz "\n\nThird Array: "
lw: .asciiz "\nSmallest Integer: "
openBracket: .asciiz "[ "
closedBracket: .asciiz "]\n"
msg4: "Combination is: "
space:	.asciiz " "
	
.text
main:	
li $s0, 0 #entry counter
	la $a0, msg1 #say that you will be finding the min first
	li $v0, 4
	syscall
	
	li $t5, 1 #initialize $t5 with 1 to print 1 for base case
	
test1:	
	la $a0, t1 #say first array label
	li $v0, 4
	syscall
	
	la $a0, array1 #reintialize first array
	li $a2, 9 #high index
	move $s2, $a0 #make a copy and print	
	jal function
	la $a0, array1 #restore array
	jal min #call min
	jal print2
	
test2:	
	la $a0, t2 #print part one of prompt
	li $v0, 4
	syscall
	
	la $a0, array2 #reinitialize array
	move $s2, $a0
	jal loadNum
	la $a0, array2 #reinitialize array
	li $a1, 0 #set low index
	li $a2, 7 #set high index
	jal min 
	jal print2
	
test3:	
	la $a0, t3 #print part one of prompt
	li $v0, 4
	syscall
	
	la $a0, array3 #reinitialize array
	move $s2, $a0
	jal function
	la $a0, array3 #reinitialize array
	li $a1, 0 #set low index
	li $a2, 4 #set high index
	jal min			
	jal print2
	j print3
	
function:	
	j loadNum
	
loadNum:	
	beqz $s1, jumpback
	lw $a0, 0($s2) 
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	addi $s2, $s2, 4
	addi $s1, $s1, -1
	j loadNum
	
jumpback:	
	jr $ra
	
print2:	
	move $a1, $v0 #move return to a1
	la $a0, lw #print lowest number message
	li $v0, 4
	syscall
	move $a0, $a1 #print answer
	li $v0, 1
	syscall
	addi $s0, $s0, 1 #determine which test case to run
	jr $ra

print3:
	la $a0, msg2 #print function 2 message
	li $v0, 4
	syscall
	
	la $a0, prompt1 #ask for n
	li $v0, 4
	syscall
	li $v0, 5 #read n
	syscall	
	move $a1, $v0 #put n into $t0
	
	la $a0, prompt2 #ask for r
	li $v0, 4
	syscall
	li $v0, 5 #read r
	syscall
	move $a2, $v0 #put r into $a2	
	jal f
	move $a0, $v0
	li $v0,1
	syscall	
	
end: 	
	li $v0, 10
	syscall

	# $a0 = address of A, $a1 = low, $a2 = high

min:	
	bne $a1, $a2, rec #check if low == high	
	sll $t2, $a1, 2	 #set $t2 if $a1 < 2
	add $t3, $a0, $t2 #to store array pointer address in $t3
	lw $v0, 0($t3) #to get the low index number
	jr $ra
	
rec:	
	add $t0, $a1, $a2 #add low and high index and store in $t0
	srl $t0, $t0, 1	#shift $t0 right from $t0 by 1 byte
	addiu $sp, $sp, -12 #store 12 bytes in stack by using stack #pointer for ra, high, first smallest int
	sw $ra, 0($sp) #put $ra onto stack
	sw $a2, 4($sp) #put high onto stack
	addi $t1, $t0, 1 #$t1 = mid + 1
	move $a2, $t0 #high = mid
	jal min	#jump and link to min
	
	move $a1, $t1 #store mid+1 into min
	lw $a2, 4($sp) #lw high
	jal min	#jump 
	lw $t0, 8($sp) #$t0 = min1, $v0 = min2
	lw $ra, 0($sp) #restore ra
	addiu $sp, $sp, 12 #release space on stack
	bgt $t0, $v0 ans #check if min1 > min2
	move $v0, $t0  #return min1 since min1 <= min2
	
ans:	
	jr $ra
	
f:	
	beq $a1, $a2, base #if r==n	
	beqz $a2, base #if r==0

# r = $a2
#n = $a1	
recu:
	addiu $sp, $sp, -16
	sw $ra, 0($sp) #return address in offset place 0
	sw $a1, 4($sp) #n in offset place 4
	sw $a2 8($sp) #r in offset place 8
	addi $a1, $a1, -1 #n-1
	jal f
	sw $v0, 12($sp) #store value of first comb
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	add $a1, $a1, -1
	add $a2, $a2, -1
	jal f
	lw $t0, 12($sp)
	add $v0, $v0, $t0
	lw $ra, 0($sp) 
	addiu $sp, $sp, 16
	jr $ra
	
base:       
            li $v0, 1
            jr $ra
