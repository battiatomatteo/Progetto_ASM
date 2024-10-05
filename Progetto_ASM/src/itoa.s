# filename: num2str.s
#
# converts an integer into a string

.section .data

	numtmp: .ascii "000"     # temporary string


.section .text
	.global int_to_str
.type int_to_str, @function
int_to_str:

	pushl %ebx
    pushl %ecx
	pushl %edi

	movl $10, %ebx             # carica 10 in EBX (usato per le divisioni)
	movl $0, %ecx              # azzera il contatore ECX

	leal numtmp, %edi          # carica l'indirizzo di 'numtmp' in ESI


continua_a_dividere:

	movl $0, %edx              # azzera il contenuto di EDX
	divl %ebx                  # divide per 10 il numero ottenuto

	addb $48, %dl              # aggiunge 48 al resto della divisione
	movb %dl, (%ecx,%edi,1)    # sposta il contenuto di DL in numtmp

	inc %ecx                   # incrementa il contatore ECX

	cmp $0, %eax               # controlla se il contenuto di EAX è 0

	jne continua_a_dividere


	movl $0, %ebx              # azzera un secondo contatore in EBX


ribalta:

	movb -1(%ecx,%edi,1), %al  # carica in AL il contenuto dell'ultimo byte di 'numtmp'
	movb %al, (%ebx,%esi,1)    # carica nel primo byte di 'intstr' il contenuto di AL

	inc %ebx                   # incrementa il contatore EBX

	loop ribalta


fine:
	movl %ebx , %edx
	
	popl %edi
    popl %ecx
    popl %ebx
    ret
