dis: 
	nasm  -felf64 ljmp.s -o ljmp.o
	ld -melf_x86_64  ljmp.o -o ljmp.out
	objcopy -O elf32-i386 --only-section=.text ljmp.out ljmp.out2
	objdump -Msuffix --insn-width=16 -j .text -d ljmp.out2 >  ljmp.dis
	objdump -j .rodata -s ljmp.out >> ljmp.dis 

clean:
	rm *.dis
	rm *.o
	rm *.out