#Written by Harshith(IMT2017516)
#email: Harshith.Reddy@iiitb.org

#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Do not change any code above this line
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#function: should be written by students(sorting function)
#The below function adds 10 to the numbers. You have to replace this with
#your code
#copy function 
#We need a swap function(temp vars)  
#nested loops + limit of the loop 
#2 counters 
XtoY:				#we need for(int i = 0 ; i<sizeof(array) ; i++) 
	addi $s0,$zero,0 	#s0= 0 / i = 0
	addi $s1,$t2,0
	addi $s2,$t3,0
	Loop:
	beq $t1,$s0,StartSort 	#terminating condition of for loop
	lw $t4 , 0($s1) 
	sw $t4 , 0($s2)
	addi $s1,$s1,4
	addi $s2,$s2,4
	addi $s0,$s0,1		#increment $s0 which is i 
	j Loop
	
StartSort:
	addi $s0,$zero,0 	#s0= 0 / i = 0
	 
	addi $s2,$t3,0		#base address of Y
	addi $s3,$t1,-2
	OuterLoop:
		beq $s0,$s3,Exit
		addi $s1,$zero,0  	#s1 = 0 / j= 0
		sub $t4,$t1,$s0
		addi $t4,$t4,-1
		InnerLoop:
			beq $t4,$s1,Innerloopend
			add $t5,$s2,$s1		#t5 get &arr[j]
			lw $t6 ,0($t5)
			lw $t7,4($t5)
			slt $s4,$t6,$t7
			beq $s4,$zero,swap
			
			increments :
					#need j++
			addi $s1,$s1,1
			j InnerLoop 
			
			
			swap:
				lw $s5, 0($t6) 
				sw $t7, 0($t6)
				sw $s5 ,0($t7)
				j increments
			
			
			
			 
		
	Innerloopend: 
	addi $s0,$s0,1
	j OuterLoop
		
	



Exit:
#endfunction
#############################################################
#You need not change any code below this line

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra

