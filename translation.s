.syntax unified
.cpu cortex-m7
.thumb

.section .text
.global translation
.align 2
.thumb_func

translation:
	// 1. Enable peripheral clock gate for Port I
