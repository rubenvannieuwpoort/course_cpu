    .section .text,"ax",@progbits
    .global _start
    .type _start, @function

_start:
    call main
    .p2align 2
    .word 0x0000006f
