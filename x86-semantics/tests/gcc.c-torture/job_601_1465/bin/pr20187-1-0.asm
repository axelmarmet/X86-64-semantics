strchr:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	nop
	movq	-8(%rbp), %rax
	movzbl	(%rax), %edx
	movl	-12(%rbp), %eax
	cmpb	%al, %dl
	je	L6
	movq	-8(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	L3
	movl	$0, %eax
	jmp	L1
L3:
	movq	-8(%rbp), %rax
	jmp	L1
L6:
L1:
	popq	%rbp
	ret
exit:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movq $-1, %rax
	jmp %rax
	
	popq	%rbp
	ret
abort:
	pushq	%rbp
	movq	%rsp, %rbp
	movq $-1, %rax
	jmp %rax
	
	popq	%rbp
	ret
a:
	.long	257
b:
	.long	256
test:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	a(%rip), %eax
	testl	%eax, %eax
	je	L10
	movl	a(%rip), %eax
	movl	%eax, %edx
	jmp	L11
L10:
	movl	$1, %edx
L11:
	movl	a(%rip), %eax
	movl	b(%rip), %ecx
	imull	%ecx, %eax
	andl	%edx, %eax
	testb	%al, %al
	sete	%al
	movzbl	%al, %eax
	popq	%rbp
	ret
.globl _start
_start:
	pushq	%rbp
	movq	%rsp, %rbp
	call	test
	movl	$1, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	popq	%rbp
	ret
