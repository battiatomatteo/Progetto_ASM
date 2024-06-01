#tutti i file da compilare , compila tutti i file eseguendolo
#il Makefile dovrà creare i file oggetto in obj/ ed il binario che verrà salvato nella cartella bin



AS_FLAGS =--32
DEBUG=-gstabs
LD_FLAGS=-m elf_i386

all: bin/pianificatore 

bin/pianificatore : obj/main_prova.o obj/atoi_num.o
	ld $(LD_FLAGS) obj/main_prova.o obj/atoi_num.o -o bin/pianificatore

obj/main_prova.o: src/main_prova.s
	as $(AS_FLAGS) $(DEBUG) src/main_prova.s -o obj/main_prova.o

obj/atoi_num.o: src/atoi_num.s
	as $(AS_FLAGS) $(DEBUG) src/atoi_num.s -o obj/atoi_num.o

clean:
	rm -f obj/*.o bin/pianificatore
