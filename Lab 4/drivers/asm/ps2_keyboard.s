	.text
	.equ PS2_ADRESS, 0xFF200100
	.global read_PS2_data_ASM

read_PS2_data_ASM:
	LDR R1, =PS2_ADRESS			//R1 contains PS/2 base adress
	MOV R4, R0					//Save the adress in R0
	MOV R0, #0						
	LDR R2, [R1]	
	LSR R2, #15
	AND R2, R2, #1				//Get only the first bit which is RVALID
	CMP R2, #0					//If = 0, return
	BEQ END
	LDRB R5, [R1]				//Load the value in data
	STRB R5, [R4]				//Store the value in the adress initialy passed in R0
	MOV R0, #1					//Return 1
	B END	

END:
	BX LR
