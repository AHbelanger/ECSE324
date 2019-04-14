	.text
	.equ FIFOSPACE, 0xFF203044
	.equ LEFTDATA, 0xFF203048
	.equ RIGHTDATA, 0xFF20304C
	.global Audio_Output_ASM

Audio_Output_ASM:
	PUSH {R1-R3}		
	LDR R1, =FIFOSPACE		//load the address of fifospace in R1
	MOV R2, R0				//copy the signal value into R2
	MOV R0, #0				//set the boolean to 0

	LDRB R3, [R1, #2]      	//load the value of WSRC into R3
	CMP R3, #0				//if WSRC is full and doesn't have available space for output
	BEQ End
	LDRB R3, [R1, #3] 		//load the value of WSLC into R3
	CMP R3, #0				//if WSLC is full and doesn't have available space for output
	BEQ End

	MOV R0, #1				//set the boolean to 1
	LDR R3, =LEFTDATA		//load the address of leftdata into R3
	STR R2, [R3] 			//store the signal into content of leftdata
	LDR R3, =RIGHTDATA		//load the address of rightdata into R3
	STR R2, [R3]			//store the signal into content of rightdatadata
	

End:
	POP {R1-R3}
	BX LR
