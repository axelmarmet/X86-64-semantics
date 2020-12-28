 .text
.globl _start

_start:
    cmp %eax, %ebx
    je other_label
    or 1, %eax
other_label:
    or 2, %eax 
