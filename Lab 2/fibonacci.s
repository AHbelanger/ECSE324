	.text
	.global _start

_start:
	LDR R4, =RESULT			//R4 points to result
	LDR R5, [R4, #4]		//R5 stores the value of the fib to compute
	MOV R0, R5				//Ro also contains that nb, however, this register will vary
	BL FIBONACCI			//Call finbonacci with value to compute in R0
	B DONE

FIBONACCI:
	PUSH {LR}			//Save LR
	CMP R0, #2			//Check if argument is smaller then 2
	BGE ARGUMENTS		//If it is, go to arguments
	MOV R0, #1			//Else, return 1 
	POP {LR}			//Pop LR to return to the right place
	BX LR				//Return to lr

ARGUMENTS:
	PUSH {R0}			//Save value of argument n
	SUB R0, R0, #1		//Put n-1 as an argument in R0
	BL FIBONACCI		//Compute fibonacci of n-1
	MOV R1, R0			//Save the fib of n-1 in R1
	POP {R0}			//Get n back in R0
	PUSH {R1}			//Push R1 to save it for later
	SUB R0, R0, #2		//Compute n-2
	BL FIBONACCI		//Compute fibonacci of n-2
	POP {R1}			//Retrieve R1
	ADD R0, R0, R1		//Compute fib(n-1)+fib(n-2)
	POP {LR}			//Retrieve LR
	BX LR				//Return to LR

DONE: 
	STR R0, [R4]		//Store value in memory

END: B END

RESULT: 	.word	0				//memory assigned for result location
N: .word 8							//nth fibonacci number to compute
