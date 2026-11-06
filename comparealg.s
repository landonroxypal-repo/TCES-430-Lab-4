.syntax unified
.cpu cortex-m7
.thumb

// Memory Layout Declarations
.equ RCC_BASE, 0x40023800
.equ GPIOI_BASE, 0x40022000
.equ RCC_AHB1ENR, 0x30
.equ GPIO_MODER, 0x00
.equ GPIO_ODR, 0x14

// Bit Field Definitions for Pin PI0
.equ RCC_GPIOIEN, (1 << 8)

.equ GPIOI_PIN0_OUT, (1 << 2 * 0) // Sets Pin 0 to Output (01 in bits 1:0)
.equ GPIOI_PIN0_ON, (1 << 0) // Sets Pin 0 High

.equ GPIOI_PIN2_OUT, (1 << 2 * 2) // Sets Pin 2 to Output (01 in bits 5:4)
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

	// 2. Configure Pin PI0 (External Red LED, D13) as Output
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

	// 4.


	// 4. Perform value retrievals from target spaces
	LDR R2, =SRAM_NUMBER
	LDR R2, [R2] // Extract SRAM value into R2
	LDR R3, =FLASH_NUMBER
	LDR R3, [R3] // Extract Flash value into R3

	// 5. Condition evaluationsThe
	CMP R2, R3
	BLE LED_OFF // Skip activation if SRAM value <= Flash value

RED_LED_ON:
	LDR R1, [R0, #GPIO_ODR]
	ORR R1, R1, #GPIOI_PIN1_ON
	STR R1, [R0, #GPIO_ODR]
	BX LR // Return execution context to caller

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
	.word 0x60B2D023 // (1622331427)
	.word 0x2B1E6F8A // (867451303)
	.word 0xD4448D67 // (-733704857)
	.word 0xE285FB4A // (-494535862)
	.word 0x2B1E6F8A // (723414922)
