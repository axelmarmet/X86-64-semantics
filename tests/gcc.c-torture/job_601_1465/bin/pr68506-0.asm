    .text
    .globl	strlen
strlen:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	$0, -8(%rbp)
    jmp	L2
L3:
    addq	$1, -8(%rbp)
L2:
    movq	-24(%rbp), %rdx
    movq	-8(%rbp), %rax
    addq	%rdx, %rax
    movzbl	(%rax), %eax
    testb	%al, %al
    jne	L3
    movq	-8(%rbp), %rax
    popq	%rbp
    ret
    .globl	strcpy
strcpy:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	%rsi, -32(%rbp)
    movq	-24(%rbp), %rax
    movq	%rax, -8(%rbp)
    nop
L6:
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
    jne	L6
    movq	-8(%rbp), %rax
    popq	%rbp
    ret
    .globl	strcmp
strcmp:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    movq	%rsi, -16(%rbp)
    jmp	L9
L11:
    addq	$1, -8(%rbp)
    addq	$1, -16(%rbp)
L9:
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    testb	%al, %al
    je	L10
    movq	-8(%rbp), %rax
    movzbl	(%rax), %edx
    movq	-16(%rbp), %rax
    movzbl	(%rax), %eax
    cmpb	%al, %dl
    je	L11
L10:
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    movzbl	%al, %edx
    movq	-16(%rbp), %rax
    movzbl	(%rax), %eax
    movzbl	%al, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    popq	%rbp
    ret
    .globl	strchr
strchr:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    movl	%esi, -12(%rbp)
    jmp	L14
L16:
    movq	-8(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -8(%rbp)
    movzbl	(%rax), %eax
    testb	%al, %al
    jne	L14
    movl	$0, %eax
    jmp	L15
L14:
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    movl	-12(%rbp), %edx
    cmpb	%dl, %al
    jne	L16
    movq	-8(%rbp), %rax
L15:
    popq	%rbp
    ret
    .globl	strncpy
strncpy:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	%rsi, -32(%rbp)
    movq	%rdx, -40(%rbp)
    movq	-24(%rbp), %rax
    movq	%rax, -8(%rbp)
L20:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L18
    movq	-8(%rbp), %rax
    jmp	L19
L18:
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
    jne	L20
    jmp	L21
L22:
    movq	-24(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -24(%rbp)
    movb	$0, (%rax)
L21:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L22
    movq	-8(%rbp), %rax
L19:
    popq	%rbp
    ret
    .globl	strncmp
strncmp:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    movq	%rsi, -16(%rbp)
    movq	%rdx, -24(%rbp)
    jmp	L24
L26:
    movq	-8(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -8(%rbp)
    movzbl	(%rax), %ecx
    movq	-16(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -16(%rbp)
    movzbl	(%rax), %eax
    cmpb	%al, %cl
    je	L24
    movq	-8(%rbp), %rax
    subq	$1, %rax
    movzbl	(%rax), %eax
    movzbl	%al, %edx
    movq	-16(%rbp), %rax
    subq	$1, %rax
    movzbl	(%rax), %eax
    movzbl	%al, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    jmp	L25
L24:
    movq	-24(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -24(%rbp)
    testq	%rax, %rax
    jne	L26
    movl	$0, %eax
L25:
    popq	%rbp
    ret
    .globl	strrchr
strrchr:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movl	%esi, -28(%rbp)
    movq	$0, -8(%rbp)
L29:
    movq	-24(%rbp), %rax
    movzbl	(%rax), %eax
    movl	-28(%rbp), %edx
    cmpb	%dl, %al
    jne	L28
    movq	-24(%rbp), %rax
    movq	%rax, -8(%rbp)
L28:
    movq	-24(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -24(%rbp)
    movzbl	(%rax), %eax
    testb	%al, %al
    jne	L29
    movq	-8(%rbp), %rax
    popq	%rbp
    ret
    .globl	memcmp
memcmp:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	%rsi, -32(%rbp)
    movq	%rdx, -40(%rbp)
    movq	-24(%rbp), %rax
    movq	%rax, -16(%rbp)
    movq	-32(%rbp), %rax
    movq	%rax, -8(%rbp)
    jmp	L32
L35:
    movq	-16(%rbp), %rax
    movzbl	(%rax), %edx
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    cmpb	%al, %dl
    je	L33
    movq	-16(%rbp), %rax
    movzbl	(%rax), %eax
    movzbl	%al, %edx
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    movzbl	%al, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    jmp	L34
L33:
    addq	$1, -16(%rbp)
    addq	$1, -8(%rbp)
L32:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L35
    movl	$0, %eax
L34:
    popq	%rbp
    ret
    .globl	__stack_chk_fail
__stack_chk_fail:
    pushq	%rbp
    movq	%rsp, %rbp
    movq $-1, %rax
    jmp %rax
    
    nop
    popq	%rbp
    ret
    .globl	exit
exit:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	%edi, -4(%rbp)
    movq $-1, %rax
    jmp %rax
    
    nop
    popq	%rbp
    ret
    .globl	abort
abort:
    pushq	%rbp
    movq	%rsp, %rbp
    movq $-1, %rax
    jmp %rax
    
    nop
    popq	%rbp
    ret
    .globl	memset
memset:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movl	%esi, -28(%rbp)
    movq	%rdx, -40(%rbp)
    movq	-24(%rbp), %rax
    movq	%rax, -8(%rbp)
    jmp	L40
L41:
    movq	-8(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -8(%rbp)
    movl	-28(%rbp), %edx
    movb	%dl, (%rax)
L40:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L41
    movq	-24(%rbp), %rax
    popq	%rbp
    ret
    .globl	memcpy
memcpy:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	%rsi, -32(%rbp)
    movq	%rdx, -40(%rbp)
    movq	-24(%rbp), %rax
    movq	%rax, -16(%rbp)
    movq	-32(%rbp), %rax
    movq	%rax, -8(%rbp)
    jmp	L44
L45:
    movq	-16(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -16(%rbp)
    movq	-8(%rbp), %rdx
    leaq	1(%rdx), %rcx
    movq	%rcx, -8(%rbp)
    movzbl	(%rdx), %edx
    movb	%dl, (%rax)
L44:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L45
    movq	-24(%rbp), %rax
    popq	%rbp
    ret
    .globl	free
free:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    nop
    popq	%rbp
    ret
    .globl	isprint
isprint:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	%edi, -4(%rbp)
    cmpl	$96, -4(%rbp)
    jle	L49
    cmpl	$122, -4(%rbp)
    jg	L49
    movl	$1, %eax
    jmp	L50
L49:
    cmpl	$64, -4(%rbp)
    jle	L51
    cmpl	$90, -4(%rbp)
    jg	L51
    movl	$1, %eax
    jmp	L50
L51:
    cmpl	$47, -4(%rbp)
    jle	L52
    cmpl	$57, -4(%rbp)
    jg	L52
    movl	$1, %eax
    jmp	L50
L52:
    movl	$0, %eax
L50:
    popq	%rbp
    ret
    .comm	a,4,4
    .comm	b,4,4
    .comm	m,4,4
    .comm	n,4,4
    .comm	o,4,4
    .comm	p,4,4
    .comm	s,4,4
    .comm	u,4,4
    .comm	i,4,4
    .comm	c,1,1
    .comm	q,1,1
    .comm	y,1,1
    .comm	d,2,2
    .comm	e,1,1
    .comm	f,4,4
    .comm	h,4,4
    .comm	g,2,2
    .comm	r,2,2
    .comm	v,2,2
    .comm	t,4,4
    .globl	fn1
fn1:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	%edi, -4(%rbp)
    movl	a(%rip), %eax
    testl	%eax, %eax
    jne	L54
    movl	a(%rip), %edx
    movl	-4(%rbp), %eax
    addl	%edx, %eax
    jmp	L56
L54:
    movl	-4(%rbp), %eax
L56:
    popq	%rbp
    ret
    .globl	fn2
fn2:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	%edi, %eax
    movl	%esi, -8(%rbp)
    movb	%al, -4(%rbp)
    cmpl	$1, -8(%rbp)
    jg	L58
    movzbl	-4(%rbp), %edx
    movl	-8(%rbp), %eax
    sarx	%eax, %edx, %eax
    jmp	L60
L58:
    movzbl	-4(%rbp), %eax
L60:
    popq	%rbp
    ret
fn3:
    pushq	%rbp
    movq	%rsp, %rbp
    subq	$16, %rsp
    movl	$0, -8(%rbp)
    jmp	L62
L73:
    movzbl	c(%rip), %eax
    movsbl	%al, %edx
    movzbl	c(%rip), %eax
    testb	%al, %al
    setne	%al
    movzbl	%al, %ecx
    movzbl	c(%rip), %eax
    movsbl	%al, %eax
    cmpl	%eax, %ecx
    sete	%al
    movzbl	%al, %eax
    orl	%edx, %eax
    movl	%eax, %edi
    call	fn1
    movl	%eax, s(%rip)
    movl	s(%rip), %eax
    movzbl	%al, %eax
    movl	-8(%rbp), %edx
    movl	%edx, %esi
    movl	%eax, %edi
    call	fn2
    movzbl	%al, %eax
    movl	%eax, t(%rip)
    movzbl	c(%rip), %eax
    movsbl	%al, %edx
    movl	t(%rip), %eax
    movw	%ax, d(%rip)
    movzwl	d(%rip), %eax
    cwtl
    movl	%eax, m(%rip)
    movl	m(%rip), %ecx
    movl	p(%rip), %eax
    cmpl	%eax, %ecx
    sete	%al
    movzbl	%al, %eax
    movl	%eax, o(%rip)
    movl	o(%rip), %eax
    cmpl	$4, %eax
    setbe	%al
    movzbl	%al, %eax
    negl	%eax
    cmpl	%eax, %edx
    jbe	L63
    movl	n(%rip), %eax
    testl	%eax, %eax
    je	L63
    movl	$1, %eax
    jmp	L64
L63:
    movl	$0, %eax
L64:
    movb	%al, c(%rip)
    movzbl	c(%rip), %eax
    cbtw
    negl	%eax
    movw	%ax, v(%rip)
    movb	$1, y(%rip)
    jmp	L65
L66:
    movzwl	v(%rip), %eax
    cmpw	$1, %ax
    sete	%al
    movb	%al, e(%rip)
    movzbl	y(%rip), %eax
    addl	$1, %eax
    movb	%al, y(%rip)
L65:
    movzbl	y(%rip), %eax
    testb	%al, %al
    jne	L66
    movw	$0, d(%rip)
    nop
    movl	h(%rip), %eax
    cmpl	$2, %eax
    je	L72
L71:
    movl	m(%rip), %eax
    testl	%eax, %eax
    jne	L68
    call	abort
L68:
    movl	f(%rip), %eax
    movl	$7, %edx
    subl	%eax, %edx
    movl	%edx, %eax
    movw	%ax, r(%rip)
    movzwl	r(%rip), %eax
    movl	%eax, %edx
    movl	i(%rip), %eax
    orl	%edx, %eax
    movb	%al, e(%rip)
    movzbl	e(%rip), %eax
    movzbl	%al, %eax
    movl	%eax, -8(%rbp)
    movzwl	g(%rip), %eax
    movl	%eax, %ecx
    movl	u(%rip), %eax
    movl	%eax, %edx
    movl	%ecx, %eax
    imull	%edx, %eax
    movb	%al, q(%rip)
    movzbl	q(%rip), %eax
    movsbl	%al, %edx
    movl	b(%rip), %eax
    cmpl	%eax, %edx
    sete	%al
    movzbl	%al, %eax
    movl	%eax, -4(%rbp)
    cmpl	$0, -4(%rbp)
    jne	L76
    jmp	L71
L76:
    nop
    nop
L72:
    movl	p(%rip), %eax
    addl	$1, %eax
    movl	%eax, p(%rip)
L62:
    movl	p(%rip), %eax
    cmpl	$30, %eax
    jle	L73
    movl	-8(%rbp), %eax
    leave
    ret
    .globl	main
.globl _start
_start:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, %eax
    call	fn3
    movl	$0, %eax
    popq	%rbp
    ret
