#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"
#include <math.h>
//#include <stdio.h>


int amplitude = 1;		//Amplitude to control volume	
char previous;			//Save previous make code to compare with current one
float frequency[8] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};		//All necessary frequencies

int keyboard[8] = {0, 0, 0, 0, 0, 0, 0, 0};		//Array to keep track of buttons that are getting pressed	

int signal(float freq, int time) {
	
	//simulate modulo process
	int multiplicity = (int) (freq*time)/48000;		//calculate the number of times 48k divides freq*time
	float index = freq*time-(multiplicity*48000);	//find the remainder
	
	
	int integer = (int) index;						//remove decimal points of index
	float decimal = index - integer;				//get decimal points

	//linear interpolation works even if index is not an integer
	float signal = (1-decimal)*sine[integer] + decimal*sine[integer+1];
	
	return (int) (signal);

}

float calculateSignal(int counter) {
	int i;
	float totalSignal = 0;
	
	for(i = 0; i < 8; i++){
		if(keyboard[i] == 1){
			totalSignal += signal(frequency[i], counter);	//add signals of all keys that were pressed
		}
	}
	//return the sum of signals * amplitude0-
	return totalSignal * amplitude;
}

void displayWave() {

	float freq;
	int i;
	//Sum up freq 
	for(i = 0; i<8; i++) {
		freq = freq + keyboard[i]*frequency[i];
	}
	VGA_clear_pixelbuff_ASM();

	short colour = 0xFFFFFF;
	int x, y;

	// 48000 is the total sine wave, divide this by the number of x pixels per full iteration, with a base frequency of 60 
	int seg = 48000/(320.0*60/freq);

	int time_pos = 0;
	for(x=0; x<320; x++) {
		// use a sine function in order to calculate the y pixel to draw the pt on 
		//sine[6000] = the wave for 1/4 of the cycle.    Amplitude = volume affects amplitude of wave. 
		y = (int) (((float)amplitude)*(float)sine[time_pos]*((float)10/(float)sine[6000])) + 120;


		//Draw the point
		VGA_draw_point_ASM(x, y, colour);
		// Increment position based on the increment variable. 
		time_pos += seg; 	
		//Resets the sine wave to the beginning of the period. 
		if (time_pos > 48000) {
			time_pos -= 48000; 
		} 
	}
}

//Update the state of keyboard array
void update(char *input) {
	
	//Sitch case covering every make and break code of the keyboard
	switch(*input) {
		case 0x1C:	//A
			keyboard[0] = 0;
			if(previous != 0xF0) {		//If previous is not 0xF0, then its make code
				keyboard[0] = 1;
			}
			break;
		case 0x1B:	//S
			keyboard[1] = 0;
			if(previous != 0xF0) {
				keyboard[1] = 1;
			}
			break;
		case 0x23:	//D
			keyboard[2] = 0;
			if(previous != 0xF0) {
				keyboard[2] = 1;
			}
			break;
		case 0x2B:	//F
			keyboard[3] = 0;
			if(previous != 0xF0) {
				keyboard[3] = 1;
			}
			break;
		case 0x3B:	//J
			keyboard[4] = 0;
			if(previous != 0xF0) {
				keyboard[4] = 1;
			}
			break;
		case 0x42:	//K
			keyboard[5] = 0;
			if(previous != 0xF0) {
				keyboard[5] = 1;
			}
			break;
		case 0x4B:	//L
			keyboard[6] = 0;
			if(previous != 0xF0) {
				keyboard[6] = 1;
			}
			break;
		case 0x4C:	//;
			keyboard[7] = 0;
			if(previous != 0xF0) {
				keyboard[7] = 1;
			}
			break;
		case 0x4E:	//-
			if(previous != 0xF0) {
				amplitude++;
			}
			break;
		case 0x55:	//=
			if(previous != 0xF0) {
				amplitude--;
			}
			break;
		default:
		break;
	}
}



int main() {
	//Turning on interupts for timer 0
	int_setup(1, (int[]){199});

	//Initializing timer 0
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 20; //20 us seconds (1/48000)
	hps_tim.LD_en = hps_tim.INT_en = hps_tim.enable = 1;
	HPS_TIM_config_ASM(&hps_tim);

	// initialization of the variables
	char *input;	//pointer pointing to most recent make code
	int counter = 0; 
	float sumOfSignal;	// sum of the signal

	while(1) {
		if(read_ps2_data_ASM(input)) {	//Read the data from the keyboard
			if(previous != *input) {	//Check if the state of the button has changed
				update(input);	//update the state of keyboard
				displayWave();
				//Check of a key was released
				if(previous == 0xF0) {
					previous = 0;		//If key is break code, set previous to 0
				} else {
					previous = *input;	//else update previous
				}
			}
		}
		sumOfSignal = calculateSignal(counter);		//compute signal to write to audio

		
		if(TIM0_FLAG) {		// Check the timer interrupt flag
			TIM0_FLAG = 0;	// reset interrupt flag
			audio_write_data_ASM(sumOfSignal, sumOfSignal);		// write the audio data 
			counter++;		// increment counter value
			if(counter == 48000) {		// reset the counter when it reaches the end
				counter = 0;
			}
		}

		
	}
	return 0;
}

