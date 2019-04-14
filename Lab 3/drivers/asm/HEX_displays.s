	.text
	.equ HEX_BASE1, 0xFF200020
	.equ HEX_BASE2, 0xFF200030
	.global HEX_clear_ASM
	.global HEX_flood_ASM
	.global HEX_write_ASM

HEX_clear_ASM:	LDR R1, =HEX_BASE1		//Contains adresses for HEX0-3
				LDR R2, =HEX_BASE2		//Contains adresses for HEX4-5
				MOV R3, #6				//Loop counter
				MOV R4, #1				//Control that compares with R0 to check if display needs to be changed
				MOV R6, #0				//Use 0 to clear the needed byte

LOOP_CLEAR_03:	CMP R3, #2				//Checks if still in lower displays
				BEQ LOOP_CLEAR_45		//If not go to upper displays
				ANDS R5, R4, R0 		//Compare R0 with control to know if checked desplay needs to be cleared
				BEQ CLEAR_03			//If = 0, skip clearing
				STRB R6, [R1]			//Else, insert 1 byte of 0 at memory location R1	

CLEAR_03:		LSL R4, #1				//Shift R4 to check next display
				ADD R1, R1, #1			//Increment R1 to get the adress if next display
				SUBS R3, R3, #1			//Decrement the loop counter
				BGT LOOP_CLEAR_03		//Keep looping in lower displays

LOOP_CLEAR_45:	CMP R3, #0				//Check if finished with all displays
				BEQ END_CLEAR			//If so, end
				ANDS R5, R4, R0			//Compare R0 with control to know if checked desplay needs to be cleared
				BEQ CLEAR_45			//If = 0, skip clearing
				STRB R6, [R2]			//Else, insert 1 byte of 0 at memory location R1	

CLEAR_45:		LSL R4, #1				//Shift R4 to check next display
				ADD R2, R2, #1			//Increment R2 to get the adress if next display
				SUBS R3, R3, #1			//Decrement loop counter
				BGT LOOP_CLEAR_45		//Keep looping in upper displays

END_CLEAR:		BX LR

HEX_flood_ASM:	LDR R1, =HEX_BASE1		//Contains adresses for HEX0-3
				LDR R2, =HEX_BASE2		//Contains adresses for HEX4-5
				MOV R3, #6				//Loop counter
				MOV R4, #1				//Control that compares with R0 to check if display needs to be changed
				MOV R6, #0xFF			//Use R6 to flood desired 8 bits

LOOP_FLOOD_03:	CMP R3, #2				//Checks if still in lower displays
				BEQ LOOP_TOP_F			//If not go to upper displays
				ANDS R5, R4, R0 		//Check which display to flood
				BEQ BOTTOM_F			//If = 0, no need to flood
				STRB R6, [R1]			//Else, flood display being checked

BOTTOM_F:		LSL R4, #1				//Shit control by 1 to check next display
				ADD R1, R1, #1			//Point to the adress of next display
				SUBS R3, R3, #1			//Decrement loop counter
				BGT LOOP_FLOOD_03		//Loop back to lower displays

LOOP_TOP_F:		CMP R3, #0				//Check if finished checking all displays
				BEQ END_FLOOD			//If so, end
				ANDS R5, R4, R0			//Else, check if display needs to be flooded
				BEQ TOP_F				//If = 0, no need to be flooded
				STRB R6, [R2]			//Else, flood designated upper display

TOP_F:			LSL R4, #1				//Shift control to point to next display
				ADD R2, R2, #1			//Point to the adress of next display
				SUBS R3, R3, #1			//Decrement counter
				BGT LOOP_TOP_F			//Loop back to upper displays

END_FLOOD:		BX LR

HEX_write_ASM:	LDR R2, =HEX_BASE1		//Contains adresses for HEX0-3
				LDR R3, =HEX_BASE2		//Contains adresses for HEX4-5
				LDR R7, =HEX_VAL		//Start adress of the list of all values for 16 hex displays
				LDRB R8, [R7, R1]		//Load corresponding value of val in R8
				MOV R4, #6				//Loop counter
				MOV R5, #1				//Control which compares with R0 to check which hex to change

LOOP_W_LOWER:	CMP R4, #2				//Check if still in lower displays
				BEQ LOOP_W_UPPER		//If not go to upper displays
				ANDS R6, R5, R0 		//Compare R0 to control to know if selected bit needs to be changed
				BEQ W_LOWER				//If = 0, no changes
				STRB R8, [R2]			//Else, store val in corresponding display address

W_LOWER:		LSL R5, #1				//Shift control to check next display
				ADD R2, R2, #1			//Increment adress to next display
				SUBS R4, R4, #1			//Decrement loop counter 
				BGT LOOP_W_LOWER		//Go back to lower displays

LOOP_W_UPPER:	CMP R4, #0				//Check f all displays have been checked
				BEQ END_W				//If so, end
				ANDS R6, R5, R0			//Else, check if current display needs to be changed
				BEQ W_UPPER				//If not, no changes
				STRB R8, [R3]			//If so, change

W_UPPER:		LSL R5, #1				//Shift control to check next display
				ADD R3, R3, #1			//Increment adress to next display
				SUBS R4, R4, #1			//Decrement loop counter
				BGT LOOP_W_UPPER		//Go back to upper displays

END_W:			BX LR

HEX_VAL: 		.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x77, 0x7F, 0x39, 0x3F, 0x79, 0x71
				.end
