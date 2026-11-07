.syntax unified
.cpu cortex-m7
.thumb

.equ a, 5
.equ b, 5

.section .text
.global translation
.align 2
.thumb_func

translation:
// Let R0 be i
// Let R1 be j
// Let R2 be k
// Let R4 be a
// Let R5 be b

MOV R0, #1
MOV R1, #0
MOV R2, #-1

MOV R4, #a
MOV R5, #b

while_loop:
	CMP R0, R1 // while i > j
	IT LE
	BLE loop_end

	ADD R0, R0, R4 // i = i + a
	LDR R3, #2 // Load immediate value of 2
	MUL R3, R1, R3 // calculate 2 * j
	SUB R0, R0, R3 // i = i + a - 2 * j

	CMP R1, R2
	IT LT
	BLT if_statement_end

	ADD R0, R0, #2 // i = i + 2
	SUB R2, R2, R5 // k = k - b
	ADD R2, R2, R3 // k = k - b + 2 * j


if_statement_end:
	ADD R1, R1, #1 // j++

	B while_loop

loop_end:
BX LR // Return control to caller

