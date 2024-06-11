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

    # Esempio: somma il valore del primo elemento con il secondo elemento
    movb valori(%esi), %al  # Carica il primo elemento in %al
    addb valori+1(%esi), %al # Aggiunge il secondo elemento a %al

    # Ora %al contiene la somma dei primi due elementi del vettore
    # Puoi continuare a eseguire altre operazioni sui dati del vettore

    # Termina il programma
    movl $1, %eax           # Codice di uscita 1
    int $0x80
