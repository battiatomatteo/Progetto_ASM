.section .data

numstr:
    .ascii "00"

numstr_ln:
    .long . - numstr

.section .text
    .global scanf

.type scanf, @function  # Dichiaro la funzione atoi per la conversione str2int


scanf:

    # scanf -> lettura numero da tastiera 
	movl $3, %eax
	movl $1, %ebx
    leal numstr, %ecx
    movl numstr_ln, %edx
	int $0x80

atoi:
    leal numstr, %esi

    xorl %eax,%eax            # Azzero registri General Purpose     
    xorl %ebx,%ebx                
    xorl %ecx,%ecx                
    xorl %edx,%edx
    
controllo:
    movb (%esi), %bl  # Carica il byte corrente dalla stringa in %bl
    cmpb $48, %bl
    jl valore_non_valido
    cmpb $50, %bl
    jg valore_non_valido
    movb %bl, %al
    subl $48, %eax
    movb 1(%esi), %bl
    cmpb $10, %bl
    jne valore_non_valido
    ret

valore_non_valido:
    movl $-1,%eax
    ret


