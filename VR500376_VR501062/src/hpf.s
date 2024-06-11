# algoritmo hpf : Highest Priority First (HPF): si pianificano per primi i prodotti con priorità più alta, in caso di 
# parità di priorità, si pianifica il prodotto con la scadenza più vicina.

.section .data

_hpf:
	.ascii "Pianificazione HPF\n"
 
hpf_len:
	.long . - _hpf     # lunghezza della stringa testo

.section .text
  .global hpf

.type hpf, @function

hpf:
    movl $4, %eax
    movl $1, %ebx
    leal _hpf, %ecx
    movl hpf_len, %edx
    int $0x80
    jmp exit

exit: # exit
  movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall

  
