 .text
.globl _start

_start:
    movl $0xC0000080, %ecx
    rdmsr
    or 1 << 8, %eax
    or 1 << 8, %edx
    wrmsr
    movl $0, %eax
    movl $0, %edx
    rdmsr


