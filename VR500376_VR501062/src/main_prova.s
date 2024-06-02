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

	


hpf:
	.ascii "scelto hpf\n"
 
hpf_len:
	.long . - hpf     # lunghezza della stringa testo

edf:
	.ascii "scelto edf\n"
 
edf_len:
	.long . - edf     # lunghezza della stringa testo

exit_:
	.ascii "uscita programma\n"
 
exit_len:
	.long . - exit_     # lunghezza della stringa testo


	

scelta:
	.long 0

ln_scelta:
	.long . - scelta     # lunghezza della scelta

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
	movl $3, %eax
	movl $1, %ebx
    leal scelta, %ecx
    movl ln_scelta, %edx
	int $0x80
    
    #stampo a video scelta 
	#movl $4, %eax
	#movl $1, %ebx
    #leal scelta, %ecx
    #movl ln_scelta, %edx
	#int $0x80

	
	
	call itoa
	 

    # controllo numero inserito 
    cmp $0, %eax
    je fine

    # chiamata file edf
    cmp $1, %eax
    # call edf
	je _edf
    
    # chiamata file hpf
    cmp $2, %eax
    # call hpf
	je _hpf

	#non entra nei je


_hpf:
    movl $4, %eax
	movl $1, %ebx
    leal hpf, %ecx
    movl hpf_len, %edx
	int $0x80
	jmp exit


_edf:
	movl $4, %eax
	movl $1, %ebx
    leal edf, %ecx
    movl edf_len, %edx
	int $0x80
	jmp exit

fine:
    movl $4, %eax
	movl $1, %ebx
    leal exit_, %ecx
    movl exit_len, %edx
	int $0x80
    jmp exit


exit: # exit
    movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall
