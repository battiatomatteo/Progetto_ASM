.section .data


.section .text
	.global insert

.type insert, @function


insert:

	# edx quando entro nella funzine mi dice quante volte devo ripetere il ciclo
	# ecx che mi indica l'indice in cui devo accedere a intstr
	# esi punta al primo elemento di intstr
	# edi punta alla posizione in cui inserire il prossimo numero di str_ordini
	# al serve per contere i caratteri da inserire nella stringa

	pushl %ecx
	
	movl  $0, %ecx


	jmp start

start:

	movb  (%esi,%ecx,1) , %al
	movb  %al , (%edi)  
	incl  %edi

	incl  %ecx	
	
	cmpl  %ecx , %edx
	jne start


fine_insert:

	popl %ecx

	ret
	