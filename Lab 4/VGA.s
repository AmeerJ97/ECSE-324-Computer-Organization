		.global main_loop
		.text
		.equ PIXEL_BASE, 0xC8000000
		.equ CHAR_BASE, 0XC9000000
		.equ PUSH_BUTTON_DATA, 0xFF200050
		.equ PUSH_BUTTON_MASK, 0xFF200058
		.equ PUSH_BUTTON_EDGE, 0xFF20005C
		.global VGA_clear_charbuff_ASM
		.global VGA_clear_pixelbuff_ASM
		.global VGA_write_char_ASM
		.global VGA_write_byte_ASM
		.global VGA_draw_point_ASM
		.global read_PB_data_ASM
		.global PB_data_is_pressed_ASM
		.global read_PB_edgecap_ASM
		.global PB_edgecap_is_pressed_ASM
		.global PB_clear_edgecap_ASM
		.global enable_PB_INT_ASM
		.global disable_PB_INT_ASM
main_loop:
	
	PUSH {LR}				
	BL read_PB_data_ASM		//Results in R0
	POP	{LR}			
	
	CMP R0, #1			//PB0 pushed
	PUSHEQ {LR}			//If PB0 pushed, PUSH LR
	BLEQ test_byte			// If PB0 pushed, call test_byte 
	POPEQ {LR}
	
	CMP R0, #2			//PB1 pushed
	PUSHEQ {LR}			//If PB1 pushed, PUSH LR
	BLEQ test_char			// If PB1 pushed, call test_char
	POPEQ {LR}
	
	CMP R0, #4			//PB2 pushed
	PUSHEQ {LR}			//If PB2 pushed, PUSH LR
	BLEQ test_pixel			// If PB2 pushed, call test_pixel
	POPEQ {LR}
	
	CMP R0, #8			// PB3 pushed
	PUSHEQ {LR}			//If PB3 pushed, push LR
	BLEQ VGA_clear_charbuff_ASM	// & clear everything
	POPEQ {LR}
	PUSHEQ {LR}
	BLEQ VGA_clear_pixelbuff_ASM
	POPEQ {LR}
	B main_loop				//infinite loop 


test_char:
	MOV R1, #0			// R1 is y
	MOV R2, #0			// R2 is c (character)
	B char_loop1
char_loop1:			
	MOV R0, #0			// R0 is x (reset to 0 after each inner loop
	CMP R1, #59			// compare y to 59
	BEQ char_done			// if equal, done	
char_loop2:	
	PUSH {R0-R2, LR}		// save value of x, y and c
	BL VGA_write_char_ASM		// call write char function
	POP {R0-R2, LR}
	CMP R0, #79				// compare x to 79
	ADDEQ R1, R1, #1		// if equal, add 1 to y
	BEQ char_loop1			// and do next outer loop iteration
	
	ADD R0, R0, #1			// add 1 to x
	ADD R2, R2, #1			// add 1 to c (next character)
	B 	char_loop2		// inner loop	
char_done:
	MOV R1, #0			// reset registers
	MOV R2, #0
	BX 	LR 			// branch out
// test byte function, R0, R1, R2 are x, y, c respectively
test_byte:	
	MOV R1, #0				
	MOV R2, #0
	B byte_loop1
byte_loop1:
	MOV R0, #0			// reset x each outer loop iteration
	CMP R1, #59			// check if outer loop done
	BGE byte_done	
byte_loop2:
	PUSH {R0-R2, LR}
	BL VGA_write_byte_ASM		// call write byte function
	POP {R0-R2, LR}
	CMP R0, #79			// check is x is 79 or more
	ADDGE R1, R1, #1		// if so, go to next y
	BGE byte_loop1			
	ADD R0, R0, #3			// use steps of 3 as in C code
	ADD R2, R2, #1			// add 1 to c
	B byte_loop2			// inner loop
	
byte_done:
	MOV R1, #0			// reset registers
	MOV R2, #0
	BX	LR			// branch out
	
test_pixel:	
	MOV R1, #0
	MOV R2, #0
	B pixel_loop1
pixel_loop1:
	MOV R0, #0
	CMP R1, #239			// check if y reached end
	BEQ pixel_done
pixel_loop2:
	PUSH {R0-R3, LR}
	BL VGA_draw_point_ASM		// Draw
	POP {R0-R3, LR}
	MOVW R3, #319			
	CMP R0, R3			//Check limit
	ADDEQ R1, R1, #1		// if equal, go to next y
	BEQ pixel_loop1			// go to outer loop
	
	ADD R0, R0, #1			// add 1 to x
	ADD R2, R2, #1			// add 1 to y
	B pixel_loop2
pixel_done:				// reset registers for use by other methods
	MOV R1, #0
	MOV R2, #0
	MOV R3, #0
	BX 	LR 

VGA_clear_pixelbuff_ASM:
	PUSH {R4-R6}			// PUSH registers to use
	LDR R3, =PIXEL_BASE		// R3 points to pixel buffer address
	MOV R2, #0			// R2 to clear pixels
	MOV R0, #0			// R0 for x

clear_pixel_xloop:
	MOV R1, #0			// R1 for y
	ADD R4, R3, R0, LSL #1		// move in x
clear_pixel_yloop:
	ADD R5, R4, R1, LSL #10		// next y on same row
	STRH R2, [R5]			// clearing
	ADD R1, R1, #1			// move in y  
	CMP R1, #239			// check y limit
	BLE clear_pixel_yloop		
	ADD R0, R0, #1			// move in x
	MOVW R6, #319			
	CMP R0, R6			// check x limit
	BLE clear_pixel_xloop		
	POP {R4-R6}			// Return registers to original state
	BX LR				// Return
//Similarly
VGA_clear_charbuff_ASM:
	PUSH {R4-R5} 			
	LDR R3, =CHAR_BASE		
	MOV R2, #0			// Initializing
	MOV R0, #0			// R0 for x
clear_char_xloop:
	MOV R1, #0			// R1 for y
	ADD R4, R3, R0			// R4 contains next x value
clear_char_yloop:
	ADD R5, R4, R1, LSL #7		//#7 since y location start is at bit 7
	STRB R2, [R5]			//Clear pixel
	ADD R1, R1, #1			//move in y
	CMP R1, #59			//check y limit
	BLE clear_char_yloop		
	ADD R0, R0, #1			//move in x
	CMP R0, #79			//check x limit
	BLE clear_char_xloop		
	POP {R4-R5}			//Return registers to inital state
	BX LR
		

read_PB_data_ASM:					//only access the pushbutton data register
		LDR R1, =PUSH_BUTTON_DATA	//load the contents of the pushbutton register into R1
		LDR R0, [R1]				//USE R0 to pass arguments back	
		BX LR							

PB_data_is_pressed_ASM:				//R0 contains which button to check, hot-one encoding
		LDR R1, =PUSH_BUTTON_DATA	
		LDR R2, [R1]				//load contents of register into R2
		AND R2, R2, R0				// and R2 and R0 ad store value in R2, since one-hot encoding ensures that if the one selected is pressed it gives 1 at the right spot
		CMP R2, R0					// compare R2 with R0
		MOVEQ R0, #1				//True if equal, thus it is pressed
		MOVNE R0, #0				//false which means negative, the button isnt pressed
		BX LR

read_PB_edgecap_ASM:				//no input, only access edgecapture register
		LDR R1, =PUSH_BUTTON_EDGE	
		LDR R0, [R1]				//load the contents of the pushbutton register into R1
		AND R0, R0, #0xF			//Get only edge cap bits by AND with 1111
		BX LR						//USE R0 to pass arguments back		
		
PB_edgecap_is_pressed_ASM:			//R0 contains which button to check, hot-one encoding
		LDR R1, =PUSH_BUTTON_EDGE	
		LDR R2, [R1]				//load contents of register into R2
		AND R2, R2, R0
		CMP R2, R0
		MOVEQ R0, #1				//True if equal, thus it is pressed
		MOVNE R0, #0				//false so negative, the button isnt pressed
		BX LR

PB_clear_edgecap_ASM:				//R0 contains which pushbutton
		LDR R1, =PUSH_BUTTON_EDGE
		MOV R2, R0					
		STR R2, [R1]				//storing any value in edgecap will reset, p.21 (anything but #0) would work
		BX LR

enable_PB_INT_ASM:					//R0 contains which button to enable, hot-one encoding
		LDR R1, =PUSH_BUTTON_MASK
		MOV R2, #0xF				//since pushbuttons has only 4 digits use 0xF
		STR R2, [R1]				//store it back into mask location
		BX LR

disable_PB_INT_ASM:					//R0 is hot-one encoding of which button to disable
		LDR R1, =PUSH_BUTTON_MASK	//load mask location
		LDR R2, [R1]				//load mask bits
		BIC R2, R2, R0				//AND of R2 with the complement of R0
		STR R2, [R1]				//store it back into the mask
		BX LR
				
		.end

