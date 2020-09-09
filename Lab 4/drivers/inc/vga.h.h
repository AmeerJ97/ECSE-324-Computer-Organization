#ifndef _VGA
#define _VGA

	void VGA_clear_charbuff_ASM();
	void VGA_clear_pixelbuff_ASM();
	
	void VGA_write_char_ASM(int x, int y, char c);	//LOAD THE CHAR
	void VGA_write_byte_ASM(int x, int y, char byte);	
	
	void VGA_draw_point_ASM(int x, int y, short colour); 	//DRAW PIXEL

#endif