		.text
		.global read_PS2_data_ASM
		.equ PS2_DATA, 0XFF200100 //DEsoc1 datasheet
	
	read_PS2_data_ASM:
			//Input: R0:mem add of data read
			//Output: R0:Int denoting if data read is valid
			LDR R3, = PS2_DATA
			TST R3, #32768 //Testing 15th bit in register
			BNE Store_value
			MOV R0, #0 //If false, set outout to 0 or invalid
			BX LR
	Store_value:
			STRB R3, [R0];	//Store value to output register
			MOV R0, #1; //Set output to 1 or valid
			BX LR;