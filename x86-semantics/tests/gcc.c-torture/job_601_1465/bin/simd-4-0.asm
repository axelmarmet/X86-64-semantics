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
	.comm	s64,8,8
__ev_convert_s64:
	pushq	%rbp
	movq	%rsp, %rbp
	vmovq	%xmm0, -8(%rbp)
	movq	-8(%rbp), %rax
	popq	%rbp
	ret
.globl _start
_start:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$1, -16(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, -4(%rbp)
	movq	LC0(%rip), %rax
	vmovq	%rax, %xmm0
	call	__ev_convert_s64
	movq	%rax, s64(%rip)
	movq	s64(%rip), %rax
	movq	%rax, %rdx
	cmpl	$0, -4(%rbp)
	je	L12
	movabsq	$-4294967295, %rax
	jmp	L13
L12:
	movabsq	$8589934591, %rax
L13:
	cmpq	%rax, %rdx
	je	L14
	call	abort
L14:
	movl	$0, %eax
	leave
	ret
LC0:
	.long	1
	.long	-1