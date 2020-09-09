			.text
			.global _start

_start:
			LDR R4, = MAXIMUM //R4 points to the max location
			LDR R2, [R4,#8]  //R2 holds the # of elemens in the list for maximum
			ADD R3, R4, #12   //R3 points to the first number for max
			LDR R0, [R3]	 //R0 holds the first number in the list for maximum

MAX:		SUBS R2,R2,#1	//decrements the loop counter
			BEQ STORE		//end loop if counter reached 0
			ADD R3, R3, #4	//R3 points to next # on the list
			LDR R1, [R3]	//R1 holds the next # on the list
			CMP R0, R1		//check if it is greater than the maximum # 
			BGE MAX			//if no, branch back to the MAX
			MOV R0, R1		//if yes update the current max
			B MAX			//branch back to the MAX loop

STORE:		STR R0, [R4]		//Store max in the memory location
			LDR R7, = MINIMUM	//R7 points to the min location
			LDR R5, [R7,#4]		//R5 holds the # of elements in the list for minimum
			ADD R8, R7, #8	 //R8 points to the next number for min
			LDR R4, [R7,#8]	//R4 holds the first number in the list for minimum	
			//B MIN

MIN:		SUBS R5,R5,#1	//decrement the loop counter
			BEQ	DONE		//end loop if counter reached 0		
			ADD R8, R8, #4	//R8 points to the next # on the list
			LDR R9, [R8]	//R1 NOW holds the next # on the list
			CMP R4, R9		//check if it is less than the minimum #
			BLE MIN			//if no, branch back to MIN	
			MOV	R4, R9		//if yes update the current min
			B MIN			//branch back to MIN loop
			


DONE:		MOV R6,	R4	//Store the min in the memory location
			SUB R6, R0, R6		
			ASR R6, R6, #2	//Arithmetic right shift by 2 to divide by 4
				
			
END:		B END 			//Inf loop

MAXIMUM:	.word	0		//memory assigned for the location of max
MINIMUM: 	.word 	0		//memory assigned for the location of min
N:			.word	7		//number of entries in the list
NUMBERS:	.word	400,	5,	4,	6	//the list data
			.word	4,	8,	7

