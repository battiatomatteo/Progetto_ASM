.section .data

filename:
    .ascii "./ordini/test.txt"    # Nome del file di testo da leggere
fd:
    .int 0               # File descriptor

buffer: .string ""       # Spazio per il buffer di input
lines: .int 0            # Numero di linee

.section .bss
.section .text
	.global start
	
.type start, @function

start:
	jmp _open   # Chiama la funzione per aprire il file

	leal array, %esi


	# Fine programma
    jmp fine

# Apre il file
_open:
    mov $5, %eax        # syscall open
    mov $filename, %ebx # Nome del file
    mov $0, %ecx        # Modalità di apertura (O_RDONLY)
    int $0x80           # Interruzione del kernel

    # Se c'è un errore, esce
    cmp $0, %eax
    jl fine

    mov %eax, fd      # Salva il file descriptor in ebx

ciclo:
	# leggo il char   (metto il char nella variabile buffer)
	cmp %eax, ()     # (valore per end of file)
	je fine
	movl buffer, %ebx
	cmp $10, %ebx 
	je nuova_riga
	cmp $44, %ebx
	je fine_campo
	subl $48, %ebx
	cmp  $0 , %ebx
	jge check

valore:
	mull $10
	addl %eax, %ebx
	jmp ciclo

nuova_riga:
	incl lines   # incremento il contatore
	jmp	fine_campo
		

fine_campo:
	addl %esi, # (offset di quanto si sposta l'indirizzo da un valore al successivo dell'array)
	mov %al, (%esi) # salvo in memoria il numero
	xorl %eax, %eax

check:
	cmp $9, %ebx
	jle valore
	jmp errore

errore:
	# print file con errore

    

fine:
	# Chiude il file
	mov $6, %eax        # syscall close
    mov %ebx, %ecx      # File descriptor
    int $0x80           # Interruzione del kernel


 	mov $1, %eax        # syscall exit
    xor %ebx, %ebx      # Codice di uscita 0
    int $0x80           # Interruzione del kernel

# %eax ($AL) per metter il valore da inserire nell'array
# %ebx per metter il carattere che leggo da tastiera
# %esi indirizzo del primo elemento dell'array
# array  → dove salvo i valori
