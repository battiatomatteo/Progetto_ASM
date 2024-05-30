# scelta algoritmo (edf o hpf)
.section .data

titolo:
    .ascii "MAIN\n\n"

titolo_len:
	.long . - titolo		# lunghezza del titolo

testo:
	.ascii "Scegli tra \n 0 Esce \n 1 EDF \n 2 HPF"
 
testo_len:
	.long . - testo     # lunghezza della stringa testo

.section .text
    .global _start

_start: