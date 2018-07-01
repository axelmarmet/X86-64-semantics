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
func:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jns	L30
	cmpl	$0, -4(%rbp)
	js	L30
	call	abort
L30:
	cmpl	$0, -4(%rbp)
	jle	L31
	cmpl	$0, -4(%rbp)
	jg	L31
	call	abort
L31:
	cmpl	$0, -4(%rbp)
	js	L32
	cmpl	$0, -4(%rbp)
	jns	L32
	call	abort
L32:
	cmpl	$0, -4(%rbp)
	jg	L33
	cmpl	$0, -4(%rbp)
	jle	L33
	call	abort
L33:
	cmpl	$76, -4(%rbp)
	jg	L34
	cmpl	$76, -4(%rbp)
	jle	L34
	call	abort
L34:
	cmpl	$77, -4(%rbp)
	jle	L35
	cmpl	$77, -4(%rbp)
	jg	L35
	call	abort
L35:
	cmpl	$76, -4(%rbp)
	jle	L36
	cmpl	$76, -4(%rbp)
	jg	L36
	call	abort
L36:
	cmpl	$77, -4(%rbp)
	jg	L37
	cmpl	$77, -4(%rbp)
	jle	L37
	call	abort
L37:
	cmpl	$0, -4(%rbp)
	js	L38
	cmpl	$0, -4(%rbp)
	jns	L38
	call	abort
L38:
	cmpl	$0, -4(%rbp)
	jg	L39
	cmpl	$0, -4(%rbp)
	jle	L39
	call	abort
L39:
	cmpl	$0, -4(%rbp)
	jns	L40
	cmpl	$0, -4(%rbp)
	js	L40
	call	abort
L40:
	cmpl	$0, -4(%rbp)
	jle	L41
	cmpl	$0, -4(%rbp)
	jg	L41
	call	abort
L41:
	cmpl	$76, -4(%rbp)
	jle	L42
	cmpl	$76, -4(%rbp)
	jg	L42
	call	abort
L42:
	cmpl	$77, -4(%rbp)
	jg	L43
	cmpl	$77, -4(%rbp)
	jle	L43
	call	abort
L43:
	cmpl	$76, -4(%rbp)
	jg	L44
	cmpl	$76, -4(%rbp)
	jle	L44
	call	abort
L44:
	cmpl	$77, -4(%rbp)
	jle	L45
	cmpl	$77, -4(%rbp)
	jg	L45
	call	abort
L45:
	nop
	leave
	ret
.globl _start
_start:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %edi
	call	func
	movl	$1, %edi
	call	func
	movl	$0, %eax
	popq	%rbp
	ret
