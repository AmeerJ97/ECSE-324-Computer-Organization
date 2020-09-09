		.text
		.equ VGA_CHAR_BUFF_BASE , 0xC9000000
		.equ VGA_PIXEL_BUFF_BASE, 0xC8000000
		
		.global VGA_clear_charbuff_ASM
		.global VGA_clear_pixelbuff_ASM
		.global VGA_write_char_ASM
		.global VGA_write_byte_ASM
		.global VGA_draw_point_ASM
		
VGA_clear_charbuff_ASM:
		PUSH {R4-R5};
		ldr R3, = VGA_CHAR_BUFF_BASE;
		MOV R2, #0;	//0 value to clear
		MOV R0, #0;	//X Counter
		
clearChar_Loop_1:
		MOV R1, #0;	//Y counter
		ADD R4, R3, R0, LSL #1; //Moving in x direction
clearChar_Loop_2:
		ADD R5, R4, R1, LSL #7;	//Moving in Y direction
		STRH R2,[R5];	//Store half word 0 in current memory location
		//Checking if Y end is reached
		ADD R1, R1, #1;
		CMP R1, #60;
		BLT clearChar_Loop_2;
		//Checking if X end is reached for every Y
		ADD R0, R0, #1;
		CMP R0,#80;
		BLT clearChar_Loop_1;
		POP {R4-R5};
		BX LR;
		
VGA_clear_pixelbuff_ASM:
		PUSH {R4-R5};
		LDR R3, = VGA_PIXEL_BUFF_BASE;
		MOV R0, #0;	//X counter
		MOV R2, #0;	//0 value to clear
clearPixel_loop_1:
		MOV R1, #0;	//Y counter
		ADD R4, R3, R0, LSL #1;	//Moving in X
clearPixel_loop_2:
		ADD R5, R4, R1, LSL #10; //Moving in Y 
		STRH R2, [R5];		//Store half word 0
		//Check if Y end is reached
		ADD R1, R1, #1;
		CMP R1, #240;
		BLT clearPixel_loop_2;
		//Check if X end is reached
		ADD R0, R0, #1;
		CMP R0, #320;
		BLT clearPixel_loop_2;
		POP {R4-R5};
		BX LR;
VGA_write_char_ASM:
		//Arguments: R2: 3rd argument to display
		// R0 & R1 : Coordinates at which to display X-Y
		LDR R3, = VGA_CHAR_BUFF_BASE;
		
		CMP R0, #0;	//Check X coordinate
		BXLT LR;
		CMP R1, #0; //Check Y coordinate
		BXLT LR;
		CMP R0, #79; //Checking if X coordinate at end of X
		BXGT LR;
		CMP R1, #59;	//Checking if Y coordinate at end of Y 
		BXGT LR;
		//Move in X & Y 
		ADD R3, R3, R0;	//X
		ADD R3, R3, R1, LSL #7; //Y
		STRB R2, [R3]; //Store argument to display in correct coordinate
		BX LR;
VGA_write_byte_ASM:
		//Arguments: R2: 3rd HEX argument to display
		// R0 & R1 : Coordinates at which to display X-Y
		LDR R3, = VGA_CHAR_BUFF_BASE;
		CMP R0, #0;	//Check X coordinate is 0
		BXLT LR;
		CMP R1, #0;	//Check Y coordinate is 0
		BXLT LR;
		CMP R0, #79;	//Check if X coordinate is at end
		BXGT LR;
		CMP R1, #59; //Check if Y coordinate is at end
		BXGT LR;
		//Temp
		MOV R5, #0;
		MOV R6, #0;
		MOV R7, #0;
		PUSH {R5-R7};
		//Move in X and Y by input arguments
		ADD R3, R3, R0;
		ADD R3, R3, R1, LSL #7;
		
		AND R5, R2, #0xF0; //0xF0 = 240
		AND R6, R2, #0x0F; //0x0F = 15 
		LSR R5, R5, #4;
		
		LDR R4,= HEX_;
		ADD R7, R4, R6;	  //Hex 2
		ADD R4, R4, R5;	  //Hex 1
		
		LDRB R4, [R4];	
		STRB R4, [R3];	  //Draw Hex 1

		LDRB R7, [R7];
		STRB R7, [R3,#1];  //Draw Hex 2
		
		POP {R5-R7};
		BX LR;
VGA_draw_point_ASM:
		CMP R0, #0
		BXLT LR
		CMP R1, #0
		BXLT LR
		CMP R0, #319
		BXGT LR
		CMP R1, #239
		BXGT LR

		LDR R3, =VGA_PIXEL_BUF_BASE
		ADD R3, R3, R0, LSL #1
		ADD R3, R3, R1, LSL #10
		STRH R2, [R3]
		BX LR
HEX_:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	.end
