#include <stdio.h>

#include "./drivers/inc/VGA.h"	
#include "./drivers/inc/ps2_keyboard.h"	

int main () {

char *data;
int x = 0;
int y = 0;

//Clear the screen 
VGA_clear_pixelbuff_ASM();
VGA_clear_charbuff_ASM();

while(1){
	//If Rvalid = 1, print it
	if(read_PS2_data_ASM(data)){
		VGA_write_byte_ASM(x, y, *data);
		x+=3;
		//Reset x at the end of the screen		
		if(x > 79){
			x = 0;
			y++;
		}
		//Reset y at the end of the screen
		if(y > 59){
			y = 0;
		}
	}
}

return 0;

}
