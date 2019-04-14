#include <stdio.h>

#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/pushbuttons.h"

int main()
{
	int_setup(2, (int []) {73, 199});							//Enable interupt for push button and timer
	enable_PB_INT_ASM(PB0 | PB1 | PB2);	

	HPS_TIM_config_t timer;		
	timer.tim = TIM0;											//Use timer 0
	timer.timeout = 10000; 										//Set count incrment to 10 ms
	timer.LD_en = timer.INT_en = timer.enable = 1;				//Set all settings to 1 to enable 
	HPS_TIM_config_ASM(&timer);

	HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0); //write all values as 0 , initialize
	int ms = 0; 
	int sec = 0;
	int min = 0; 
	int set_timer = 0;		   

	while (1) {
		if (TIM0_FLAG) {					//read value of S-bit and compare with the status of the timer, if both are 1, display stopwatch
			TIM0_FLAG = 0;					//Clear timer

		if(set_timer){
			ms = ms + 10;									//Increments of 10 ms
			if (ms >= 1000){								
				ms = ms - 1000;
				sec++;										//Increment second by 1 and remove 1000 ms
			}
			
			if (sec >= 60){
				sec = sec - 60;
				min++;										//Increment minute by 1 and remove 60 sec
			}
			
			if (min >= 60)
				min = min - 60;								//Clear minutes if above 60 since we're not displaying hours
			
			int c_ms = (ms % 100) / 10;						//Compute necessary values
			int d_ms =  ms / 100;
			int u_s = sec % 10;
			int t_s = sec / 10;
			int u_m = min % 10;
			int d_m = min / 10;

			HEX_write_ASM(HEX0, c_ms); 						//Write values to hex
			HEX_write_ASM(HEX1, d_ms);	    
			HEX_write_ASM(HEX2, u_s);
			HEX_write_ASM(HEX3, t_s);
			HEX_write_ASM(HEX4, u_m);
			HEX_write_ASM(HEX5, d_m);
			}
		}
		//Check if there is any kind of interupt
		if (BUTTON_FLAG != 4) { 
			
			if (BUTTON_FLAG == 0) { 				//If button 0 sends an interupt, start timer 
				set_timer = 1;
			} 
			
			else if (BUTTON_FLAG == 1) {			//If button 1 sends an interupt, pause timer 
				set_timer = 0;
			} 
			
			else if (BUTTON_FLAG == 2) { 			//If button 2 sends an interupt, reset timer 
				ms = sec = min = set_timer = 0;
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);
			}
			
			BUTTON_FLAG = 4;						//Reset the flag
		}
	}

	return 0;

}
