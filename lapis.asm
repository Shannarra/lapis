  format ELF64

section '.text' executable
public _start

extrn putchar
extrn exit

_start:

  
          mov rdi, 0
        call exit

