dis: 
	nasm  -felf64 lgdt.s -o lgdt.o
	ld -melf_x86_64  lgdt.o -o lgdt.out
	objdump -Msuffix --insn-width=16 -j .text -d lgdt.out >  lgdt.dis
	objdump -j .rodata -s lgdt.out >> lgdt.dis 

clean:
	rm *.dis
	rm *.o
	rm *.out