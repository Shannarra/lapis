format ELF64 executable

;; section '.text' executable
;;public _start

;;extrn putchar
;;extrn exit

entry _start

;;; Print a number in RDI to stdout
printn:
	mov     r9, -3689348814741910323
	sub     rsp, 40
	mov     BYTE [rsp+31], 10
	lea     rcx, [rsp+30]
.L2:
	mov     rax, rdi
	lea     r8, [rsp+32]
	mul     r9
	mov     rax, rdi
	sub     r8, rcx
	shr     rdx, 3
	lea     rsi, [rdx+rdx*4]
	add     rsi, rsi
	sub     rax, rsi
	add     eax, 48
	mov     BYTE [rcx], al
	mov     rax, rdi
	mov     rdi, rdx
	mov     rdx, rcx
	sub     rcx, 1
	cmp     rax, 9
	ja      .L2
	lea     rax, [rsp+32]
	mov     edi, 1
	sub     rdx, rax
	xor     eax, eax
	lea     rsi, [rsp+32+rdx]
	mov     rdx, r8
	mov     rax, 1
	syscall
	add     rsp, 40
	ret


_start:
	;; mov r8, 2
	;; add r8, 6
	;; mov r9, 3
	;; imul r8, r9

	;; mov rdi, r8
	;; call printn

	 mov r8, 2
	 mov r9, 3
	 imul r8, r9
	 ;; 6
	 mov r9, 4
	 imul r8, r9
	 ;; 24
	 mov r9, 3
	 imul r8, r9
	 ;; 24 * 3
	 mov r9, r8
	 mov r8, 1
	 add r8, r9
	 ;; 73
	 mov r9, 54
	 sub r8, r9
	 mov r8, 8789
	 mov r9, 4
	 div r8
	 mov r8, 19
	 mov r9, 2197
	 add r8, r9

	 mov rdi, r8
	 call printn ;;2216



	mov rax, 60
	mov rdi, 1
	syscall
