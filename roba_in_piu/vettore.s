.section .data
vettore:
    .byte 5                # Dimensione del vettore (puoi cambiarla)
    valori: .byte 0:5           # Riserva spazio per i valori del vettore

.section .text
.global _start

# Funzione per leggere un valore da tastiera
leggi_valore:
    movl $0, %eax           # Numero di sistema per sys_read
    movl $0, %edi           # File descriptor 0 (stdin)
    leal valori(%esi), %edx # Indirizzo del buffer per la lettura
    movl $1, %ecx           # Numero di byte da leggere (1 byte)
    int $0x80               # Chiamata di sistema

    ret

_start:
    # Leggi i valori da tastiera
    movl $0, %esi           # Inizializza l'indice del vettore
    call leggi_valore       # Leggi il primo valore
    inc %esi                # Incrementa l'indice
    call leggi_valore       # Leggi il secondo valore
    inc %esi                # Incrementa l'indice
    # Continua a leggere gli altri valori se necessario

    # Esempio somma il valore del primo elemento con il secondo elemento
    movb valori(%esi), %al  # Carica il primo elemento in %al
    addb valori+1(%esi), %al # Aggiunge il secondo elemento a %al

    # Ora %al contiene la somma dei primi due elementi del vettore
    # Puoi continuare a eseguire altre operazioni sui dati del vettore

    # Termina il programma
    movl $1, %eax           # Codice di uscita 1
    int $0x80




#vettore
#una singola riga del file ordini occupa 13 byte con un massimo di 10 righe 
#riga =  id(3Byte) + ',' (1Byte) + durata (2Byte) + ',' (1Byte) +  scadenza(3Byte) + ',' (1Byte) + priorità (1Byte) + '\n' (1Byte)      tot 13Byte
#dim tot = riga * 10 = 130Byte

#vettore2
#riga =  id(3Byte) + ',' (1Byte) + durata (2Byte) + ',' (1Byte) +  scadenza(3Byte) + ',' (1Byte) + priorità (1Byte) + '\n' (1Byte)      tot 13Byte

#vettore_int
#riga =  id(4Byte) + durata (4Byte) +  scadenza(4Byte) + priorità (4Byte)     tot 16Byte
#dim tot = riga * 10 = 160Byte

#bisogna dichiararli nel .bss





.section .data
    input: .asciz "1,23,456,7890"
    input_len: . - input
    output: .space input_len * 4

.section .bss
    num: .space 4

.section .text
    .global _start

_start:
    # Set up pointers
    lea input, %esi         # Source index
    lea output, %edi        # Destination index

parse_loop:
    # Initialize current number
    movl $0, %eax

    # Check if end of input string
    cmpb $0, (%esi)
    je done

    # Read each character and build the number
read_char:
    movzbl (%esi), %ecx      # Load the character into ecx
    cmpb $',', %cl           # Check if it's a comma
    je store_number
    subb $'0', %cl           # Convert ASCII to integer
    imull $10, %eax          # Multiply current number by 10
    addl %ecx, %eax          # Add the new digit
    incl %esi                # Move to the next character
    jmp read_char

store_number:
    # Store the parsed number
    movl %eax, (%edi)
    addl $4, %edi            # Move to the next storage position
    incl %esi                # Skip the comma
    jmp parse_loop           # Parse the next number

done:
    # Exit
    movl $1, %eax            # sys_exit system call
    xorl %ebx, %ebx          # Exit code 0
    int $0x80                # Make system call
