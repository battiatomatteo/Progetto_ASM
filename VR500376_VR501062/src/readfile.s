.section .data

# variabile testo che contiene un messaggio di errore da mostrare nel caso non sia presente il prescorso file
few_argument_str:
	.ascii "Non hai inserito il percordo del file da leggere\n"
 
few_argument_str_len:
	.long . - few_argument_str     # lunghezza della stringa few_argument_str

# variabile testo che contiene un messaggio di errore da mostrare nel caso in cui ci siano stati dati troppi parametri
too_argument_str:
	.ascii "Controllare il percorso file inserito \n"
 
too_argument_str_len:
	.long . - too_argument_str     # lunghezza della stringa too_argument_str

# variabile testo che contiene un messaggio di errore da mostrare nel caso in cui problemi di apertura del file
error_open_str:
	.ascii "errore nell\'apertura del file \n"
 
error_open_str_len:
	.long . - error_open_str     # lunghezza della stringa error_open_str

fd: 
  .int 0               # File descriptor

buffer: .string ""       # Spazio per il buffer di input
max_i: .int 0            # variabile che indica il numero di caratteri presenti in vettore

.section .bss
vettore: .space 140       # Dimensione del vettore che contiene tutti gli ordini del file da leggere
filename: .string ""  # nome del percorso del file

# rendo visibile al di fuori del file la funzione principale readfile e le variabili vettore e max_i
.section .text
  .global readfile
  .global	vettore
  .global	max_i

# dichiaro read file come una funzione
.type readfile, @function

readfile:
  #mettere in ebx l'indirizzo della stringa con il nome del file
  jmp load_file


load_file:
  # recupero i parametri del programma e controllo che ne sia stato inserito solo 1

  cmpl	$2, %eax        # recupero il numero di parametri dati al programma (devo essere 2 nome del programma e percorso del file)
  jl		few_argument    # controllo se eax vale 1 (non mi è stato dato il percorso del file)
  jg		too_argument    # controllo se eax > 2 (mi sono stati dati altri paramtri che non mi servono)

  movl %ebx, filename   # metto il percorso file nella variabile filename

  jmp _open          # Chiama la funzione per aprire il file


few_argument:
  # stampa del messaggio di errore contenuto in few_argument_str

  movl $4, %eax                     # scelgo il tipo di SysCall (4 -> write)
  movl $1, %ebx                     # scelgo dove effettuare la SysCall (1 -> standard output)
  leal few_argument_str, %ecx       # scelgo che cosa stampare (stampo il valore contenuto all'indizzo di few_argument_str )
  movl few_argument_str_len, %edx   # dico quanti caratteri devo stampare
  int $0x80                         # effettuo la SysCall

  jmp end   # salto all'etichetta end

too_argument:
# stampa del messaggio di errore contenuto in too_argument_str

  movl $4, %eax                     # scelgo il tipo di SysCall (4 -> write)
  movl $1, %ebx                     # scelgo dove effettuare la SysCall (1 -> standard output)
  leal too_argument_str, %ecx       # scelgo che cosa stampare (stampo il valore contenuto all'indizzo di too_argument_str )
  movl too_argument_str_len, %edx   # dico quanti caratteri devo stampare
  int $0x80                         # effettuo la SysCall

  jmp end   # salto all'etichetta end

end:
  movl $1, %eax         # scelgo il tipo di SysCall (1 -> exit)
	xorl %ebx, %ebx     # scelgo il tipo di esito (0 -> No Error)
	int $0x80           # effettuo la SysCall



# Apre il file
_open:
# apro il file e gestisco il relativo errore
  movl $5, %eax        # scelgo il tipo di SysCall (5 -> open)
                       # ebx non serve metterlo perche' contiene gia' il percorso del file
  movl $0, %ecx        # Modalita' di apertura (O_RDONLY)
  int $0x80            # effettuo la SysCall

  
  cmp $0, %eax         # cotrollo se ci sono errori
  jle error_open       # in caso di errore salto a error_open

  mov %eax, fd      # Salva il file descriptor in eax

# Legge il file riga per riga
_read_loop:
  mov $3, %eax        # syscall read
  mov fd, %ebx        # File descriptor
  mov $buffer, %ecx   # Buffer di input
  mov $1, %edx        # Lunghezza massima
  int $0x80           # Interruzione del kernel

  cmp $0, %eax        # Controllo se ci sono errori o EOF
  jle _close_file     # Se ci sono errori o EOF, chiudo il file
  
  # Controllo se ho una nuova linea
  movb buffer, %al      # Copio il carattere dal buffer ad AL
  cmpb $10, %al     # Confronto AL con il carattere \n
  jne _add_to_vector    # Se sono diversi, aggiungi il carattere al vettore


_add_to_vector:
  movl max_i , %ebx 
  # Aggiungi il carattere al vettore
  movb %al, vettore(%ebx) 
  incl %ebx         # Incrementa l'indice del vettore
  movl %ebx , max_i # aggiorno la nuova dimensione massima del vettore
  jmp _read_loop      # Torna alla lettura del file

 
# Chiude il file
_close_file:
  mov $6, %eax      # syscall close
  mov fd, %ebx      # File descriptor
  int $0x80         # Interruzione del kernel

  jmp _exit         # salto a _exit

_exit:
  #finire l'esecuzione della funzione e ritornare al main
  ret

error_open:
  movl $4, %eax
  movl $1, %ebx
  leal error_open_str, %ecx
  movl error_open_str_len, %edx
  int $0x80

  jmp end
