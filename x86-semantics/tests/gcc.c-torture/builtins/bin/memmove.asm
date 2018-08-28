    .text
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
    jmp	L2
L5:
    movq	-16(%rbp), %rax
    movzbl	(%rax), %edx
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    cmpb	%al, %dl
    je	L3
    movq	-16(%rbp), %rax
    movzbl	(%rax), %eax
    movzbl	%al, %edx
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    movzbl	%al, %eax
    subl	%eax, %edx
    movl	%edx, %eax
    jmp	L4
L3:
    addq	$1, -16(%rbp)
    addq	$1, -8(%rbp)
L2:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L5
    movl	$0, %eax
L4:
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
    jmp	L9
L10:
    movq	-8(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -8(%rbp)
    movl	-28(%rbp), %edx
    movb	%dl, (%rax)
L9:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L10
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
    jmp	L13
L14:
    movq	-16(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -16(%rbp)
    movq	-8(%rbp), %rdx
    leaq	1(%rdx), %rcx
    movq	%rcx, -8(%rbp)
    movzbl	(%rdx), %edx
    movb	%dl, (%rax)
L13:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L14
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
    jle	L22
    cmpl	$122, -4(%rbp)
    jg	L22
    movl	$1, %eax
    jmp	L23
L22:
    cmpl	$64, -4(%rbp)
    jle	L24
    cmpl	$90, -4(%rbp)
    jg	L24
    movl	$1, %eax
    jmp	L23
L24:
    cmpl	$47, -4(%rbp)
    jle	L25
    cmpl	$57, -4(%rbp)
    jg	L25
    movl	$1, %eax
    jmp	L23
L25:
    movl	$0, %eax
L23:
    popq	%rbp
    ret
    .globl	strchr
strchr:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    movl	%esi, -12(%rbp)
    nop
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    movl	-12(%rbp), %edx
    cmpb	%dl, %al
    je	L31
    movq	-8(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -8(%rbp)
    movzbl	(%rax), %eax
    testb	%al, %al
    jne	L28
    movl	$0, %eax
    jmp	L26
L28:
    movq	-8(%rbp), %rax
    jmp	L26
L31:
L26:
    popq	%rbp
    ret
    .globl	strlen
strlen:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	$0, -8(%rbp)
    jmp	L33
L34:
    addq	$1, -8(%rbp)
L33:
    movq	-24(%rbp), %rdx
    movq	-8(%rbp), %rax
    addq	%rdx, %rax
    movzbl	(%rax), %eax
    testb	%al, %al
    jne	L34
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
L37:
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
    jne	L37
    movq	-8(%rbp), %rax
    popq	%rbp
    ret
    .globl	strcmp
strcmp:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -8(%rbp)
    movq	%rsi, -16(%rbp)
    jmp	L40
L42:
    addq	$1, -8(%rbp)
    addq	$1, -16(%rbp)
L40:
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    testb	%al, %al
    je	L41
    movq	-8(%rbp), %rax
    movzbl	(%rax), %edx
    movq	-16(%rbp), %rax
    movzbl	(%rax), %eax
    cmpb	%al, %dl
    je	L42
L41:
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
    .globl	strcat
strcat:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	%rsi, -32(%rbp)
    movq	-24(%rbp), %rax
    movq	%rax, -8(%rbp)
    jmp	L45
L46:
    addq	$1, -8(%rbp)
L45:
    movq	-8(%rbp), %rax
    movzbl	(%rax), %eax
    testb	%al, %al
    jne	L46
    nop
L47:
    movq	-8(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -8(%rbp)
    movq	-32(%rbp), %rdx
    leaq	1(%rdx), %rcx
    movq	%rcx, -32(%rbp)
    movzbl	(%rdx), %edx
    movb	%dl, (%rax)
    movzbl	(%rax), %eax
    testb	%al, %al
    jne	L47
    movq	-24(%rbp), %rax
    popq	%rbp
    ret
    .globl	memmove
memmove:
    pushq	%rbp
    movq	%rsp, %rbp
    movq	%rdi, -24(%rbp)
    movq	%rsi, -32(%rbp)
    movq	%rdx, -40(%rbp)
    movq	-32(%rbp), %rax
    movq	%rax, -8(%rbp)
    movq	-24(%rbp), %rax
    movq	%rax, -16(%rbp)
    movq	-8(%rbp), %rax
    cmpq	-16(%rbp), %rax
    jnb	L54
    jmp	L51
L52:
    movq	-16(%rbp), %rdx
    movq	-40(%rbp), %rax
    addq	%rax, %rdx
    movq	-8(%rbp), %rcx
    movq	-40(%rbp), %rax
    addq	%rcx, %rax
    movzbl	(%rax), %eax
    movb	%al, (%rdx)
L51:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L52
    jmp	L53
L55:
    movq	-16(%rbp), %rax
    leaq	1(%rax), %rdx
    movq	%rdx, -16(%rbp)
    movq	-8(%rbp), %rdx
    leaq	1(%rdx), %rcx
    movq	%rcx, -8(%rbp)
    movzbl	(%rdx), %edx
    movb	%dl, (%rax)
L54:
    movq	-40(%rbp), %rax
    leaq	-1(%rax), %rdx
    movq	%rdx, -40(%rbp)
    testq	%rax, %rax
    jne	L55
L53:
    movq	-24(%rbp), %rax
    popq	%rbp
    ret
    .globl	bcopy
bcopy:
    pushq	%rbp
    movq	%rsp, %rbp
    subq	$24, %rsp
    movq	%rdi, -8(%rbp)
    movq	%rsi, -16(%rbp)
    movq	%rdx, -24(%rbp)
    movq	-24(%rbp), %rdx
    movq	-8(%rbp), %rcx
    movq	-16(%rbp), %rax
    movq	%rcx, %rsi
    movq	%rax, %rdi
    call	memmove
    nop
    leave
    ret
    .comm	inside_main,4,4
    .globl	main
.globl _start
_start:
    pushq	%rbp
    movq	%rsp, %rbp
    movl	$1, $inside_main(%rip)
    call	main_test
    movl	$0, $inside_main(%rip)
    movl	$0, %eax
    popq	%rbp
    ret
    .globl	link_error
link_error:
    pushq	%rbp
    movq	%rsp, %rbp
    call	abort
    .globl	s1
    .section	.rodata
s1:
    .string	"123"
    .globl	p
    .bss
p:
    .zero	32
    .section	.rodata
LC0:
    .string	"hello world1"
LC1:
    .string	"hello world2"
LC2:
    .string	"hello world3"
LC3:
    .string	"hello world4"
LC4:
    .string	"hello world5"
LC5:
    .string	"hello world6"
foo:
    .quad	LC0
    .long	4028335726
    .long	1074340345
    .quad	101
    .quad	LC1
    .long	4028335726
    .long	1074340345
    .quad	102
    .quad	LC2
    .long	4028335726
    .long	1074340345
    .quad	103
    .quad	LC3
    .long	4028335726
    .long	1074340345
    .quad	104
    .quad	LC4
    .long	4028335726
    .long	1074340345
    .quad	105
    .quad	LC5
    .long	4028335726
    .long	1074340345
    .quad	106
LC6:
    .string	"hello world10"
LC7:
    .string	"hello1"
LC8:
    .string	"hello2"
LC9:
    .string	"hello3"
LC10:
    .string	"hello world11"
LC11:
    .string	"hello4"
LC12:
    .string	"hello5"
LC13:
    .string	"hello6"
bar:
    .quad	LC6
    .quad	LC7
    .long	4028335726
    .long	1074340345
    .quad	201
    .quad	LC8
    .long	4028335726
    .long	1074340345
    .quad	202
    .quad	LC9
    .long	4028335726
    .long	1074340345
    .quad	203
    .quad	LC10
    .quad	LC11
    .long	4028335726
    .long	1074340345
    .quad	204
    .quad	LC12
    .long	4028335726
    .long	1074340345
    .quad	205
    .quad	LC13
    .long	4028335726
    .long	1074340345
    .quad	206
baz:
    .long	1
    .long	2
    .long	3
    .long	4
    .long	5
    .long	6
    .long	7
    .long	8
    .long	9
    .long	0
LC14:
    .string	"abcde"
LC15:
    .string	"abc"
    .string	"e"
LC16:
    .string	"abfghi"
LC17:
    .string	"abfgAi"
    .text
    .globl	main_test
main_test:
    pushq	%rbp
    movq	%rsp, %rbp
    subq	$384, %rsp
    movq	$40, %rax
    movq	%rax, -8(%rbp)
    xorl	%eax, %eax
    leaq	-320(%rbp), %rax
    movl	$foo, %ecx
    movl	$144, %edx
    movq	%rcx, %rsi
    movq	%rax, %rdi
    call	memcpy
    leaq	-320(%rbp), %rdx
    leaq	-320(%rbp), %rax
    cmpq	%rax, %rdx
    jne	L62
    leaq	-320(%rbp), %rax
    movl	$144, %edx
    movl	$foo, %esi
    movq	%rax, %rdi
    call	memcmp
    testl	%eax, %eax
    je	L63
L62:
    call	abort
L63:
    leaq	-176(%rbp), %rax
    movl	$bar, %ecx
    movl	$160, %edx
    movq	%rcx, %rsi
    movq	%rax, %rdi
    call	memcpy
    leaq	-176(%rbp), %rdx
    leaq	-176(%rbp), %rax
    cmpq	%rax, %rdx
    jne	L64
    leaq	-176(%rbp), %rax
    movl	$160, %edx
    movl	$bar, %esi
    movq	%rax, %rdi
    call	memcmp
    testl	%eax, %eax
    je	L65
L64:
    call	abort
L65:
    movq $baz(%rip), %rax
    movq	%rax, -368(%rbp)
    movq $baz + 8(%rip), %rax
    movq	%rax, -360(%rbp)
    movq $baz + 16(%rip), %rax
    movq	%rax, -352(%rbp)
    movq $baz + 24(%rip), %rax
    movq	%rax, -344(%rbp)
    movq $baz + 32(%rip), %rax
    movq	%rax, -336(%rbp)
    leaq	-368(%rbp), %rax
    movl	$40, %edx
    movl	$baz, %esi
    movq	%rax, %rdi
    call	memcmp
    testl	%eax, %eax
    je	L66
    call	abort
L66:
    movl	$1684234849, $p(%rip)
    movw	$101, $p + 4(%rip)
    movl	$p, %eax
    cmpq	$p, %rax
    jne	L67
    movl	$6, %edx
    movl	$LC14, %esi
    movl	$p, %edi
    call	memcmp
    testl	%eax, %eax
    je	L68
L67:
    call	abort
L68:
    movq	$s1, -376(%rbp)
    addq	$1, -376(%rbp)
    movl	$p + 2, %edx
    movl	$p + 2, %eax
    cmpq	%rax, %rdx
    jne	L69
    movl	$6, %edx
    movl	$LC14, %esi
    movl	$p, %edi
    call	memcmp
    testl	%eax, %eax
    jne	L69
    movl	$s1 + 1, %eax
    cmpq	%rax, -376(%rbp)
    je	L70
L69:
    call	abort
L70:
    movl	$p + 3, %eax
    movb	$0, (%rax)
    movq	%rax, %rdx
    movl	$p + 3, %eax
    cmpq	%rax, %rdx
    jne	L71
    movl	$6, %edx
    movl	$LC15, %esi
    movl	$p, %edi
    call	memcmp
    testl	%eax, %eax
    je	L72
L71:
    call	abort
L72:
    movl	$p + 2, %eax
    movl	$1768449894, (%rax)
    movl	$7, %edx
    movl	$LC16, %esi
    movl	$p, %edi
    call	memcmp
    testl	%eax, %eax
    je	L73
    call	abort
L73:
    movq	$s1 + 1, -376(%rbp)
    movq	-376(%rbp), %rax
    addq	$1, %rax
    movq	%rax, -376(%rbp)
    movl	$7, %edx
    movl	$LC16, %esi
    movl	$p, %edi
    call	memcmp
    testl	%eax, %eax
    jne	L74
    movl	$s1 + 2, %eax
    cmpq	%rax, -376(%rbp)
    je	L75
L74:
    call	abort
L75:
    movl	$p + 4, %eax
    movb	$65, (%rax)
    movl	$7, %edx
    movl	$LC17, %esi
    movl	$p, %edi
    call	memcmp
    testl	%eax, %eax
    je	L78
    call	abort
L78:
    nop
    movq	-8(%rbp), %rax
    xorq	$40, %rax
    je	L77
    call	__stack_chk_fail
L77:
    leave
    ret