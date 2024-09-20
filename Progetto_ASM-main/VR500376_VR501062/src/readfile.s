
.section .data

filename:
  # errore nell'apertura file in un'altra cartella
  .ascii "./src/test.txt"    # Nome del file di testo da leggere
fd:
  .int 0               # File descriptor

buffer: .string ""       # Spazio per il buffer di input
max_i: .int 0
#vettore_str: .int 0

.section .bss
vettore: .space 140       # Dimensione del vettore 

.section .text
  .global readfile
  .global	vettore
  .global	max_i

.type readfile, @function

readfile:
  jmp _open          # Chiama la funzione per aprire il file


# Apre il file
_open:
  mov $5, %eax        # syscall open
  mov $filename, %ebx # Nome del file
  mov $0, %ecx        # Modalita' di apertura (O_RDONLY)
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
  cmpb $10, %al     # Confronto AL con il carattere \n
  jne _add_to_vector    # Se sono diversi, aggiungi il carattere al vettore


_add_to_vector:
  movl max_i , %ebx 
  # Aggiungi il carattere al vettore
  movb %al, vettore(%ebx) 
  incl %ebx         # Incrementa l'indice del vettore
  movl %ebx , max_i
  jmp _read_loop      # Torna alla lettura del file

 
# Chiude il file
_close_file:
  mov $6, %eax        # syscall close
  mov fd, %ebx      # File descriptor
  int $0x80           # Interruzione del kernel

  jmp _exit

_exit:
  #finire l'esecuzione della funzione e ritornare al main

  ret

