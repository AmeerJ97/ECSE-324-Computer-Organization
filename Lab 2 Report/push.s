				.text
				.global _start


_start:			MOV R10, #10
				B PUSH
				
PUSH:			SUB SP, SP, #4			//Decreasing stack pointer i.e adding an element. SP now points to the top of the stack
				STR R10, [SP]			//Pushing element to stack 
				B POP				

POP:			LDR R9, [SP]
				ADD SP, SP, #4	

								
END: B END		//infinite loop



