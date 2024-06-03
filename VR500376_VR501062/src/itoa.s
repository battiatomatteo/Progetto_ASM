.section .data

.section .text
    .global itoa

.type itoa, @function  # Dichiaro la funzione itoa per la conversione str2int

numstr:
    .ascii "2203\n"

numstr_ln:
    .long . - numstr

itoa:
    leal numstr, %esi
    movl $0, %ecx          # Azzero il contatore
    movl $0, %ebx          # Azzero il registro EBX

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

    # Stampa il valore di eax
    movl %esi, %eax
    movl $4, %eax
    movl $1, %ebx
    movl $1, %edx
    int $0x80

    movl $4, %eax
	movl $1, %ebx
    leal numstr, %ecx
    movl numstr_ln, %edx
	int $0x80

    ret
