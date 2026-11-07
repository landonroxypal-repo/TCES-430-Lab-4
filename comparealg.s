.syntax unified
.cpu cortex-m7
.thumb

// Memory Layout Declarations
.equ RCC_BASE, 0x40023800
.equ GPIOI_BASE, 0x40022000
.equ RCC_AHB1ENR, 0x30
.equ GPIO_MODER, 0x00
.equ GPIO_ODR, 0x14
.equ ARRAY_LENGTH, 10

// Bit Field Definitions for Pin PI0
.equ RCC_GPIOIEN, (1 << 8)

.equ GPIOI_PIN0_OUT, (1) // Sets Pin 0 to Output (01 in bits 1:0)
.equ GPIOI_PIN0_ON, (1) // Sets Pin 0 High

.equ GPIOI_PIN2_OUT, (1 << (2 * 2)) // Sets Pin 2 to Output (01 in bits 5:4)
.equ GPIOI_PIN2_ON, (1 << 2) // Sets Pin 2 High

.section .text
.global compare_LED2
.align 2
.thumb_func

compare_LED2:
	// 1. Enable peripheral clock gate for Port I
	LDR R0, =RCC_BASE
	LDR R1, [R0, #RCC_AHB1ENR]
	ORR R1, R1, #RCC_GPIOIEN
	STR R1, [R0, #RCC_AHB1ENR]

	// 2. Configure Pin PI0 (External Red LED, D10) as Output
	LDR R0, =GPIOI_BASE
	LDR R1, [R0, #GPIO_MODER]
	BIC R1, R1, #(3 << 2 * 0) // Clear bits 1:0
	ORR R1, R1, #GPIOI_PIN0_OUT // Set to Output mode
	STR R1, [R0, #GPIO_MODER]

	// 3. Configure Pin PI2 (Internal Yellow LED, D8) as Output
	LDR R0, =GPIOI_BASE
	LDR R1, [R0, #GPIO_MODER]
	BIC R1, R1, #(3 << 2 * 2) // Clear bits 5:4
	ORR R1, R1, #GPIOI_PIN2_OUT // Set to Output mode
	STR R1, [R0, #GPIO_MODER]

	// 4. Algorithm to determine largest number
	// Let R0 be the counter.
	// Let R1 be the current address in the array.
	// Let R2 be the address of the largest integer by absolute value.
	// Let R3 be the value of the current address in the array.
	// Let R4 be the value of the current largest integer in the array.

	MOV R0, #0  // Reset the value of R0.

	LDR R2, =FLASH_NUMBERS
	ADD R1, R2, #0 // Load current address into R1.

FOR_LOOP:	// Loop
	LDR R3, [R1] // Load current value of current index into R3
	LDR R4, [R2] // Load current largest value of current index into R4

	// Convert value in R3 to absolute value
	CMP R3, #0
	IT  LT
	RSBLT R3, R3, #0

	// Convert value in R4 to absolute value
	CMP R4, #0
	IT  LT
	RSBLT R4, R4, #0

	// Compare the two
	CMP R4, R3
	IT LT
	ADDLT R2, R1, #0;

	// Increment counter and next address
	ADD R0, R0, #1 // Increment counter
	ADD R1, R1, #4 // Increment address

	CMP R0, #ARRAY_LENGTH
	IT LT
	BLT FOR_LOOP


// Loop exit

// Reload GPIOI offset
LDR R0, =GPIOI_BASE
// Load largest value from memory
LDR R1, [R2]

CMP R1, #0
IT LT
BLT YELLOW_LED_ON

// Positive light
RED_LED_ON:
	LDR R1, [R0, #GPIO_ODR]
	ORR R1, R1, #GPIOI_PIN2_ON
	STR R1, [R0, #GPIO_ODR]
	BX LR // Return execution context to caller

// Negative light
YELLOW_LED_ON:
	LDR R1, [R0, #GPIO_ODR]
	ORR R1, R1, #GPIOI_PIN0_ON
	STR R1, [R0, #GPIO_ODR]
	BX LR // Return execution context to caller

.align 2
FLASH_NUMBERS:
	.word 0x0CD9BC16 // (215596054)
	.word 0xE979B702 // (-377899262)
	.word 0x5429E69C // (1412032156)
	.word 0xF8252A94 // (-131781996)
	.word 0xA482B0D9 // (-1534938919)
	.word 0x60B2D023 // (1622331427 = 0x60B2D023, -1622331427 = 0x9F4D2FDD)
	.word 0x2B1E6F8A // (867451303)
	.word 0xD4448D67 // (-733704857)
	.word 0xE285FB4A // (-494535862)
	.word 0x2B1E6F8A // (723414922)
