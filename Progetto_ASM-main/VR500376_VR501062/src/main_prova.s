# scelta algoritmo (edf o hpf)
.section .data

testo:
	.ascii "Scegli tra \n 0 Esce \n 1 EDF \n 2 HPF \n"
 
testo_len:
	.long . - testo     # lunghezza della stringa testo
	
error_str:
	.ascii "Hai inserito un valore errato riprovare\n"
 
error_str_len:
	.long . - error_str     # lunghezza della stringa testo
	

.section .text
    .global _start

_start:
    call readfile
    jmp main

main:

    # stampo a video testo 
	movl $4, %eax
	movl $1, %ebx
    leal testo, %ecx
    movl testo_len, %edx
	int $0x80
    
    
	
	call scanf 
	 

    # controllo numero inserito 
    cmp $0, %eax
    je exit

    # chiamata file edf
    cmp $1, %eax
	je _edf
    
    # chiamata file hpf
    cmp $2, %eax
	je _hpf

	# non entra nei je
    jmp error

exit: # exit
    movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall


_hpf:
    call hpf
    jmp	main

_edf:
    call edf
    jmp	main

error:
    movl $4, %eax
    movl $1, %ebx
    leal error_str, %ecx
    movl error_str_len, %edx
    int $0x80

    jmp main



