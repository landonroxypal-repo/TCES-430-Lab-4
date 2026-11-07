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

MOV R0, #1
MOV R1, #0
MOV R2, #-1

while_loop:

