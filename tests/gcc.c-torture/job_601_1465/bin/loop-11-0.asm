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
	.local	a
	.comm	a,796,64
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$198, -4(%rbp)
	jmp	L10
L11:
	movl	-4(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movl	%edx, a(,%rax,4)
	subl	$1, -4(%rbp)
L10:
	cmpl	$0, -4(%rbp)
	jns	L11
	popq	%rbp
	ret
.globl _start
_start:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	$0, %eax
	call	foo
	movl	$0, -4(%rbp)
	jmp	L13
L15:
	movl	-4(%rbp), %eax
	cltq
	movl	a(,%rax,4), %eax
	cmpl	-4(%rbp), %eax
	je	L14
	call	abort
L14:
	addl	$1, -4(%rbp)
L13:
	cmpl	$198, -4(%rbp)
	jle	L15
	movl	$0, %eax
	leave
	ret