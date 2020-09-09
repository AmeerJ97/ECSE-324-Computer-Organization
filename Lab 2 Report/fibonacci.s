				.text
				.global _start

_start:			MOV R0,#10			// number n to be computed (n=6)
				BL FIBONACCI
				B END

FIBONACCI:		PUSH {R1,R2,LR}
				MOV R1, R0
				CMP R0, #2			//If condition (n<=2)
				MOVLT R0,#1			//If N<2, return 1
				BLE DONE
				SUB R0,R1,#1		//Fib(n-1)
				BL FIBONACCI
				MOV R2, R0			//R2 Holds result of fib(n-2)
				SUBS R0,R1,#2		//Fib (n-2)
				BL FIBONACCI
				ADD R0,R0,R2		//fib (n-2) + fib (n-1)

DONE:			POP {R1,R2,PC}	

END: 			B END
