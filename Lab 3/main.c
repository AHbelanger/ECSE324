#include <stdio.h>

#include "./drivers/inc/LEDs.h"			
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"

int main () {

	while(1) {											
		int switches = read_slider_switches_ASM();  	//Read switches
		write_LEDs_ASM(switches);						//Write value of switches in LEDs to turn on associated ones
		if(0x200 & switches){							//If the 9nth switch is on, clear everything
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5);
		} else {
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3);	//clear 0, 1, 2, 3 
			int number = 0xF & switches;				//Read number to be displayed
			int display = 0xF & read_PB_data_ASM();		//Check which display to use
			HEX_write_ASM(display, number);				//Write value on used display
			HEX_flood_ASM(HEX4 | HEX5);					//Turn 4 and 5 on always
		}
	}

	return 0;

}