	.text
	.global _start

_start:
	MOV R0, #8	//Move value 8 into R0 
	STR R0, [SP, #-4]!	//(Push) Store the value in R0 to the memory indicated by SP, decrement SP by 4 before
	LDR R1, [SP], #4	//(Pop) Load R1 with value at top of stack 
	
	MOV R1, #5	//Populate R1 to R5 for the sake of example
	MOV R3, #6
	MOV R4, #7
	MOV R5, #9

	STMDB SP!, {R1, R3-R5} //Store multiple decrement before 
	LDMIA SP!, {R7-R10}	//Load multiple increment after

END: B END
