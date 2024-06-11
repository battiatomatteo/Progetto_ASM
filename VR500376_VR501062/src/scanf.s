.section .data

numstr:
    .ascii "0000\n"

numstr_ln:
    .long . - numstr

.section .text
    .global scanf

.type scanf, @function  # Dichiaro la funzione atoi per la conversione str2int


scanf:

    #movl %eax, numstr
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
    
ripeti:
    movb (%ecx,%esi,1), %bl  # Carica il byte corrente dalla stringa in %bl
    cmp $10, %bl             # Confronta con il valore ASCII di '\n'
    je fine_itoa             # Se è '\n', termina la conversione
    subb $48, %bl            # Converti il carattere ASCII della cifra nel valore numerico
    movl $10, %edx
    mulb %dl                 # EBX = EBX * 10
    addl %ebx, %eax          # Aggiungi il valore della cifra a EBX
    inc %ecx                 # Passa al carattere successivo
    jmp ripeti               # Torna all'inizio del ciclo

fine_itoa:
    #fino a qui arriva
    
    # movl $4, %eax
	# movl $1, %ebx
    # leal numstr, %ecx
    # movl numstr_ln, %edx
	# int $0x80

    # movl numstr, %eax

    ret
