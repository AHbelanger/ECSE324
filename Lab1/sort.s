	.text
	.global _start

_start:	MOV R0, #0				//R0 will be the "sorted" boolean

OUTERLOOP: SUBS R12, R0, #1		//R12 will act as a trash can. Check status of boolean
  		   BMI PREP				//If sorted is false, sort
		   B END

PREP: MOV R0, #1 				//Set sorted to true
	  LDR R1, N 				//R1 contains the value of N
	  LDR R2, =NUMBERS			//R2 points to first number in list

INNERLOOP: SUBS R1, R1, #1 		//Decrement counter
		   BEQ OUTERLOOP		//If counter is at 0 go to outer loop
		   LDR R3, [R2]			//Load number at R2 in R3
		   LDR R4, [R2, #4]		//Load next nb in R4
		   CMP R4, R3			//Compare if R3 is bigger then R4
		   BMI SWAP				//If it is, go to swap
		   ADD R2, R2, #4		//Go to next number in list
		   B INNERLOOP

SWAP: MOV R11, R3				//Move the value at R3 into R11 for the moment
	  STR R4, [R2]				//Swap value at R4(R2 + 4) to R2
	  STR R11, [R2, #4]			//Swap value at R11(R2) to R2 + 4
	  ADD R1, R1, #1			//Add one to the counter or else it would be one too few
	  MOV R0, #0				//Set sorted to false
	  B INNERLOOP		   

END: B END			
			
N: 			.word	8			
NUMBERS: 	.word	4, 5, 3, 6		
			.word   1, 9, 2, 2
