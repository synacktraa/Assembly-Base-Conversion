STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60


section .data
	
section .bss
	revbin resb 100
	revbinaddr resb 8

section .text
	global _start

%macro sys_exit 0 
      mov rax, SYS_EXIT
      mov rdi, 0
      syscall
%endmacro

%macro printf 2
   mov rax, SYS_WRITE
   mov rdi, STDOUT
   mov rsi, %1
   mov rdx, %2
   syscall
%endmacro
	
_start:
	mov rax, 255
	call _storeCurAddr

	sys_exit

_storeCurAddr:
	mov rcx, revbin
	mov rbx, 0xA
	mov [rcx], rbx
	inc rcx
	mov [revbinaddr], rcx

_carveRevBinLoop:
	xor rdx, rdx
	mov rbx, 2
	div rbx
	push rax
	add rdx, 0x30
	
	mov rcx, [revbinaddr]
	mov [rcx], dl
	inc rcx
	mov [revbinaddr], rcx

	pop rax
	cmp rax, 0
	jne _carveRevBinLoop

_printBinaryLoop:
	mov rcx, [revbinaddr]
	
	printf rcx, 1
	
	mov rcx, [revbinaddr]
	dec rcx
	mov [revbinaddr], rcx

	cmp rcx, revbin
	jge _printBinaryLoop
	ret 
	
		