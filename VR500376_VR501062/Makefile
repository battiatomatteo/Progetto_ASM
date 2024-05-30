#tutti i file da compilare , compila tutti i file eseguendolo
#il Makefile dovrà creare i file oggetto in obj/ ed il binario che verrà salvato nella cartella bin


EXE=main_prova
AS= as 
LD= ld 
AS_FLAGS= -gstabs
#LD_FLAGS=
OBJ=main_prova.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

main_prova.o: main_prova.s
	$(AS) $(AS_FLAGS) -o main_prova.o main_prova.s

clean:
	rm -f *.o $(EXE) core
