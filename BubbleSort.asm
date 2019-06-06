;Alyssa Wilcox and Kyle Janosky
;CIS 11
;Final Assembly Project
;Bubble Sort
;Description:	Create a Bubble Sort algorithm that organizes
;		eight numbers in ascending order
;Input:		User input 8 numbers, 3 digits long, ranging from 000 - 999
;Output:	Display sorted values in ascending order on console

;=-=-=-=-=-=-=-=-=-=-=
;Registers Main Use
;=-=-=-=-=-=-=-=-=-=-=
;R0 as the first item to be manipulated
;R1 as the second item to be manipulated
;R2 as a temporary work variable
;R3 as our pointer, used to access different elements of the array
;R4 as the Outer For-Loop Counter
;R5 as the Inner For-Loop Counter
;R6 as input/output loop counter

;=-=-=-=-=-=-=-=-=-=-=
;Initialization
;=-=-=-=-=-=-=-=-=-=-=

.ORIG x3000

;Inialize Pointer
LD R3, PT		;Load x4000 in R3 as array base address

;Initialize I/O counter
LD R6, COUNT		;Input/Output Counter

;Input Loop	
LEA R0, INPROMPT	;Load input prompt
PUTS			;Display on console
AND R0, R0, #0		;Clear R0
LD R0, SPACE		;Next line
OUT			;Display on console
AND R0, R0, #0		;Clear R0
LEA R0, EXAMPLE		;Load example prompt
PUTS			;Display on console
	
INPUT	
	;A larger number example: 143 = 1 x 10^2 + 4 x 10^1 + 3 x 10^0
	;Handle one digit at a time

;First digit input (Exp: 100 = 1 x 10^2)
	IN			;Input first digit
	AND R5, R5, #0		;Clear R5
	LD R5, HUNDRED		;Load 100 to R5, the counter
	AND R2, R2, #0		;Clear R2
	LD R2, ASCIINEG		;Load negative ASCII offset
	ADD R0, R0, R2		;Add ASCII offset to input digit
	AND R2, R2, #0		;Clear R2
	ADD R2, R0, #0		;Move digit to R2
	AND R0, R0, #0		;Clear R0

	FIRST_DIGIT			;First digit multiplication loop
		ADD R0, R0, R2		;Multiply
		ADD R5, R5, #-1		;Decrement counter
		BRp FIRST_DIGIT		;If positive, keep looping (100 times)

	ADD R1, R0, #0		;R1 now contains first digit
	AND R0, R0, #0		;Clear R0

;Second digit input (Exp: 40 = 4 x 10^1)
	IN			;Input second digit
	AND R5, R5, #0		;Clear R5
	LD R5, TEN		;Load 10 to R5, the counter	
	AND R2, R2, #0		;Clear R2
	LD R2, ASCIINEG		;Load negative ASCII offset
	ADD R0, R0, R2		;Add ASCII offset to input digit
	AND R2, R2, #0		;Clear R2
	ADD R2, R0, #0		;Move second digit to R2
	AND R0, R0, #0		;Clear R0

	SECOND_DIGIT			;Second digit multiplication loop
		ADD R0, R0, R2		;Multiply
		ADD R5, R5, #-1		;Decrement counter
		BRp SECOND_DIGIT	;If positive, keep looping (10 times)

	ADD R4, R0, #0		;R4 now contains second digit
	AND R0, R0, #0		;Clear R0

;Third digit input (Exp: 3 = 3 x 10^0)
	IN			;Input third digit
	AND R2, R2, #0		;Clear R2
	LD R2, ASCIINEG		;Load negative ASCII offset
	ADD R0, R0, R2		;Add ASCII offset to input digit
	AND R2, R2, #0		;Clear R2

;Get the real number
	ADD R2, R1, R4		;First digit (R1) + second digit (R4)
	ADD R2, R0, R2		;(R1 + R2) + third digit (R0)
	STR R2, R3, #0		;Store input value into the array using pointer
	ADD R3, R3, #1		;Increment pointer
	ADD R6, R6, #-1		;Decrement input loop counter
	BRp INPUT		;Condition check. If counter positive, continue looping

;Jump to the sort subroutine
JSR SORT

;Jump to the output subroutine
JSR OUTPUT_LOOP

HALT				;Pause the program

;=-=-=-=-=-=-=-=-=-=-=
;Data Section
;=-=-=-=-=-=-=-=-=-=-=

INPROMPT	.STRINGZ	"Please input 8 numbers (000 - 999) to be sorted:"
EXAMPLE		.STRINGZ	"Example: Input 3 as 003"
OUTPROMPT	.STRINGZ	"The sorted list: "
SPACE		.FILL		x000A	;Spaces out output on console
ASCIINEG	.FILL		xFFD0	;-48 Hex
ASCIIPOS	.FILL		x0030	;48 Hex
HUNDRED		.FILL		x0064	;100 Hex
TEN		.FILL		x000A	;10 Hex
PT		.FILL		x4000	;Array starting point
COUNT		.FILL		#8	;For our counters
DIGIT1		.FILL		x400A	;Storage location for first digit
DIGIT2		.FILL		x400B	;Storage location for second digit
DIGIT3		.FILL		x400C	;Storage location for third digit

;=-=-=-=-=-=-=-=-=-=-=
;Subroutines
;=-=-=-=-=-=-=-=-=-=-=

;Sort subroutine
SORT 	
	;Reset pointer and counters for our sorting loops
	AND R3, R3, #0		;Clear R3
	LD R3, PT		;Reset the pointer value
	AND R4, R4, #0		;Clear R4
	LD R4, COUNT		;Reset counter value
	AND R5, R5, #0		;Clear R5
	LD R5, COUNT		;Reset counter value
	
	;Outer lopp, runs through array multiple times
	OUTER_LOOP
		ADD R4, R4, #-1		;Decrement counter, looping n-1 times
		BRnz SORTED		;Condition check. If N or Z, then array is sorted
		ADD R5, R4, #0		;Copy outer-loop counter to inner-loop counter
		LD R3, PT		;Set the pointer to the beginning of the array
	
	;Inner loop, runs through array once and sorts
	INNER_LOOP
		LDR R0, R3, #0		;Load first item using pointer, store to R0
		LDR R1, R3, #1		;Load second item using pointer, store to R1
		AND R2, R2, #0		;Clear R2
		NOT R2, R1		;Two's compliment
		ADD R2, R2, #1		;Negate second item
		ADD R2, R0, R2		;Subtract negated second item from first item (R0 - R2)
		BRnz SWAPPED		;Condition check. If N, or Z, then the first item smaller (or the same) than second, no need to swap
		;Perform the swap	
		STR R1, R3, #0		;Second item now stored in first slot
		STR R0, R3, #1		;First item now stored in second slot

	;Increments/Decrements counters and pointer once values swapped
	SWAPPED
		ADD R3, R3, #1		;Increment pointer to look at next set of elements
		ADD R5, R5, #-1		;Decrement inner-loop counter
		BRp INNER_LOOP		;Condition check. If P, continue going through inner loop
		BRzp OUTER_LOOP		;Condition check. If P or Z, branch back to outer for-loop

	;Once array is sorted, return
	SORTED	RET			;Return to calling program
	
	RET			;Return to calling program

;Output Subroutine
OUTPUT_LOOP
	LEA R0, OUTPROMPT	;Load output prompt
	PUTS			;Display on console
	LD R3, PT		;Reset the pointer value
	LD R6, COUNT		;Reset the value for the counter

	OUTPUT			;Output loop
	
		AND R1, R1, #0		;Clear R1, used to hold the first digit
		AND R4, R4, #0		;Clear R2, used to hold the second digit
		AND R5, R5, #0		;Clear R5, used to hold the third digit
		AND R0, R0, #0		;Clear R0

		LD R0, SPACE		;Load output formatting to R0
		OUT			;Display on console

		AND R0, R0, #0		;Clear R0
		LDR R0, R3, #0		;Load the value into R0 using our pointer

		;Setup to divide by 100
		AND R2, R2, #0		;Clear R2
		LD R2, HUNDRED		;R2 = 100
		NOT R2, R2		;Two's complement	
		ADD R2, R2, #1		;R2 = -100

		;First subtraction loop, divides number by 100
		SUBTRACT1
			ADD R1, R1, #1		;Counter, keeps track of how many times we subtracted
			ADD R0, R0, R2		;Number - 100, store in R0
			BRzp SUBTRACT1		;Once result is N or Z, find the remainder
		
		;Finds remainder and first digit
		REMAINDER1
			AND R2, R2, #0		;Clear R2
			LD R2, HUNDRED		;R2 = 100
			ADD R0, R0, R2		;Result + 100 to find positive remainder
			ADD R1, R1, #-1		;Subtract one from subtraction counter
						;Finds the real number of times we subtracted before hitting Z or P
			STI R1, DIGIT1		;First digit in R1, store to DIGIT1				

		;Setup to divide by 10
		AND R2, R2, #0		;Clear R2
		LD R2, TEN		;R2 = 10
		NOT R2, R2		;Two's complement
		ADD R2, R2, #1		;R2 = -10

		;Second subtraction loop, divides remainder by 10
		SUBTRACT2
			ADD R4, R4, #1		;Counter, keeps track of how many times we subtracted
			ADD R0, R0, R2		;Remainder - 10, store in R0
			BRzp SUBTRACT2		;Once result is N or Z, find the remainder

		;Finds remainder, second digit, and third digit
		REMAINDER2
			AND R2, R2, #0		;Clear R2
			LD R2, TEN		;R2 = 10
			ADD R5, R0, R2		;Remainder + 10
			STI R5, DIGIT3		;Third digit in R5, store to DIGIT3
			ADD R4, R4, #-1		;Finds the real number of times we subtracted before hitting Z or P
			STI R4, DIGIT2		;Second digit now in R4, store to DIGIT2

		;Display first digit	
		AND R0, R0, #0		;Clear R0	
		LDI R0, DIGIT1		;Load the first digit to R0
		AND R2, R2, #0		;Clear R2
		LD R2, ASCIIPOS		;Load positive ASCII offset to R2
		ADD R0, R0, R2		;Add ASCII offset to first digit
		OUT			;Output to console

		;Display second digit
		AND R0, R0, #0		;Clear R0
		LDI R0, DIGIT2		;Load the second digit to R0
		AND R2, R2, #0		;Clear R2
		LD R2, ASCIIPOS		;Load positive ASCII offset to R2
		ADD R0, R0, R2		;Add ASCII offset to second digit
		OUT			;Output to console

		;Display third digit
		AND R0, R0, #0		;Clear R0
		LDI R0, DIGIT3		;Load the third digit to R0
		AND R2, R2, #0		;Clear R2
		LD R2, ASCIIPOS		;Load positive ASCII offset to R2
		ADD R0, R0, R2		;Add ASCII offset to third digit
		OUT			;Output to console


		ADD R3, R3, #1	;Increment the pointer R3
		ADD R6, R6, #-1	;Decrement the counter R6
		BRp OUTPUT	;Condition check. If loop counter pos, continue loop

	HALT			;Pause program

	RET			;Return to calling program

.END		;End the program
