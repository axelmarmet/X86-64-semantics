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
strlen:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movq	$0, -8(%rbp)
	jmp	L8
L9:
	addq	$1, -8(%rbp)
L8:
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	L9
	movq	-8(%rbp), %rax
	popq	%rbp
	ret
strcpy:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	nop
L12:
	movq	-24(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	movq	-32(%rbp), %rdx
	leaq	1(%rdx), %rcx
	movq	%rcx, -32(%rbp)
	movzbl	(%rdx), %edx
	movb	%dl, (%rax)
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	L12
	movq	-8(%rbp), %rax
	popq	%rbp
	ret
memcmp:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	L15
L18:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	L16
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	jmp	L17
L16:
	addq	$1, -8(%rbp)
	addq	$1, -16(%rbp)
L15:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	L18
	movl	$0, %eax
L17:
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
memset:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	L22
L23:
	movq	-8(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movl	-28(%rbp), %edx
	movb	%dl, (%rax)
L22:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	L23
	movq	-24(%rbp), %rax
	popq	%rbp
	ret
memcpy:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	L26
L27:
	movq	-8(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	-16(%rbp), %rdx
	leaq	1(%rdx), %rcx
	movq	%rcx, -16(%rbp)
	movzbl	(%rdx), %edx
	movb	%dl, (%rax)
L26:
	movq	-40(%rbp), %rax
	leaq	-1(%rax), %rdx
	movq	%rdx, -40(%rbp)
	testq	%rax, %rax
	jne	L27
	movq	-24(%rbp), %rax
	popq	%rbp
	ret
malloc:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movl	$1000, %eax
	popq	%rbp
	ret
free:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	popq	%rbp
	ret
foo:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	-28(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jle	L33
	cmpl	$16, -28(%rbp)
	jg	L33
	jmp	L34
L35:
	sall	-4(%rbp)
L34:
	movl	-28(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jg	L35
L33:
	movl	-4(%rbp), %eax
	popq	%rbp
	ret
.globl _start
_start:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	$1, -12(%rbp)
	jmp	L38
L49:
	leaq	-12(%rbp), %rax
	movl	$16, %esi
	movq	%rax, %rdi
	call	foo
	movl	%eax, -8(%rbp)
	movl	-12(%rbp), %eax
	cmpl	$7, %eax
	jle	L39
	movl	-12(%rbp), %eax
	cmpl	$15, %eax
	jg	L39
	movl	-12(%rbp), %eax
	addl	%eax, %eax
	movl	%eax, -4(%rbp)
	jmp	L40
L39:
	movl	-12(%rbp), %eax
	cmpl	$3, %eax
	jle	L41
	movl	-12(%rbp), %eax
	cmpl	$7, %eax
	jg	L41
	movl	-12(%rbp), %eax
	sall	$2, %eax
	movl	%eax, -4(%rbp)
	jmp	L40
L41:
	movl	-12(%rbp), %eax
	cmpl	$3, %eax
	jne	L42
	movl	$24, -4(%rbp)
	jmp	L40
L42:
	movl	$16, -4(%rbp)
L40:
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	je	L43
	call	abort
L43:
	leaq	-12(%rbp), %rax
	movl	$7, %esi
	movq	%rax, %rdi
	call	foo
	movl	%eax, -8(%rbp)
	movl	-12(%rbp), %eax
	cmpl	$6, %eax
	jle	L44
	movl	-12(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	L45
L44:
	movl	-12(%rbp), %eax
	cmpl	$3, %eax
	jle	L46
	movl	-12(%rbp), %eax
	addl	%eax, %eax
	movl	%eax, -4(%rbp)
	jmp	L45
L46:
	movl	-12(%rbp), %eax
	cmpl	$3, %eax
	jne	L47
	movl	$12, -4(%rbp)
	jmp	L45
L47:
	movl	$8, -4(%rbp)
L45:
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	je	L48
	call	abort
L48:
	movl	-12(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -12(%rbp)
L38:
	movl	-12(%rbp), %eax
	cmpl	$16, %eax
	jle	L49
	movl	$0, %eax
	leave
	ret