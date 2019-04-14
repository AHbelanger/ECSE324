	.text
	
	.global A9_PRIV_TIM_ISR
	.global HPS_GPIO1_ISR
	.global HPS_TIM0_ISR
	.global HPS_TIM1_ISR
	.global HPS_TIM2_ISR
	.global HPS_TIM3_ISR
	.global FPGA_INTERVAL_TIM_ISR
	.global FPGA_PB_KEYS_ISR
	.global FPGA_Audio_ISR
	.global FPGA_PS2_ISR
	.global FPGA_JTAG_ISR
	.global FPGA_IrDA_ISR
	.global FPGA_JP1_ISR
	.global FPGA_JP2_ISR
	.global FPGA_PS2_DUAL_ISR

	.global TIM0_FLAG
	.global BUTTON_FLAG

TIM0_FLAG:
	.word 0x0

BUTTON_FLAG:
	.word 0x4

A9_PRIV_TIM_ISR:
	BX LR
	
HPS_GPIO1_ISR:
	BX LR
	
HPS_TIM0_ISR:
	PUSH {LR}

	MOV R0, #0x1
	BL HPS_TIM_clear_INT_ASM

	LDR R0, =TIM0_FLAG
	MOV R1, #1
	STR R1, [R0]

	POP {LR}
	BX LR
	
HPS_TIM1_ISR:
	BX LR
	
HPS_TIM2_ISR:
	BX LR
	
HPS_TIM3_ISR:
	BX LR
	
FPGA_INTERVAL_TIM_ISR:
	BX LR

FPGA_PB_KEYS_ISR:
	PUSH {LR}
	LDR R0, =0xFF200050			//Load button adress
	LDR R1, [R0, #0xC]			//Load edgecap adress
	STR R1, [R0, #0xC]			//Clear it 
	LDR R0, =BUTTON_FLAG		//Load the flag

PB0_CHECK:
	MOV R3, #0x1				// since one hot encoded button one is at bit 1
	ANDS R3, R1 				// check if it is button 0
	BEQ PB1_CHECK
	MOV R2, #0					// return button number that was pressed
	STR R2, [R0] 				// store it into the timer flag
	B END_PB
PB1_CHECK:
	MOV R3, #0x2				// encoding for pb 1
	ANDS R3, R1 				// check if button is 1
	BEQ PB2_CHECK
	MOV R2, #1					// return button number that was pressed
	STR R2, [R0]				// store it into the timer flag
	B END_PB
PB2_CHECK:
	MOV R3, #0x4				// encoding for pb 2
	ANDS R3, R1 				// check if button is 2
	BEQ PB3_CHECK
	MOV R2, #2					// return button number that was pressed
	STR R2, [R0] 				// store it into the timer flag
	B END_PB
PB3_CHECK:
	MOV R2, #3					// return button number that was pressed
	STR R2, [R0] 				// store it into the timer flag
END_PB:
	POP {LR}
	BX LR
	
FPGA_Audio_ISR:
	BX LR
	
FPGA_PS2_ISR:
	BX LR
	
FPGA_JTAG_ISR:
	BX LR
	
FPGA_IrDA_ISR:
	BX LR
	
FPGA_JP1_ISR:
	BX LR
	
FPGA_JP2_ISR:
	BX LR
	
FPGA_PS2_DUAL_ISR:
	BX LR
	
	.end