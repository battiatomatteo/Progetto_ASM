# scelta algoritmo (edf o hpf)
.section .data

titolo:
    .ascii "MAIN\n\n"

titolo_len:
	.long . - titolo		# lunghezza del titolo

testo:
	.ascii "Si prega di scegliere tra :\n0)EXIT\n1)EDF\n2)HPF\n\n"

testo_len:
	.long . - testo     # lunghezza della stringa testo

section.bss
    num resd 1 # per allocare un carattere 

section.text
    global _start

_start:
    # leggo l'intero (scanf)
    movl $3, %eax
    movl $1, %ebx
    leal num_str, %ecx
    movl num_str_len, %edx
    incl %edx
    int $0x80


# converto l'input in intero
atoi_num:  				

    leal num_str, %esi 		# metto indirizzo della stringa in esi 


    xorl %eax,%eax			# Azzero registri General Purpose
    xorl %ebx,%ebx           
    xorl %ecx,%ecx           
    xorl %edx,%edx
  


ripeti:

    movb (%ecx,%esi,1), %bl

    cmp $10, %bl             # vedo se e' stato letto il carattere '\n'
    je fine_atoi

    subb $48, %bl            # converte il codice ASCII della cifra nel numero corrisp.
    movl $10, %edx
    mulb %dl                # EBX = EBX * 10
    addl %ebx, %eax

    inc %ecx
    jmp ripeti


fine_atoi: # chiusura conversione
    

    # controllo numero inserito 
    cmp $0, %eax
    je exit
    # chiamata file edf
    cmp $1, %eax
    je edf
    # chiamata file hpf
    cmp $2, %eax
    je hpf

    jmp _start

exit: # exit
    movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall
