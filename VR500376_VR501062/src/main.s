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
    num resd 1 #

section.text
    global _start

_start:
    # leggo l'intero
    movl %eax, 3
    movl %ebx, 0
    movl %ecx, num
    movl %edx, 4
    int $0x80

    # converto l'input in intero
    movl %eax, [num]    # da controllare !!
    subl %eax, '0'
    
    # 

    
exit: # exit
    movl %eax, 1
    xorl %ebx, %ebx
    int $0x80
