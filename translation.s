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

while_loop:

