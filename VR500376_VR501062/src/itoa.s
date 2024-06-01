.section .data

.section .text
    .global itoa

type itoa, @function  # Dichiaro la funzione itoa per la conversione str2int

numstr:
    .ascii "2203\n"

itoa:
    leal numstr, %esi
    movl $0, %ecx          # Azzero il contatore
    movl $0, %ebx          # Azzero il registro EBX

ripeti:
    movb (%ecx,%esi,1), %bl  # Carica il byte corrente dalla stringa in %bl
    cmp $10, %bl             # Confronta con il valore ASCII di '\n'
    je fine_itoa            # Se è '\n', termina la conversione
    subb $48, %bl            # Converti il carattere ASCII della cifra nel valore numerico
    movl $10, %edx
    mulb %dl                 # EBX = EBX * 10
    addl %ebx, %eax          # Aggiungi il valore della cifra a EBX
    inc %ecx                 # Passa al carattere successivo
    jmp ripeti               # Torna all'inizio del ciclo

fine_itoa:
    ret
