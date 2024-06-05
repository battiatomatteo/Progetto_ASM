# scelta algoritmo (edf o hpf)
.section .data

# titolo:
    # .ascii "MAIN\n\n"

# titolo_len:
	# .long . - titolo		# lunghezza del titolo

testo:
	.ascii "Scegli tra \n 0 Esce \n 1 EDF \n 2 HPF \n"
 
testo_len:
	.long . - testo     # lunghezza della stringa testo
	

#scelta:
#	.ascii "0000\n"
	

#ln_scelta:
#	.long . - scelta     # lunghezza della scelta

.section .text
    .global _start


_start:

    #stampo a video testo 
	movl $4, %eax
	movl $1, %ebx
    leal testo, %ecx
    movl testo_len, %edx
	int $0x80

	#movl $42, %eax  # Inizializza eax con il valore intero 42

    # scanf -> lettura numero da tastiera 
	#movl $3, %eax
	#movl $1, %ebx
    #leal scelta, %ecx
    #movl ln_scelta, %edx
	#int $0x80
	
    #movl scelta, %esi

    #stampo a video scelta 
	#movl $4, %eax
	#movl $1, %ebx
    #leal scelta, %ecx
    #movl ln_scelta, %edx
	#int $0x80

	
	
	call scanf 
	 

    # controllo numero inserito 
    cmp $0, %eax
    je exit

    # chiamata file edf
    cmp $1, %eax
    je edf
	#je _edf
    
    # chiamata file hpf
    cmp $2, %eax
    je hpf
	#je _hpf

	#non entra nei je
    jmp exit

exit: # exit
    movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall


