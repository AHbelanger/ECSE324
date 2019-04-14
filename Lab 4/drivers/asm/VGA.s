	.text
	.equ CHAR_PIXEL_BASE, 0xC8000000
	.equ CHAR_CHAR_BASE, 0xC9000000
	.equ PIXEL_END, 0xC803BE7E 
	.equ CHAR_END, 0xC9001DCF
	.global VGA_write_char_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_clear_charbuff_ASM
	.global VGA_draw_point_ASM
	.global VGA_write_byte_ASM

//clear pixel buffer
VGA_clear_pixelbuff_ASM:
	PUSH {R2-R7, LR}
	LDR R3, =CHAR_PIXEL_BASE
	MOV R4, #0		//Move 0 into register to clear
	MOV R5, #1 		//x counter
	MOV R6, #1		//y counter
	
ClearPixelBuffLoopX:
	CMP R5, #320			
	BGT ClearPixelBuffLoopY		//if 320 iterations passed, loop to next y
	STRH R4, [R3]			//store black colour at proper pixel
	ADD R3, R3, #2			//increment by 2 to go to next x address
	ADD R5, R5, #1			//add 1 to x counter
	B ClearPixelBuffLoopX
		
ClearPixelBuffLoopY:
	CMP R6, #240			//counter for y-axis
	BGT END	
	MOV R5, #1			//reset x counter
	LDR R3, =CHAR_PIXEL_BASE 	//reset r3 to base address
	MOV R7, R6				//load counter of y inside r7
	ADD R6, R6, #1
	ADD R3, R3, R7, LSL #10		//add value of y to base address	
	B ClearPixelBuffLoopX


//clear character buffer
VGA_clear_charbuff_ASM:
	PUSH {R2-R7, LR}
	LDR R3, =CHAR_CHAR_BASE
	MOV R4, #0				//Move 0 into adress to clear
	MOV R5, #1
	MOV R6, #1		

ClearCharBuffLoopX:
	CMP R5, #80			
	BGT ClearCharBuffLoopY		//if 320 iterations passed, loop to next y
	STRB R4, [R3]			//store black colour at proper pixel
	ADD R3, R3, #1			//increment by 1 to go to next x address
	ADD R5, R5, #1			//add 1 to x counter
	B ClearCharBuffLoopX

ClearCharBuffLoopY:
	CMP R6, #60					//counter for y-axis
	BGT END	
	MOV R5, #1					//reset x counter
	LDR R3, =CHAR_CHAR_BASE 	//reset r3 to base address
	MOV R7, R6					//load counter of y inside r7
	ADD R6, R6, #1
	ADD R3, R3, R7, LSL #7		//add value of y to base address	
	B ClearCharBuffLoopX

VGA_write_char_ASM:
	PUSH {R2-R7, LR}
	LDR R3, =CHAR_CHAR_BASE		//R3 contains char buff base adress
	CMP R0, #79					//Check if x value if ok
	BGT END
	CMP R0, #0
	BMI END
	CMP R1, #59					//Check if y value is ok
	BGT END
	CMP R1, #0
	BMI END
	
FIND_ADRESS:
	ADD R4, R0, R1, LSL #7		//Shift y and add to x
	ADD R5, R3, R4				//Add offset to base adress

STORE_CHAR:
	STRB R2, [R5]				//Store value in adress
	B END

VGA_write_byte_ASM:
	PUSH {R2-R7, LR}
	LDR R3, =CHAR_CHAR_BASE		//R3 contains char buff base address
	CMP R0, #79					//Check if x value if ok
	BGT END
	CMP R0, #0
	BMI END
	CMP R1, #59					//Check if y value is ok
	BGT END
	CMP R1, #0
	BMI END
	MOV R6, R2					//Load value to display in R6
	
FIND_BYTE_ADRESS:
	ADD R4, R0, R1, LSL #7		//Shift y and add to x
	ADD R5, R3, R4				//Add offset to base address

FIND_FIRST_HEX:
	LSR R6, #4					//Get the first 4 bit 
	CMP R6, #10					//Check if value is a letter
	BGE FIRST_LETTER
	ADD R7, R6, #0x30			//R7 Store ascii value of the number
	B STORE_FIRST_HEX
	
FIRST_LETTER:
	ADD R7, R6, #0x37			//0X37 + offset of 10 gives starting ascii of 0x041 (letter A) 

STORE_FIRST_HEX:
	STRB R7, [R5]					//Store first hex
	ADD R5, R5, #1				//Go to address of second hex
	MOV R6, R2

FIND_SECOND_HEX:
	AND R6, R6, #0xF
	CMP R6, #10					//Check if value is a letter
	BGE SECOND_LETTER
	ADD R7, R6, #0x30			//R7 Store ascii value of the number
	B STORE_SECOND_HEX

SECOND_LETTER: 
	ADD R7, R6, #0x37
	
STORE_SECOND_HEX:
	STRB R7, [R5]					//Store first hex
	B END

VGA_draw_point_ASM:
	PUSH {R2-R7, LR}
	LDR R3, =CHAR_PIXEL_BASE		//R3 contains pixel buff base adress
	LDR R4, =319
	CMP R0, R4					//Check if x value if ok
	BGT END
	CMP R0, #0
	BMI END
	CMP R1, #239					//Check if y value is ok
	BGT END
	CMP R1, #0
	BMI END
	
FIND_PIXEL_ADRESS:
	ADD R4, R0, R1, LSL #9		//Shift y and add to x
	LSL R4, #1	
	ADD R5, R3, R4				//Add offset to base adress
	
STORE_PIXEL:
	STRH R2, [R5]
	B END

END:
	POP {R2-R7, LR}
	BX LR
