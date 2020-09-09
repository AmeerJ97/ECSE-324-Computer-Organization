#include <stdio.h>
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/vga.h"
#include "./driver/inc/ps2_keyboard.h"

void main(){
	int x = 0, y = 0;
	VGA_clear_charbuff_ASM();
		while(true){
			char input;	//input to print
			if(read_PS2_dta_ASM(&input)){ 
				VGA_write_byte_ASM(x,y,input);
				x = x + 3; //Moving in X (leaving gap)
				if (x >79){
					x = 0; //reached end of x, reset
					y++; 	//Move in y
					if (y > 59){ //end of x and y, reset and clear vga display
						VGA_clear_charbuff_ASM();
						x = 0;
						y = x;
					}
				}
			}
		}
	}
				