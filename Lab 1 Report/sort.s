			.text
			.global _start

_start:		LDR R1, = N			//R1 Points to number of elements in the list
			LDR R2, [R1]		//R2 is the number of elements in the list (Counter)
			LDR R3, =NUMBERS	//R3 Points to the first element in the list
		
BUBBLESORT: SUBS R2, R2, #1		//Decrement bubblesort counter
			CMP R2, #0			//Check if list is done
			BEQ END				//if done, with no errors, END
			LDR R6, [R3]		//Load current element
			LDR R7, [R3, #4]	//Load next element
			CMP R6, R7			//Compare current and next element
			BLT POST			//If Less than (i.e in correct location) go back to POST to increment pointer
			B WHILE				//If not go to WHILE to sort
			
PRE:		LDR R2, [R1]		// Reload R2 with # of elements (counter)
			LDR R3, = NUMBERS	//Reload pointer to first number
			B BUBBLESORT

POST:		ADD R3, R3, #4		//Increment Bubblesort counter
			B BUBBLESORT

WHILE:		LDR R4, [R3]		//R4 Holds the current number in the list
			LDR R5, [R3, #4]	//R5 Holds the next number in the lisT
			CMP R4, R5			//Compare 1st and 2nd number
			BGT SWAP			//Branch if R4 is greater than R5
			SUBS R2, R2, #1		//Decrement counter
			CMP R2, #0			//Check if list is done
			BEQ PRE				//When list is done, go to PRE to restart bubblesort to check
			B INCREMENT

SWAP:		STR R5, [R3]	//Storing next element in current location
			STR R4, [R3, #4]//Storing current element in next location		
			LDR R2, [R1]	//Reloading # of elements counter
			LDR R3, =NUMBERS//Reloading pointer to first number
			B INCREMENT

INCREMENT:	ADD R3, R3, #4	//Incrementing current pointer
			B WHILE

END:		B END

N:			.word 8
NUMBERS:	.word 8, 7, 6, 5, 4, 3, 2, 1
