 .text
			.global _start

_start:
			LDR R4, = RESULT //R4 points to the result location
			LDR R2, [R4,#4]  //R2 holds the # of elemens in the list
			ADD R3, R4, #8   //R3 points to the first number
			LDR R0, [R3]	 //R0 holds the first number in the list
			BL  LOOP

END:		B END 			//Inf loop


LOOP:		SUBS R2,R2,#1	//decrements the loop counter
			BXEQ 	 LR			//end loop if counter reached 0
			ADD R3, R3, #4	//R3 points to next # on the list
			LDR R1, [R3]	//R1 holds the next # on the list
			CMP R0, R1		//check if it is greater than the maximum # 
			BGE LOOP		//if no, branch back to the loop
			MOV R0, R1		//if yes update the current max
			B LOOP			//branch back to the loop

DONE:		STR R0, [R4]	//Store the result in the memory location


RESULT:		.word	0		//memory assigned for the result location
N:			.word	7		//number of entries in the list
NUMBERS:	.word	4,	5,	3,	6	//the list data
			.word	1,	8,	2
