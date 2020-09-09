			.text
			.global _start

_start:
			MOV R1, #0			//R1 contains the Sum of signal
			LDR R2, =N			//R2 contains the address of the N location
			LDR R3, [R2]		//R3 contains the number of elements in the signal
			ADD R6, R2, #4		//R6 contains the address to the first element in the signal
			
																
SUM:		LDR R4, [R6]		//R4 Contains the current number
			ADD R1, R4, R1		//Adding the current element to sum
			SUBS R3, R3, #1		//Subtract our counter which is R3
			BEQ SETUP			//Branch if equal to zero
			ADD R6, R6, #4		//R6 points to next number
			B SUM			//Branch back to SUM
			
SETUP:		MOV R7, #0		//Division counter
			LDR R8, [R2]	//DivisoR
			LDR R10,= NUMBERS	//Pointer to first element
			LDR R11, [R2]		//R11 contains Number of elements for CENTER subtraction (counter)
			
	
DIVIDE:		SUBS R1, R1, R8	//Subtracting Sum by divisor
			ADD R7, #1		//Division Result (Counter)
			CMP R1, R8		//Comparing subtracted sum by divisor 
			BGE DIVIDE		
			B CENTER		//When done, branch to CENTER

CENTER:		LDR R9, [R10]
			SUBS R9, R9, R7	//Subtracting current number by average
			STR R9, [R10]	//Storing in averaged list
			ADD R10, R10, #4	//Point to next element in NUMBERS
			SUBS R11, R11, #1		//Counter till number of elements is 0
			CMP R11, #0	
			BEQ END
			B CENTER	


END:		B END				//Inf loop



N:			.word 8			//Number of enteries in the signal
NUMBERS:	.word 5, 5, 10, 5, 25, 200, 5, 5
