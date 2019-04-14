#include <stdio.h>

#include "./drivers/inc/VGA.h"	
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/slider_switches.h"		

void test_char(){
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++){
		for(x = 0; x <= 79; x++){
			VGA_write_char_ASM(x, y, c++);		
		}
	}
}

void test_byte(){
	int x, y;
	char c = 0;
	
	for(y = 0; y <= 59; y++){
		for(x = 0; x <= 79; x+=3){
			VGA_write_byte_ASM(x, y, c++);
		}
	}
}

void test_pixel(){
	int x, y;
	unsigned short colour = 0;
	
	for(y = 0; y <= 239; y++){
		for(x = 0; x <= 319; x++){
			VGA_draw_point_ASM(x, y, colour++);
		}
	}


}

int main () {

while(1){
	//If any switch is on, use test byte
	if(read_slider_switches_ASM()){
		if(PB_edgecap_is_pressed_ASM(PB0)){
			test_byte();
			PB_clear_edgecap_ASM(PB0);
		} 
	} else {									//Otherwise, use test char
		if(PB_edgecap_is_pressed_ASM(PB0)){
			test_char();
			PB_clear_edgecap_ASM(PB0);
		} 
	}
	
	if(PB_edgecap_is_pressed_ASM(PB1)){			//If button 1 is pressed, test pixel
			test_pixel();
			PB_clear_edgecap_ASM(PB1);
	}
	if(PB_edgecap_is_pressed_ASM(PB2)){			//If button 2 is pressed, test pixel
			VGA_clear_pixelbuff_ASM();
			PB_clear_edgecap_ASM(PB2);
		} 
	if(PB_edgecap_is_pressed_ASM(PB3)){			//If button 3 is pressed, test pixel
			VGA_clear_charbuff_ASM();
			PB_clear_edgecap_ASM(PB3);
		}

	//PB_clear_edgecap_ASM(PB0 | PB1 | PB2 | PB3); 
	
}

	return 0;

}
