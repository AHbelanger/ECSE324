			.text
			.equ PB_DATA, 0xFF200050
			.equ PB_MASK, 0xFF200058
			.equ PB_EDGECAP, 0xFF20005C
			.global read_PB_data_ASM
			.global PB_data_is_pressed_ASM
			.global read_PB_edgecap_ASM
			.global PB_edgecap_is_pressed_ASM
			.global PB_clear_edgecap_ASM
			.global enable_PB_INT_ASM
			.global disable_PB_INT_ASM

read_PB_data_ASM:				
			LDR R1, =PB_DATA	//Load adress of push button
			LDR R0, [R1]		//Load data from adress in R0 
			AND R0, R0, #0xF	//Return only needed bits
			BX LR				//Return R0

PB_data_is_pressed_ASM:			
			LDR R1, =PB_DATA	//Load adress of push button
			LDR R1, [R1]		//Load data from adress in R1
			AND R2, R1, R0		//AND R0 and R1 to check if specific button is pressed 
			CMP R2, R0			//Compare with R0 to check if button is pressed
			MOVEQ R0, #1		//If = , checked button is pressed
			MOVNE R0, #0		//If !=, checked button is not pressed
			BX LR

read_PB_edgecap_ASM:				
			LDR R1, =PB_EDGECAP	//Load adress of edgecap
			LDR R0, [R1]		//Load data into R0
			AND R0, R0, #0xF	//Return only needed bits
			BX LR 				//Return R0

PB_edgecap_is_pressed_ASM:			
			LDR R1, =PB_EDGECAP	//Load adress of edgecap
			LDR R1, [R1]		//Load value of R1
			AND R2, R1, R0		//AND R0 and R1 to check if specific button is pressed 
			CMP R2, R0			//Compare with R0 to check if button is pressed
			MOVEQ R0, #1		//If = , checked button is pressed
			MOVNE R0, #0		//If !=, checked button is not pressed
			BX LR

PB_clear_edgecap_ASM:				
			LDR R1, =PB_EDGECAP //Load adress of edgecap
			MOV R0, #0xF		//Move all 1s in R0
			STR R0, [R1]		//Store all 1s in adress of edgecap to reset
			BX LR		

enable_PB_INT_ASM:				
			LDR R1, =PB_MASK	//Load adress of interupt
			AND R2, R0, #0xF	//Return only needed bits
			STR R2, [R1]		//Store return value in adress
			BX LR			

disable_PB_INT_ASM:				
			LDR R1, =PB_MASK	//Load adress of interupt
			LDR R2, [R1]		//Load value at adress in R2
			BIC R1, R1, R0		//Disable wanted button
			STR R1, [R2]		//Store value back in adress
			BX LR		
			
			.end

			
