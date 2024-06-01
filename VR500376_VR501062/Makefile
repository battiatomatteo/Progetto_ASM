#tutti i file da compilare , compila tutti i file eseguendolo
#il Makefile dovrà creare i file oggetto in obj/ ed il binario che verrà salvato nella cartella bin


#EXE=main_prova
#AS= as 
#LD= ld 
#AS_FLAGS= -gstabs
#LD_FLAGS=
#OBJ=main_prova.o
AS_FLAGS =--32
DEBUG=-gstabs
LD_FLAGS=-m elf_i386

all: bin/pianificatore 

bin/pianificatore : obj/main_prova.o
	ld $(LD_FLAGS) obj/main_prova.o -o bin/pianificatore

obj/main_prova.o: src/main_prova.s
	as $(AS_FLAGS) $(DEBUG) src/main_prova.s -o obj/main_prova.o

clean:
	rm -f obj/*.o bin/pianificatore
