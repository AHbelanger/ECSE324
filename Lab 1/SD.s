	.text
	.global _start

_start:
	LDR R4, =RESULT 	//R4 points to the result location
	LDR R2, [R4, #4] 	//R2 holds the number of elements in the list
	ADD R3, R4, #8		//R3 points to the first number
	LDR R0, [R3]		//R0 holds the first number in the list

LOOPMAX:
	SUBS R2, R2, #1 	//decrement the loop counter
	BEQ DONEMAX			//end loop if counter has reached 0
	ADD R3, R3, #4		//R3 points to next number in the list
	LDR R1, [R3]		//R1 holds the next number in the list 
	CMP R0, R1			//check if it is greater then the maximum
	BGE LOOPMAX			//if no, branch back to the loop
	MOV R0, R1			//if yes, update the current max
	B LOOPMAX				//branch back to the loop

LOOPMIN:
	SUBS R2, R2, #1 	//decrement the loop counter
	BEQ DONEMIN			//end loop if counter has reached 0
	ADD R3, R3, #4		//R3 points to next number in the list
	LDR R1, [R3]		//R1 holds the next number in the list 
	CMP R1, R0			//check if it is smaller then the minimum
	BGE LOOPMIN			//if no, branch back to the loop
	MOV R0, R1			//if yes, update the current min
	B LOOPMIN			//branch back to the loop

DONEMAX: MOV R5, R0			//move the max to the memory location of R5
		 ADD R3, R4, #8		//R3 points to the first number
		 LDR R0, [R3]		//R0 holds the first number in the list
		 LDR R2, [R4, #4] 	//R2 holds the number of elements in the list
		 B LOOPMIN			//branch to minimum loop

DONEMIN: MOV R6, R0			//move the min to the memory location of R6

COMPUTE: SUB R10, R5, R6 	//subtract min from max value and store in R10
		 LSR R10, R10, #2 	//Shift left twice to divide by 4 and store in R10
		

END: B END				//infinite loop

RESULT: 	.word	0				//memory assigned for result location
N: 			.word	7				//number if entries in the list
NUMBERS: 	.word	4, 5, 3, 6		//the list data
			.word   1, 9, 2


