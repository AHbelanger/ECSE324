#include <stdio.h>

#include "./drivers/inc/audio.h"

int main() {
	int samples = 1;
    int signal = 0x00FFFFFF; 

    while(1) {
        if(Audio_Output_ASM(signal)) {

            
			//number of samples for 100 Hz --> 48k sampling rate / 100HZ frequency / 2 since square wave = 240
            if(samples == 240) {
                samples = 0;			//reset counter
                if(signal == 0x0) 
                    signal = 0x00FFFFFF; //set signal to high if was low
                
				else 
                    signal = 0x0;  //set signal to low if was high
            }
			samples++; 
        }
    }

    return 0;
}