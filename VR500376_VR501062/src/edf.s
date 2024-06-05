# algoritmo edf
.section .data

.section .text
  .global edf

.type edf, @function

_edf:
	.ascii "scelto edf\n"
 
edf_len:
	.long . - edf     # lunghezza della stringa testo

edf:
    movl $4, %eax
    movl $1, %ebx
    leal _edf, %ecx
    movl edf_len, %edx
    int $0x80
    jmp exit

exit: # exit
  movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall

  

