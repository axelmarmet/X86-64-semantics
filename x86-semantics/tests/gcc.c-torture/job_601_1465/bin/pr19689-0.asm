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
	.comm	f,4,4
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	movswl	-4(%rbp), %eax
	sall	$3, %eax
	sarl	$3, %eax
	andl	$536870911, %eax
	movl	%eax, %edx
	movl	f(%rip), %eax
	andl	$-536870912, %eax
	orl	%edx, %eax
	movl	%eax, f(%rip)
	popq	%rbp
	ret
.globl _start
_start:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$-55, %edi
	call	foo
	movl	f(%rip), %eax
	andl	$536870911, %eax
	cmpl	$536870857, %eax
	je	L11
	call	abort
L11:
	movl	$0, %eax
	popq	%rbp
	ret
