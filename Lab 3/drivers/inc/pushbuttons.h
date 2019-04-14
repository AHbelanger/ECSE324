#ifndef _PUSHBUTTONS
#define _PUSHBUTTONS

	typedef enum{
		PB0 = 0x00000001,
		PB1 = 0x00000002,
		PB2 = 0x00000004,
		PB3 = 0x00000008
	} PB_t;	

	/*these subroutines only access the puhsbutton data register*/
	extern int read_PB_data_ASM();
	extern int PB_data_is_pressed_ASM(PB_t PB);

	/*these subroutines only acces the pushbutton edgecapture register*/
	extern int read_PB_edgecap_ASM();
	extern int PB_edgecap_is_pressed_ASM(PB_t PB);
	extern int PB_clear_edgecap_ASM(PB_t PB);

	/*these subroutines only access the pushbutton interrupt mask register*/
	extern void enable_PB_INT_ASM(PB_t PB);
	extern void disable_PB_INT_ASM(PB_t PB);

#endif