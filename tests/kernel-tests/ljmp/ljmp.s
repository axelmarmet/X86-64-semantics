global _start
extern main
extern nfos_halt

section .text.32
BITS 32
_start:
    lgdt [gdt64.descriptor]
    jmp gdt64.code_segment:other_label
    or eax, 1
other_label:
    or eax, 2

BITS 64
section .rodata

; Global descriptor table for 64-bit mode
; Volume 3 - 3.5.1: Segment Descriptor Tables
gdt64:
    ; The first descriptor is never used so it can be 0
    dq 0

.code_segment: equ $ - gdt64
    ; Volume 3 - 5.2.1 Code-Segment Descriptor in 64-bit Mode

    ; Most fields are ignored in 64-bit mode so they can be 0

    ; CS.P (bit 47): descriptor present
    ; CS.S (bit 44): regular code/data (as opposed to system) segment
    ; Type (bit 43): this is a code segment
    ; CS.L (bit 53): this is a 64-bit mode code segment
    dq (1<<47) | (1<<44) | (1<<43) | (1<<53)

.descriptor:
    ; GDT descriptor
    dw $ - gdt64 - 1
    dq gdt64


