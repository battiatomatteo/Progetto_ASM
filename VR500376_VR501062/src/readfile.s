
.section .data

#.define VETTORE_DIM 100

filename:
    #errore nell'apertura file in un'altra cartella
    .ascii "./src/test.txt"    # Nome del file di testo da leggere
fd:
    .int 0               # File descriptor

buffer: .string ""       # Spazio per il buffer di input
newline: .byte 10        # Valore del simbolo di nuova linea
lines: .int 0            # Numero di linee
indice: .int 0           # variabile per l'indice vettore
indice_2: .int 0           # variabile per l'indice vettore
prec: .int 0
max_i: .int 0
cambiamenti: .int 0
vettore: .byte 100       # Dimensione del vettore (puoi cambiarla)
vettore_2: .byte 100       # Dimensione del vettore (puoi cambiarla)


.section .bss

.section .text
    .global readfile

.type readfile, @function

readfile:
    #movl $0, indice
    jmp _open          # Chiama la funzione per aprire il file

    # Fine programma
    jmp _exit

# Apre il file
_open:
    mov $5, %eax        # syscall open
    mov $filename, %ebx # Nome del file
    mov $0, %ecx        # Modalità di apertura (O_RDONLY)
    int $0x80           # Interruzione del kernel

    
    cmp $0, %eax        # Se ci sta un errore, esce
    jle _exit

    mov %eax, fd      # Salva il file descriptor in eax

# Legge il file riga per riga
_read_loop:
    mov $3, %eax        # syscall read
    mov fd, %ebx        # File descriptor
    mov $buffer, %ecx   # Buffer di input
    mov $1, %edx        # Lunghezza massima
    int $0x80           # Interruzione del kernel

    cmp $0, %eax        # Controllo se ci sono errori o EOF
    # errore ( chiude subito il file )
    jle _close_file     # Se ci sono errori o EOF, chiudo il file
    
    # Controllo se ho una nuova linea
    movb buffer, %al      # Copio il carattere dal buffer ad AL
    cmpb newline, %al     # Confronto AL con il carattere \n
    # jne _print_line     # se sono diversi stampo la linea
    jne _add_to_vector    # Se sono diversi, aggiungi il carattere al vettore
    # incw lines          # altrimenti, incremento il contatore
    incl lines            # Altrimenti, incremento il contatore


_add_to_vector:
    movl indice , %ebx 
    # Aggiungi il carattere al vettore
    movb %al, vettore(%ebx) 
    incl %ebx         # Incrementa l'indice del vettore
    movl %ebx , indice 
    movl %ebx , max_i
    jmp _read_loop      # Torna alla lettura del file


# Chiude il file
_close_file:
    mov $6, %eax        # syscall close
    mov %ebx, %ecx      # File descriptor
    int $0x80           # Interruzione del kernel

    movl $2, indice     # reinizializzo indice a 2 (il primo valore scadena salvato in vettore[2])
    movl indice, %eax          # salvo l'indice in eax
    movl $0, indice 
    movl $0, indice_2 
    movl vettore(%eax), %ebx
    movl %ebx, prec     # salvo il valore precedente nella variabile prec 
    jmp calcolo         # salto a calcolo 

calcolo: 
    # sezione che si occupa del calcolo per trovare l'ordine da stampare 
    # errore 
    addl $4, %eax              # incremento di 4 l'indice per prendere la scadenza sucessiva 

    cmp %eax , max_i             # controllo se ci stanno altre scadenze ,  deve essere (eax<max_i)
    jl  _exit
    # confronto chi dei due è più grande if(vettore[i]>prec) modifico prec se no rimane lo stesso
    movl prec, %ebx
    cmpl vettore(%eax), %ebx   
    jl calcolo_2 

    movl vettore(%eax), %ebx
    movl %ebx, prec    # sposto il vavolre di vettore(%eax) in prec se prec e minore 
    addl $4, indice 

    jmp calcolo 

calcolo_2:
    #scoposto i valori 
    movl %eax, indice_2
    movl %eax, %ebx

    #faccio una copia del primo ordine
    subl $6, %ebx
    movl $0, %ecx
    movl vettore(%ebx), %eax
    movl %eax , vettore_2(%ecx)
    incl %ebx
    incl %ecx
    movl vettore(%ebx), %eax
    movl %eax , vettore_2(%ecx)
    incl %ebx
    incl %ecx
    movl vettore(%ebx), %eax
    movl %eax , vettore_2(%ecx)
    incl %ebx
    incl %ecx
    movl vettore(%ebx), %eax
    movl %eax , vettore_2(%ecx)

    #sposto il secondo ordine al posto del primo
    movl %eax, %ebx
    movl %eax, %ecx
    subl $6, %ebx
    subl $2, %ecx
    movl vettore(%ecx), %eax
    movl %eax , vettore(%ebx)
    incl %ebx
    incl %ecx
    movl vettore(%ecx), %eax
    movl %eax , vettore(%ebx)
    incl %ebx
    incl %ecx
    movl vettore(%ecx), %eax
    movl %eax , vettore(%ebx)
    incl %ebx
    incl %ecx
    movl vettore(%ecx), %eax
    movl %eax , vettore(%ebx)


    #sposto il primo ordine al posto del secondo
    movl %eax, %ebx
    subl $2, %ebx
    movl $0, %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore(%ebx)

    
    movl indice_2,  %eax 
    movl vettore(%eax), %ebx
    movl %ebx, prec    # sposto il vavolre di vettore(%eax) in prec se prec e minore 

    jmp calcolo
    
_exit:

    mov $1, %eax        # syscall exit
    xor %ebx, %ebx      # Codice di uscita 0
    int $0x80           # Interruzione del kernel






