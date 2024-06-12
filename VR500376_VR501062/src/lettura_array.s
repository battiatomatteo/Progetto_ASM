	
	
	leal array, $ESI

ciclo:
	leggo il char   (metto il char nella variabile buffer)
	cmp $EAX, (valore per end of file)
	je fine
	movl buffer $EBX
	cmp $EBX, (char '\n')
	je fine_campo
	cmp $EBX, (char ',')
	je fine_campo
	cmp $EBX, (char '0')
	jge check

valore:
	movl $EAX, $10
	# mull $EAX, 10
	addl $EAX, $EBX
	jump ciclo

fine_campo
	addl $ESI, # (offset di quanto si sposta l'indirizzo da un valore al successivo dell'array)
	mov AL, ($ESI)
	xorl $EAX, %EAX

check:
	cmp $EBX , (char '9')
	jel valore

errore:
	# print file con errore

fine:



# $EAX ($AL) per metter il valore da inserire nell'array
# $EBX per metter il carattere che leggo da tastiera
# $ESI indirizzo del primo elemento dell'array
# array  → dove salvo i valori
