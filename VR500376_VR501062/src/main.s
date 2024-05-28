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
    call scanf # salvo in eax

    # controllo numero inserito 
    cmp $0, %eax
    je exit
    # chiamata file edf
    cmp $1, %eax
    call edf
    # chiamata file hpf
    cmp $2, %eax
    call hpf

    jmp _start

exit: # exit
    movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall
