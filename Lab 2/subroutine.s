	.text
	.global _start

_start:
	LDR R4, =RESULT 	//R4 points to the result location
	LDR R5, [R4, #4]	//Load R5 with number of arguments
	ADD R6, R4, #8	//Make R6 points to the start of the list
	LDR R0, [R6]	//Load R0 with the first number in the list

LOOP: 
	SUBS R5, R5, #1	//Update the counter
	BEQ DONE	//If counter = 0, we're at the end of the list therefore terminate
	ADD R6, R6, #4	//Point to the next number in the list
	LDR R1, [R6] 	//Load R1 with the value at the adress in R6 (next number)
	BL MAX	//go into subroutine to find max
	B LOOP 	

MAX: 
	CMP R0, R1	//Compare R0 and R1
	BMI UPDATE	//If R1 is bigger then R0, go to update
	BX LR	//Go back to where LR indicates	

UPDATE: 
	MOV R0, R1	//Replace R0 with the new biggest number at R1
	BX LR	//Go back to where LR indicates	

DONE:
	STR R0, [R4]	//Store max in memory

END: B END

RESULT: 	.word	0				//memory assigned for result location
N: 			.word	10				//number if entries in the list
NUMBERS: 	.word	4, 5, 3, 6		//the list data
			.word 1, 8, 2, 3, 4, 9
