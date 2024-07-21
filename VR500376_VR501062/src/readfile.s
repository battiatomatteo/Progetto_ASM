
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
# vettore: .byte 100       # Dimensione del vettore (puoi cambiarla)
# vettore_2: .byte 100       # Dimensione del vettore (puoi cambiarla)
# vettore_int: .int 100       # Dimensione del vettore (puoi cambiarla)


.section .bss
vettore: .space 140       # Dimensione del vettore 
vettore_2: .space 13       # Dimensione del vettore (puoi cambiarla)
vettore_int: .space 200       # Dimensione del vettore (puoi cambiarla)

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

    jmp char_to_int_in
     
in_calcolo:
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
    # addl $4, indice 

    jmp calcolo 

calcolo_2:
    # scoposto i valori 
    movl %eax, indice_2
    movl %eax, %ebx

    #faccio una copia del primo ordine
    subl $6, %ebx
    movl $0, %ecx
    movl vettore_int(%ebx), %eax
    movl %eax , vettore_2(%ecx)
    incl %ebx
    incl %ecx
    movl vettore_int(%ebx), %eax
    movl %eax , vettore_2(%ecx)
    incl %ebx
    incl %ecx
    movl vettore_int(%ebx), %eax
    movl %eax , vettore_2(%ecx)
    incl %ebx
    incl %ecx
    movl vettore_int(%ebx), %eax
    movl %eax , vettore_2(%ecx)

    # sposto il secondo ordine al posto del primo
    movl %eax, %ebx
    movl %eax, %ecx
    subl $6, %ebx
    subl $2, %ecx
    movl vettore_int(%ecx), %eax
    movl %eax , vettore_int(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_int(%ecx), %eax
    movl %eax , vettore_int(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_int(%ecx), %eax
    movl %eax , vettore_int(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_int(%ecx), %eax
    movl %eax , vettore_int(%ebx)


    # sposto il primo ordine al posto del secondo
    movl %eax, %ebx
    subl $2, %ebx
    movl $0, %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore_int(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore_int(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore_int(%ebx)
    incl %ebx
    incl %ecx
    movl vettore_2( %ecx ), %eax
    movl %eax , vettore_int(%ebx)

    
    movl indice_2,  %eax 
    movl vettore(%eax), %ebx
    movl %ebx, prec    # sposto il vavolre di vettore(%eax) in prec se prec e minore 

    jmp calcolo

char_to_int_in:  				

    xorl %eax,%eax			# Azzero registri General Purpose
    xorl %ebx,%ebx           
    xorl %ecx,%ecx           
    xorl %edx,%edx

    leal vettore, %esi         # carico l'indirizzo di vettore nel registro
    leal vettore_int, %edi        # carico l'indirizzo di vettore_int nel registro

    movl $0 ,indice

    jmp char_to_int


char_to_int:

    cmpl %ecx , max_i       # controllo se ci stanno altre scadenze ,  deve essere (eax<max_i)
    jl in_calcolo

    movb (%esi) , %bl
    incl %esi

    cmpb $10, %bl  # controllo se il char è uguale a '\n'
	je fine_campo
	cmpb $44, %bl   # controllo se il char è uguale a ','
	je fine_campo
	cmpb $47, %bl   # controllo se è maggiore di '0'
	jg check 


fine_campo:
    incl %ecx              # incremento l'indice
    movl %eax, (%edi)
    addl $4 , %edi
    xorl %eax, %eax
    
    jmp char_to_int

# mul moltiplica il valore contenuto in eax per quello che gli do come 
# operando e il risultato è contenuto in edx + eax 
valore:
    subl $48, %ebx
    movl $10, %edx
	mul %edx   # crea il numero , lo moltiplica per 10
	addl %ebx, %eax 
    incl %ecx
	jmp char_to_int

check:
	cmpb $57, %bl # controllo se è minore di '9'
	jle valore
    #gestire errore


    
_exit:

    mov $1, %eax        # syscall exit
    xor %ebx, %ebx      # Codice di uscita 0
    int $0x80           # Interruzione del kernel





# aggiornamenti
# ho aggiunto la parte degli array con il .space per creare lo spazio in memoria
# ho sitemato nella parte qua sopra e ho fatto usare esi e esi per gli indirizzi di vettore e di vettore int
# per evitare di continuare a spostare i valori da una parte all'altra

# adesso fa l'array di interi lo fa fatto bene bisogna solo sistemare il fatto che fa una volta in più 
# e di conseguenza l'ultimo numero non lo salva ma almeno adesso non si sovrappongono più




