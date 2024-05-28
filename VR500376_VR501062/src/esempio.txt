.section .data


richiesta:
.ascii "Inserire numero:"
richiesta_len:
.long . - richiesta



num_str:   # variabile STRINGA per numero letto da tastiera
.ascii "0000"
num_str_len:
.long . - num_str



numstr: .ascii "00000000000"     # string output

numtmp: .ascii "00000000000"     # temporary string


.section .text 
.global _start


_start:

#-----------------------------------
#-----------------------------------
# LETTURA VALORE DA TERMINALE
#-----------------------------------
#-----------------------------------

stampa_richiesta:
  movl $4, %eax
  movl $1, %ebx
  leal richiesta, %ecx
  movl richiesta_len, %edx
  int $0x80

inserimento:
  #scanf
  movl $3, %eax
  movl $1, %ebx
  leal num_str, %ecx
  movl num_str_len, %edx
  incl %edx
  int $0x80

#-----------------------------------
#-----------------------------------
# CONVERSIONE STRINGA INTERO
#-----------------------------------
#-----------------------------------

#----------------------
# Conversione num1 
# Da Stringa a Intero!
#----------------------

atoi_num:  				

  leal num_str, %esi 		# metto indirizzo della stringa in esi 


  xorl %eax,%eax			# Azzero registri General Purpose
  xorl %ebx,%ebx           
  xorl %ecx,%ecx           
  xorl %edx,%edx
  


ripeti:

  movb (%ecx,%esi,1), %bl

  cmp $10, %bl             # vedo se e' stato letto il carattere '\n'
  je fine_atoi

  subb $48, %bl            # converte il codice ASCII della cifra nel numero corrisp.
  movl $10, %edx
  mulb %dl                # EBX = EBX * 10
  addl %ebx, %eax

  inc %ecx
  jmp ripeti


fine_atoi:


#--------------------------------------
#--------------------------------------
# Fattoriale  n! = n*(n-1)*(n-2)....*1
#--------------------------------------
#--------------------------------------
movl %eax,%ecx      # usiamo ecx come valore che decrementa e che viene moltiplicato per eax
movl $1,%eax        # eax DEVE essere messo a 1 altrimenti tutte le moltiplicazioni saranno nulle.

fattoriale:         
                    
  cmp $1,%ecx       # se ecx è uguale a 1 allora esci.
  je itoa
  mull %ecx         # eax= ecx%eax
  loop fattoriale   # ecx viene decrementato e salta a fattoriale


#---------------------------------------------------
#---------------------------------------------------
# Conversione da Intero a Stringa e Stampa a Video
#---------------------------------------------------
#---------------------------------------------------

itoa:   # il valore si trova in eax

  movl $10, %ebx             # carica 10 in EBX (usato per le divisioni)
  movl $0, %ecx              # azzera il contatore ECX

  leal numtmp, %esi          # carica l'indirizzo di 'numtmp' in ESI


continua_a_dividere:

  movl $0, %edx              # azzera il contenuto di EDX
  divl %ebx                  # divide per 10 il numero ottenuto

  addb $48, %dl              # aggiunge 48 al resto della divisione
  movb %dl, (%ecx,%esi,1)    # sposta il contenuto di DL in numtmp

  inc %ecx                   # incrementa il contatore ECX

  cmp $0, %eax               # controlla se il contenuto di EAX è 0

  jne continua_a_dividere


  movl $0, %ebx              # azzera un secondo contatore in EBX

  leal numstr, %edx          # carica l'indirizzo di 'numstr' in EDX

ribalta:

  movb -1(%ecx,%esi,1), %al  # carica in AL il contenuto dell'ultimo byte di 'numtmp'
  movb %al, (%ebx,%edx,1)    # carica nel primo byte di 'numstr' il contenuto di AL

  inc %ebx                   # incrementa il contatore EBX

  loop ribalta


stampa:

  movb $10, (%ebx,%edx,1)    # aggiunge il carattere '\n' in fondo a 'numstr'

  inc %ebx
  movl %ebx, %edx            # carica in EDX la lunghezza della stringa 'numstr'
  movl $4, %eax              # carica in EAX il codice della syscall WRITE
  movl $1, %ebx              # carica in EBX il codice dello standard output
  leal numstr, %ecx          # carica in ECX l'indirizzo della stringa 'numstr'
  int $0x80                  # esegue la syscall

fine:

  movl $1,%eax
  movl $0,%ebx
  int $0x080


