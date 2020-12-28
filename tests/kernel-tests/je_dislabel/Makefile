dis: 
	as --32 je.s -o je.o
	ld -melf_i386 je.o -o je.out
	objdump -Msuffix --insn-width=16 -j .text -d je.out >  je.dis

clean:
	rm *.dis
	rm *.o
	rm *.out