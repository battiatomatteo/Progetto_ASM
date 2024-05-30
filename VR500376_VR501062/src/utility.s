.section .data
# file conversione stringa -> intero

.section .text
    .global print

print:
    movl $4, %eax
	movl $1, %ebx
    leal stampa, %ecx
    movl stampa_ln, %edx
	int $0x80
    