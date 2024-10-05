# scelta algoritmo (edf o hpf)
.section .data

# variabile testo che contiene il menu che viene mostrato all'inizio dal programma
testo:
	.ascii "Scegli tra \n 0 Esce \n 1 EDF \n 2 HPF \n"

testo_len:
	.long . - testo     # lunghezza della stringa testo

# variabile testo che contiene un messaggio di errore in caso la funzionalita' del menu scelta non sia valida
error_str:
	.ascii "Hai inserito un valore errato riprovare\n"
 
error_str_len:
	.long . - error_str     # lunghezza della stringa error_str
	

.section .text
    .global _start

# punto di inizio del programma
_start:
    popl	%eax    # prelevo il numero di parametri del programma e lo metto in eax
    popl	%ebx    # prelevo il nome del programma e lo metto in ebx
    popl	%ebx    # prelevo il primo parametro passato al programma (percorso del file da usare) e lo metto in ebx
    
    call readfile   # chiamo la funzione readfile
    jmp main        # dopo aver eseguito readfile salto all'etichetta main

main:
    # in questa parte del codice mostro un menu e agisco in base al valore inserito dall'utente
    # 0 termino 1 uso EDF 2 uso HPF altro valore mostro un messaggio di errore e chiedo di reinserire
    # il programma continua a mostrare il menu e a richiedere valori fino a che non viene inserito un valore accetabile
    # e poi se l'utente non ha inserito presenta nuovamente il menu per per calcolare con un altro algoritmo

    # stampo a video testo 
    movl $4, %eax               # scelgo il tipo di SysCall (4 -> write)
    movl $1, %ebx               # scelgo dove effettuare la SysCall (1 -> standard output)
    leal testo, %ecx            # scelgo che cosa stampare (stampo il valore contenuto all'indizzo di testo )
    movl testo_len, %edx        # dico quanti caratteri devo stampare
	int $0x80                   # effettuo la SysCall
    
	call scanf  #chiamo la funzione scanf per recuperare il valore inserito da console
	 
    # controllo numero inserito 
    cmp $0, %eax  # se ho inserito 0 termino il programma
    je exit       # salto all'etichetta exit e chiudo il programma

    # chiamata file edf
    cmp $1, %eax  # se ho inserito 1 elaboro gli ordini usando l'EDF
	je _edf       # salto all'etichetta _edf 
    
    # chiamata file hpf
    cmp $2, %eax  # se ho inserito 2 elaboro gli ordini usando l'HPF
	je _hpf       # salto all'etichetta _hpf

	# con qualsiasi altro valore inserito il programma salta all'etichetta error e mostr un messaggio di errore
    jmp error

exit: 
    # termino l'esecuzione del programma

    movl $1, %eax         # scelgo il tipo di SysCall (1 -> exit)
	xorl %ebx, %ebx       # scelgo il tipo di esito (0 -> No Error)
	int $0x80             # effettuo la SysCall

_hpf:
    # utilizzo l'algoritmo hpf e poi ritorno all'etichetta main

    call hpf  # chiamata alla funzione hpf
    jmp	main  # salto a main

_edf:
    # utilizzo l'algoritmo edf e poi ritorno all'etichetta main

    call edf  # chiamata alla funzione edf
    jmp	main  # salto a main

error:
    #effettuo una system call write per mostrare un messaggio di errore contenuto in error_str

    movl $4, %eax                # scelgo il tipo di SysCall (4 -> write)
    movl $1, %ebx                # scelgo dove effettuare la SysCall (1 -> standard output)
    leal error_str, %ecx         # scelgo che cosa stampare (stampo il valore contenuto all'indizzo di error_str )
    movl error_str_len, %edx     # dico quanti caratteri devo stampare
    int $0x80                    # effettuo la SysCall

    jmp main                     # salto all'etichetta main



