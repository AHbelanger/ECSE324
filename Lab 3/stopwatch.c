#include <stdio.h>

#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/pushbuttons.h"

int main()
{

	HPS_TIM_config_t timer;		
	timer.tim = TIM0;											//Use timer 0
	timer.timeout = 10000; 										//Set count incrment to 10 ms
	timer.LD_en = timer.INT_en = timer.enable = 1;				//Set all settings to 1 to enable 
	HPS_TIM_config_ASM(&timer);

	HPS_TIM_config_t poll_button;
	poll_button.tim = TIM1;										//Use timer 
	poll_button.timeout = 5000; 								//Set count incrment to 5 ms
	poll_button.LD_en = poll_button.INT_en = poll_button.enable = 1;	//Set all settings to 1 to enable 
	HPS_TIM_config_ASM(&poll_button);

	HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0); //write all values as 0 , initialize
	int ms = 0; 
	int sec = 0;
	int min = 0; 
	int set_timer = 0;		   

	while (1) {
		if (HPS_TIM_read_INT_ASM(TIM0) && set_timer) {		//read value of S-bit and compare with the status of the timer, if both are 1, display stopwatch
			HPS_TIM_clear_INT_ASM(TIM0);					//Clear timer
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

		if (HPS_TIM_read_INT_ASM(TIM1)){					//Check value of push button every 5 ms
			HPS_TIM_clear_INT_ASM(TIM1); 					//Clear timer
			int read_btn_press =	read_PB_data_ASM();		//Read value of push 

			if (0x1 & read_btn_press){						//If first P0 is pressed, start
				set_timer = 1;
			}
			
			else if (0x2 & read_btn_press){					//If first P1 is pressed, pause
				set_timer = 0;
			}
			else if (0x4 & read_btn_press){					//If first P2 is pressed, reset clock and displays
				ms = sec = min = set_timer = 0;
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);
			}
		}
	}

	return 0;

}
