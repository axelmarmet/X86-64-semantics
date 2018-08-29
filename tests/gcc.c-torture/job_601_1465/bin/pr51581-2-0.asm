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
    .globl	malloc
malloc:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    movl	$1000, %eax
    popq	%rbp
    ret
    .globl	calloc
calloc:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    movq	%rsi, -16(%rbp)
    movl	$1000, %eax
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
    jle	L53
    cmpl	$122, -4(%rbp)
    jg	L53
    movl	$1, %eax
    jmp	L54
L53:
    cmpl	$64, -4(%rbp)
    jle	L55
    cmpl	$90, -4(%rbp)
    jg	L55
    movl	$1, %eax
    jmp	L54
L55:
    cmpl	$47, -4(%rbp)
    jle	L56
    cmpl	$57, -4(%rbp)
    jg	L56
    movl	$1, %eax
    jmp	L54
L56:
    movl	$0, %eax
L54:
    popq	%rbp
    ret
    .comm	a,16384,32
    .comm	c,16384,32
    .comm	b,16384,32
    .comm	d,16384,32
    .globl	f1
f1:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -4(%rbp)
    jmp	L58
L59:
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$1431655766, %edx
    movl	%ecx, %eax
    imull	%edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    movl	%eax, %edx
    addl	%edx, %edx
    addl	%eax, %edx
    movl	%ecx, %eax
    subl	%edx, %eax
    movl	-4(%rbp), %edx
    movslq	%edx, %rdx
    movl	%eax, c(,%rdx,4)
    addl	$1, -4(%rbp)
L58:
    cmpl	$4095, -4(%rbp)
    jle	L59
    nop
    popq	%rbp
    ret
    .globl	f2
f2:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -4(%rbp)
    jmp	L61
L62:
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$-1431655765, %edx
    movl	%ecx, %eax
    mull	%edx
    movl	%edx, %eax
    shrl	%eax
    movl	%eax, %edx
    addl	%edx, %edx
    addl	%eax, %edx
    movl	%ecx, %eax
    subl	%edx, %eax
    movl	-4(%rbp), %edx
    movslq	%edx, %rdx
    movl	%eax, d(,%rdx,4)
    addl	$1, -4(%rbp)
L61:
    cmpl	$4095, -4(%rbp)
    jle	L62
    nop
    popq	%rbp
    ret
    .globl	f3
f3:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -4(%rbp)
    jmp	L64
L65:
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$954437177, %edx
    movl	%ecx, %eax
    imull	%edx
    sarl	$2, %edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    movl	-4(%rbp), %eax
    cltq
    movl	%edx, c(,%rax,4)
    addl	$1, -4(%rbp)
L64:
    cmpl	$4095, -4(%rbp)
    jle	L65
    nop
    popq	%rbp
    ret
    .globl	f4
f4:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -4(%rbp)
    jmp	L67
L68:
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$954437177, %edx
    movl	%ecx, %eax
    mull	%edx
    shrl	$2, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    movl	-4(%rbp), %eax
    cltq
    movl	%edx, d(,%rax,4)
    addl	$1, -4(%rbp)
L67:
    cmpl	$4095, -4(%rbp)
    jle	L68
    nop
    popq	%rbp
    ret
    .globl	f5
f5:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -4(%rbp)
    jmp	L70
L71:
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$1808407283, %edx
    movl	%ecx, %eax
    imull	%edx
    sarl	$3, %edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    movl	-4(%rbp), %eax
    cltq
    movl	%edx, c(,%rax,4)
    addl	$1, -4(%rbp)
L70:
    cmpl	$4095, -4(%rbp)
    jle	L71
    nop
    popq	%rbp
    ret
    .globl	f6
f6:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -4(%rbp)
    jmp	L73
L74:
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$-1356305461, %edx
    movl	%ecx, %eax
    mull	%edx
    movl	%ecx, %eax
    subl	%edx, %eax
    shrl	%eax
    addl	%edx, %eax
    shrl	$4, %eax
    movl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    movl	-4(%rbp), %eax
    cltq
    movl	%edx, d(,%rax,4)
    addl	$1, -4(%rbp)
L73:
    cmpl	$4095, -4(%rbp)
    jle	L74
    nop
    popq	%rbp
    ret
    .globl	f7
f7:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -8(%rbp)
    jmp	L76
L77:
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %eax
    cltq
    imulq	$1431655766, %rax, %rax
    shrq	$32, %rax
    movl	%eax, %edx
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %eax
    shrl	$31, %eax
    addl	%edx, %eax
    movl	%eax, -4(%rbp)
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	-4(%rbp), %edx
    movl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    negl	%eax
    leal	(%rcx,%rax), %edx
    movl	-8(%rbp), %eax
    cltq
    movl	%edx, c(,%rax,4)
    addl	$1, -8(%rbp)
L76:
    cmpl	$4095, -8(%rbp)
    jle	L77
    nop
    popq	%rbp
    ret
    .globl	f8
f8:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -8(%rbp)
    jmp	L79
L80:
    movl	-8(%rbp), %eax
    cltq
    movl	b(,%rax,4), %eax
    movl	%eax, %edx
    movl	$2863311531, %eax
    imulq	%rdx, %rax
    shrq	$32, %rax
    shrl	%eax
    movl	%eax, -4(%rbp)
    movl	-8(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	-4(%rbp), %edx
    movl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    movl	-8(%rbp), %eax
    cltq
    movl	%edx, d(,%rax,4)
    addl	$1, -8(%rbp)
L79:
    cmpl	$4095, -8(%rbp)
    jle	L80
    nop
    popq	%rbp
    ret
    .globl	f9
f9:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -8(%rbp)
    jmp	L82
L83:
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %eax
    cltq
    imulq	$954437177, %rax, %rax
    shrq	$32, %rax
    sarl	$2, %eax
    movl	%eax, %edx
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %eax
    shrl	$31, %eax
    addl	%edx, %eax
    movl	%eax, -4(%rbp)
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	-4(%rbp), %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    negl	%eax
    leal	(%rcx,%rax), %edx
    movl	-8(%rbp), %eax
    cltq
    movl	%edx, c(,%rax,4)
    addl	$1, -8(%rbp)
L82:
    cmpl	$4095, -8(%rbp)
    jle	L83
    nop
    popq	%rbp
    ret
    .globl	f10
f10:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -8(%rbp)
    jmp	L85
L86:
    movl	-8(%rbp), %eax
    cltq
    movl	b(,%rax,4), %eax
    movl	%eax, %eax
    imulq	$954437177, %rax, %rax
    shrq	$32, %rax
    shrl	$2, %eax
    movl	%eax, -4(%rbp)
    movl	-8(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	-4(%rbp), %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    movl	-8(%rbp), %eax
    cltq
    movl	%edx, d(,%rax,4)
    addl	$1, -8(%rbp)
L85:
    cmpl	$4095, -8(%rbp)
    jle	L86
    nop
    popq	%rbp
    ret
    .globl	f11
f11:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -8(%rbp)
    jmp	L88
L89:
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %eax
    cltq
    imulq	$1808407283, %rax, %rax
    shrq	$32, %rax
    sarl	$3, %eax
    movl	%eax, %edx
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %eax
    shrl	$31, %eax
    addl	%edx, %eax
    movl	%eax, -4(%rbp)
    movl	-8(%rbp), %eax
    cltq
    movl	a(,%rax,4), %edx
    movl	-4(%rbp), %eax
    imull	$-19, %eax, %eax
    addl	%eax, %edx
    movl	-8(%rbp), %eax
    cltq
    movl	%edx, c(,%rax,4)
    addl	$1, -8(%rbp)
L88:
    cmpl	$4095, -8(%rbp)
    jle	L89
    nop
    popq	%rbp
    ret
    .globl	f12
f12:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$0, -12(%rbp)
    jmp	L91
L92:
    movl	-12(%rbp), %eax
    cltq
    movl	b(,%rax,4), %eax
    movl	%eax, %edx
    movl	$2938661835, %eax
    imulq	%rdx, %rax
    shrq	$32, %rax
    movl	%eax, -8(%rbp)
    movl	-12(%rbp), %eax
    cltq
    movl	b(,%rax,4), %eax
    subl	-8(%rbp), %eax
    shrl	%eax
    movl	%eax, %edx
    movl	-8(%rbp), %eax
    addl	%edx, %eax
    shrl	$4, %eax
    movl	%eax, -4(%rbp)
    movl	-12(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	-4(%rbp), %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    movl	-12(%rbp), %eax
    cltq
    movl	%edx, d(,%rax,4)
    addl	$1, -12(%rbp)
L91:
    cmpl	$4095, -12(%rbp)
    jle	L92
    nop
    popq	%rbp
    ret
    .globl	main
.globl _start
_start:
    pushq	%rbp
    movq	%rsp, %rbp
    subq	$16, %rsp
    movl	$0, -4(%rbp)
    jmp	L94
L95:
    movl	-4(%rbp), %eax
    leal	-2048(%rax), %edx
    movl	-4(%rbp), %eax
    cltq
    movl	%edx, a(,%rax,4)
    movl	-4(%rbp), %edx
    movl	-4(%rbp), %eax
    cltq
    movl	%edx, b(,%rax,4)
    addl	$1, -4(%rbp)
L94:
    cmpl	$4095, -4(%rbp)
    jle	L95
    movl	$-2147483648, a(%rip)
    movl	$-2147483647, a + 4(%rip)
    movl	$2147483647, a + 16380(%rip)
    movl	$-1, b + 16380(%rip)
    call	f1
    call	f2
    movl	$0, -4(%rbp)
    jmp	L96
L99:
    movl	-4(%rbp), %eax
    cltq
    movl	c(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$1431655766, %edx
    movl	%ecx, %eax
    imull	%edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    jne	L97
    movl	-4(%rbp), %eax
    cltq
    movl	d(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$-1431655765, %edx
    movl	%ecx, %eax
    mull	%edx
    shrl	%edx
    movl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    je	L98
L97:
    call	abort
L98:
    addl	$1, -4(%rbp)
L96:
    cmpl	$4095, -4(%rbp)
    jle	L99
    call	f3
    call	f4
    movl	$0, -4(%rbp)
    jmp	L100
L103:
    movl	-4(%rbp), %eax
    cltq
    movl	c(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$954437177, %edx
    movl	%ecx, %eax
    imull	%edx
    sarl	$2, %edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    jne	L101
    movl	-4(%rbp), %eax
    cltq
    movl	d(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$954437177, %edx
    movl	%ecx, %eax
    mull	%edx
    shrl	$2, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    je	L102
L101:
    call	abort
L102:
    addl	$1, -4(%rbp)
L100:
    cmpl	$4095, -4(%rbp)
    jle	L103
    call	f5
    call	f6
    movl	$0, -4(%rbp)
    jmp	L104
L107:
    movl	-4(%rbp), %eax
    cltq
    movl	c(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$1808407283, %edx
    movl	%ecx, %eax
    imull	%edx
    sarl	$3, %edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    jne	L105
    movl	-4(%rbp), %eax
    cltq
    movl	d(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$-1356305461, %edx
    movl	%ecx, %eax
    mull	%edx
    movl	%ecx, %eax
    subl	%edx, %eax
    shrl	%eax
    addl	%edx, %eax
    shrl	$4, %eax
    movl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    je	L106
L105:
    call	abort
L106:
    addl	$1, -4(%rbp)
L104:
    cmpl	$4095, -4(%rbp)
    jle	L107
    call	f7
    call	f8
    movl	$0, -4(%rbp)
    jmp	L108
L111:
    movl	-4(%rbp), %eax
    cltq
    movl	c(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$1431655766, %edx
    movl	%ecx, %eax
    imull	%edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    jne	L109
    movl	-4(%rbp), %eax
    cltq
    movl	d(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$-1431655765, %edx
    movl	%ecx, %eax
    mull	%edx
    shrl	%edx
    movl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    je	L110
L109:
    call	abort
L110:
    addl	$1, -4(%rbp)
L108:
    cmpl	$4095, -4(%rbp)
    jle	L111
    call	f9
    call	f10
    movl	$0, -4(%rbp)
    jmp	L112
L115:
    movl	-4(%rbp), %eax
    cltq
    movl	c(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$954437177, %edx
    movl	%ecx, %eax
    imull	%edx
    sarl	$2, %edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    jne	L113
    movl	-4(%rbp), %eax
    cltq
    movl	d(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$954437177, %edx
    movl	%ecx, %eax
    mull	%edx
    shrl	$2, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    je	L114
L113:
    call	abort
L114:
    addl	$1, -4(%rbp)
L112:
    cmpl	$4095, -4(%rbp)
    jle	L115
    call	f11
    call	f12
    movl	$0, -4(%rbp)
    jmp	L116
L119:
    movl	-4(%rbp), %eax
    cltq
    movl	c(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	a(,%rax,4), %ecx
    movl	$1808407283, %edx
    movl	%ecx, %eax
    imull	%edx
    sarl	$3, %edx
    movl	%ecx, %eax
    sarl	$31, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    jne	L117
    movl	-4(%rbp), %eax
    cltq
    movl	d(,%rax,4), %esi
    movl	-4(%rbp), %eax
    cltq
    movl	b(,%rax,4), %ecx
    movl	$-1356305461, %edx
    movl	%ecx, %eax
    mull	%edx
    movl	%ecx, %eax
    subl	%edx, %eax
    shrl	%eax
    addl	%edx, %eax
    shrl	$4, %eax
    movl	%eax, %edx
    movl	%edx, %eax
    sall	$3, %eax
    addl	%edx, %eax
    addl	%eax, %eax
    addl	%edx, %eax
    subl	%eax, %ecx
    movl	%ecx, %edx
    cmpl	%edx, %esi
    je	L118
L117:
    call	abort
L118:
    addl	$1, -4(%rbp)
L116:
    cmpl	$4095, -4(%rbp)
    jle	L119
    movl	$0, %eax
    leave
    ret
