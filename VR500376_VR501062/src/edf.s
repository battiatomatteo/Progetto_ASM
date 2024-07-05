# algoritmo edf Earliest Deadline First (EDF):
# si pianificano per primi i prodotti la cui scadenza è più vicina, in 
# caso di parità nella scadenza, si pianifica il prodotto con la priorità più alta. 
.section .data

_edf:
	.ascii "Pianificazione EDF\n"
 
edf_len:
	.long . - _edf     # lunghezza della stringa testo

.section .text
  .global edf

.type edf, @function

edf:
    movl $4, %eax
    movl $1, %ebx
    leal _edf, %ecx
    movl edf_len, %edx
    int $0x80

    call readfile
    
    # togliere etichetta exit in readfile.s 

    jmp exit

exit: # exit
  movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall

  

