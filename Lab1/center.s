	.text
	.global _start

_start:	LDR R0, =AVERAGE	//R0 will contain the adress of AVERAGE 
		MOV R1, #0			//R1 will contain the sum of the signals, initializa with 0
		LDR R2, [R0, #4]	//R2 contains the number of signals 
		ADD R3, R0, #8		//R3 points to the first number in the list
		LDR R4, [R3]		//Load R4 with the first number in the list
		LDR R5, N			//Load the number of numbers in R5
		
LOOPSUM: SUBS R2, R2, #1	//Decrement the loop counter
		 BMI DIVIDE			//End loop if counter is negative	
		 ADD R1, R1, R4		//Add R4(nb in list) to R1(Sum)
		 ADD R3, R3, #4		//Make R3 count to the next number in the list
		 LDR R4, [R3]		//Load R4 with the first number in the list
		 B LOOPSUM			//Bact to top of the loop

DIVIDE:	 LSRS R5, R5, #1	//Divide N by 2 to know how many shifts to do
		 BEQ RESET			//End loop if R5 has reached 0
		 LSR R1, R1, #1		//Divide current sum by 2	
		 B DIVIDE

RESET: LDR R0, =NUMBERS		//R0 points to first number
	   LDR R2, N			//R2 holds the nb of N
	   LDR R3, [R0]			//R3 holds the value of at the address held by R0 (first nb)

SUBTRACT: SUBS R2, R2, #1	//Decrement the loop counter
		  BMI END			//End the loop if negative flag
		  SUB R3, R3, R1	//Substract the current number by average
		  STR R3, [R0]		//Store new value in same memory location
		  ADD R0, R0, #4	//R0 points to next value
		  LDR R3, [R0]		//Load R3 with next value
		  B SUBTRACT
		  

END: B END			

AVERAGE: 	.word	0				
N: 			.word	8			
NUMBERS: 	.word	4, 5, 3, 6		
			.word   1, 9, 2, 2
