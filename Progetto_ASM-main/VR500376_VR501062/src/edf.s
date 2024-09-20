# algoritmo edf Earliest Deadline First (EDF):
# si pianificano per primi i prodotti la cui scadenza è più vicina, in 
# caso di parità nella scadenza, si pianifica il prodotto con la priorità più alta. 
.section .data

_edf:
	.ascii "Pianificazione EDF\n"
 
edf_len:
	.long . - _edf     # lunghezza della stringa testo


prec: .int 0
# max_i: .int 0
max_i_int: .int 0
str_ordine: .ascii	"000000\n"
ordine_len: .int 7
intstr: .ascii "0000"    
str_ordine_len: .int 2

conclusione: .ascii	"Conclusione000000"
conclusione_len: .int 13
penalita: .ascii "Penalty000000"
penalita_len: .int 9


.section .bss
# vettore: .space 140       # Dimensione del vettore 
vettore_2: .space 16       # Dimensione del vettore (puoi cambiarla)
vettore_int: .space 200       # Dimensione del vettore (puoi cambiarla)













.section .text
  .global edf

.type edf, @function

edf:
    movl $4, %eax
    movl $1, %ebx
    leal _edf, %ecx
    movl edf_len, %edx
    int $0x80

    movl $0,max_i_int

    jmp char_to_int_in
    





     
in_calcolo:

  xorl %eax,%eax			# Azzero i registri 
  xorl %ebx,%ebx           
  xorl %ecx,%ecx           
  xorl %edx,%edx
  xorl %esi,%esi
  xorl %edi,%edi


  
  leal vettore_int, %esi         # carico l'indirizzo di vettore nel registro
  leal vettore_2, %edi        # carico l'indirizzo di vettore_int nel registro
  
  movl $2, %eax   # reinizializzo indice a 2 (il primo valore scadenza salvato in vettore[2])
  movl $4, %ecx


  # modificare ecx per il numero di passate dell'ordinamento


  movl (%esi,%eax,4), %ebx    # prende eax , lo moltiplica per 4 e lo somma a esi 
  movl %ebx, prec     # salvo il valore precedente nella variabile prec 

  
  
  jmp calcolo         # salto a calcolo



in_succ_calcolo:

  xorl %eax,%eax			# Azzero i registri 
  xorl %ebx,%ebx                      
  xorl %edx,%edx
 
  movl $2, %eax          # reinizializzo indice a 2 (il primo valore scadenza salvato in vettore[2])


  movl (%esi,%eax,4), %ebx    # prende eax , lo moltiplica per 4 e lo somma a esi 
  movl %ebx, prec     # salvo il valore precedente nella variabile prec 

  jmp calcolo         # salto a calcolo
    
calcolo: 
  # sezione che si occupa del calcolo per trovare l'ordine da stampare 
  # errore 
  addl $4, %eax              # incremento di 4 l'indice per prendere la scadenza sucessiva 

  cmpl %eax , max_i_int             # controllo se ci stanno altre scadenze ,  deve essere (eax<max_i)
  jl finegiro
  # confronto chi dei due e' piu' piccolo if(vettore[i]<prec) modifico prec se no rimane lo stesso
  movl prec, %ebx
  cmpl (%esi,%eax,4), %ebx    # ebx qui tiene la scadenza   
  jg calcolo_2 
  je priorita

  movl (%esi,%eax,4), %ebx
  movl %ebx, prec    # sposto il valore di vettore(%eax) in prec se prec e minore 

  jmp calcolo 

finegiro:
  # ho finito un giro di scambi e se non e' l'ultimo ne faccio un'altro altrimenti passo avanti con il programma, 
  # il numero di passate da fare e' salvato in ecx e viene decrementato ogni volta
  decl %ecx
  cmpl $0, %ecx
  je in_stampa
  jmp in_succ_calcolo


priorita:   # caso in cui la scadenza e' uguale 
  pushl	%eax
  addl $1, %eax
  movl (%esi,%eax,4), %edx
  subl $4, %eax

  cmpl (%esi,%eax,4), %edx  # 1 < 2

  popl	%eax
  
  jg calcolo_2

  

  movl (%esi,%eax,4), %ebx
  movl %ebx, prec    # sposto il valore di vettore(%eax) in prec se prec e minore 
  jmp calcolo



calcolo_2:
  # carico nella pila i registri
  pushl %eax   # indice di quello piu' piccolo (+4 rispetto al prec)
  pushl %ebx   # precedente valore 
  pushl %ecx   # il contatore delle passate ordinamento 

    
# situazione quando entro nella funzione
#              vettore_int                      vettore2
# |    ordine 1   |    ordine 2   |              vuoto
# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |         | 0 | 1 | 2 | 3 |    


# faccio una copia del primo ordine
#              vettore_int                      vettore2
# |    ordine 1   |    ordine 2   |              ordine 1
# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |         | 0 | 1 | 2 | 3 | 
# ebx mi punta al primo elemento dell'ordine 1 (in 0)
# ecx mi punta al primo elemento dell'ordine 2 (in 4)


# preparo gli indici degli array
  movl %eax, %ebx
  
  subl $6, %ebx
  movl $0, %ecx

  
  movl (%esi,%ebx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%edi,%ecx,4) # copio il valore di edx in vettore 2(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx


  movl (%esi,%ebx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%edi,%ecx,4) # copio il valore di edx in vettore 2(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx

  
  movl (%esi,%ebx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%edi,%ecx,4) # copio il valore di edx in vettore 2(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx


  movl (%esi,%ebx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%edi,%ecx,4) # copio il valore di edx in vettore 2(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx
    


# sostituisco il primo ordine con il secondo
#              vettore_int                      vettore2
# |    ordine 2   |    ordine 2   |              ordine 1
# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |         | 0 | 1 | 2 | 3 |    

# preparo gli indici degli array
  movl %eax, %ebx
  movl %eax, %ecx

  subl $6, %ebx
  subl $2, %ecx

  
  movl (%esi,%ecx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx


  movl (%esi,%ecx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx

  
  movl (%esi,%ecx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx


  movl (%esi,%ecx,4), %edx  # copio il valore di vettore int(%ebx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ecx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx



# sposto il secondo ordine al posto del primo
#              vettore_int                      vettore2
# |    ordine 2   |    ordine 1   |              ordine 1
# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |         | 0 | 1 | 2 | 3 |

# preparo gli indici degli array
  movl %eax, %ebx
  
  subl $2, %ebx
  movl $0, %ecx

  
  movl (%edi,%ecx,4), %edx  # copio il valore di vettore 2(%ecx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ebx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx


  movl (%edi,%ecx,4), %edx  # copio il valore di vettore 2(%ecx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ebx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx

  
  movl (%edi,%ecx,4), %edx  # copio il valore di vettore 2(%ecx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ebx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx


  movl (%edi,%ecx,4), %edx  # copio il valore di vettore 2(%ecx) in edx
  movl %edx , (%esi,%ebx,4) # copio il valore di edx in vettore int(%ebx)
  
  # sposto in avanti gli indici
  incl %ebx
  incl %ecx






  # scarico dalla pila i registri ( ripristino ai valori che avevano prima dello scambio)
  popl %ecx
  popl %ebx
  popl %eax



  movl (%esi,%eax,4), %ebx
  movl %ebx, prec    # sposto il valore di vettore(%eax) in prec se prec e minore 

  jmp calcolo



char_to_int_in:  				

  xorl %eax,%eax			# Azzero registri General Purpose
  xorl %ebx,%ebx           
  xorl %ecx,%ecx           
  xorl %edx,%edx

  leal vettore, %esi         # carico l'indirizzo di vettore nel registro
  leal vettore_int, %edi        # carico l'indirizzo di vettore_int nel registro

  jmp char_to_int


char_to_int:

  cmpl %ecx , max_i       # controllo se ci stanno altre scadenze ,  deve essere (eax<max_i)
  jl in_calcolo

  movb (%esi) , %bl
  incl %esi

  cmpb $10, %bl  # controllo se il char e' uguale a '\n'
	je fine_campo
	cmpb $44, %bl   # controllo se il char e' uguale a ','
	je fine_campo
	cmpb $47, %bl   # controllo se e' maggiore di '0'
	jg check 


fine_campo:
  incl %ecx              # incremento l'indice
  movl %eax, (%edi)
  addl $4 , %edi
  movl max_i_int , %eax 
  addl $1, %eax       # incrementa il numero di campi interi
  movl %eax, max_i_int 
  xorl %eax, %eax
  
  jmp char_to_int

# mul moltiplica il valore contenuto in eax per quello che gli do come 
# operando e il risultato e' contenuto in edx + eax 
valore:
  subl $48, %ebx
  movl $10, %edx
	mul %edx   # crea il numero , lo moltiplica per 10
	addl %ebx, %eax # somma ebx e eax buttandolo in eax
  incl %ecx
	jmp char_to_int

check:
	cmpb $58, %bl # controllo se e' minore di '9'
	jl valore
    # gestire errore


in_stampa:

  xorl %eax,%eax			# Azzero registri General Purpose
  xorl %ebx,%ebx           
  xorl %ecx,%ecx           
  xorl %edx,%edx

  leal vettore_int, %esi        # carico l'indirizzo di vettore_int nel registro
  leal str_ordine, %edi        # carico l'indirizzo di ordine nel registro

  # movb $58, 3(%edi)  # per mettere i due punti verticali al centro

  

  jmp ordine

# formato stringa di output
# "  ID  : inizio  \n  "
# "\0\0\0:\0\0\n"

# Conclusione: \0\0\0   
# Penalty: \0\0\0

# ebx contiene il momento di inizio dell'ordine precedente 
#(il primo ordine vede come valore di ebx 0 perche' nessuno e'ancora iniziato)
# ecx contiene la penalita' accumulata fino a quel momento dagli ordini 

ordine:

  movl (%esi) , %eax
  cmpl $0, %eax
  je	end_list

  jmp componi_stringa

    

componi_stringa:


  # convertire l'id in stringa per la stampa e aggiungerlo alla stringa ordine
  pushl %esi
  leal intstr, %esi          # carica l'indirizzo di 'intstr' in esi
  call int_to_str

  movl %edx, %eax
  addl %eax, str_ordine_len 

  call insert

  movb $58, (%edi) # metto i 2 punti verticali 
  incl %edi

  # convertire il valore della durata dell'ordine (che contiene quando e' finito l'ordine precedente) in stringa per la stampa e aggiungerlo alla stringa ordine
  movl %ebx,%eax
  call int_to_str

  movl %edx, %eax
  addl %eax, str_ordine_len 

  call insert

  movb $10, (%edi) # metto il carattere di fine riga 
  incl %edi

    
  # calcolo quando finisce l'ordine 
  popl %esi
  movl 4(%esi) , %edx
  addl %edx, %ebx

  # calcolo se l'ordine ha della penalita' e la calcolo
  cmpl %ebx, 8(%esi)
  jle calcolo_priorita
  

  jmp stampa



calcolo_priorita:
  movl %ebx, %eax
  movl 8(%esi), %edx
  subl %edx , %eax
  movl 12(%esi), %edx
  mull %edx

  addl %eax, %ecx



  
  jmp stampa



stampa:

  pushl	%ebx
  pushl	%ecx

  leal  str_ordine, %edi

  movl $4, %eax             # Numero della system call sys_write
  movl $1, %ebx             # File descriptor 1 è lo standard output
  leal str_ordine , %ecx        # Puntatore alla stringa
  movl str_ordine_len, %edx             # caratteri da stampare
  int $0x80  

  popl  %ecx
  popl  %ebx
  addl  $16, %esi   # passo al prossimo ordine (16 perche' si tratta di interi)   
  movl  $2, str_ordine_len
  jmp ordine


end_list:
# convertire ebx ed ecx in stringa e 
# aggiungerli alle stringhe Penalty e Conclusione
# stampare le stringhe

  leal	intstr, %esi
  leal  conclusione, %edi
  movl  %ebx, %eax
  call	int_to_str
  movb  $58 , 11(%edi)
  addl  $12 , %edi
  addl  %edx, conclusione_len
  call insert
  movb $10 , (%edi)
  incl %edi


  pushl	%ecx


  movl $4, %eax             # Numero della system call sys_write
  movl $1, %ebx             # File descriptor 1 è lo standard output
  leal conclusione , %ecx        # Puntatore alla stringa
  movl conclusione_len, %edx             # caratteri da stampare
  int $0x80  


  
  popl	%ecx

  leal intstr, %esi
  leal penalita, %edi
  movl %ecx, %eax
  call int_to_str
  movb $58 , 7(%edi)
  addl $8 , %edi
  addl %edx, penalita_len
  call insert
  movb $10 , (%edi)
  incl %edi

  movl $4, %eax             # Numero della system call sys_write
  movl $1, %ebx             # File descriptor 1 è lo standard output
  leal penalita , %ecx        # Puntatore alla stringa
  movl penalita_len, %edx             # caratteri da stampare
  int $0x80  


  movl $13, conclusione_len
  movl $9, penalita_len

  jmp _exit


_exit:
  #finire l'esecuzione della funzione e ritornare al main

  xorl %eax,%eax            # Azzero registri General Purpose     
  xorl %ebx,%ebx                
  xorl %ecx,%ecx                
  xorl %edx,%edx
  xorl %esi,%esi
  xorl %edi,%edi

  ret




