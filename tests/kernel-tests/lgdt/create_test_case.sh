#!/bin/bash

as --64 $1.s -o $1.o
ld -melf_x86_64 $1.o -o $1.out
objdump -Msuffix --insn-width=16 -j .text -d $1.out >  $1.dis
