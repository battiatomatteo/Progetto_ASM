.section .data

.section .text
    .global atoi_num

.type atoi_num, @function # dichiaro della funzione atoi_num --> conversione str2int

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
    ret
    