	.text
	.equ SW_BASE, 0xFF200040
	.global read_slider_switches_ASM

read_slider_switches_ASM:
	PUSH {R1, LR}
	LDR R1, =SW_BASE
	LDR R0, [R1]
	POP {R1, LR}
	BX LR

	.end




