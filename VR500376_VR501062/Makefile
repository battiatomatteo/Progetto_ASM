#tutti i file da compilare , compila tutti i file eseguendolo
#il Makefile dovrà creare i file oggetto in obj/ ed il binario che verrà salvato nella cartella bin



AS_FLAGS =--32
DEBUG=-gstabs
#LD_FLAGS=-m i386pe  
LD_FLAGS=-m elf_i386

all: bin/pianificatore

bin/pianificatore : obj/main_prova.o obj/scanf.o obj/hpf.o obj/edf.o obj/readfile.o obj/itoa.o obj/insert.o
	ld $(LD_FLAGS) obj/main_prova.o obj/scanf.o obj/hpf.o obj/edf.o obj/readfile.o obj/itoa.o obj/insert.o   -o bin/pianificatore

obj/main_prova.o: src/main_prova.s
	as $(AS_FLAGS) $(DEBUG) src/main_prova.s -o obj/main_prova.o

obj/scanf.o: src/scanf.s
	as $(AS_FLAGS) $(DEBUG) src/scanf.s -o obj/scanf.o

obj/hpf.o: src/hpf.s
	as $(AS_FLAGS) $(DEBUG) src/hpf.s -o obj/hpf.o

obj/edf.o: src/edf.s
	as $(AS_FLAGS) $(DEBUG) src/edf.s -o obj/edf.o

obj/readfile.o: src/readfile.s
	as $(AS_FLAGS) $(DEBUG) src/readfile.s -o obj/readfile.o

obj/itoa.o: src/itoa.s
	as $(AS_FLAGS) $(DEBUG) src/itoa.s -o obj/itoa.o

obj/insert.o: src/insert.s
	as $(AS_FLAGS) $(DEBUG) src/insert.s -o obj/insert.o

clean:
	rm -f obj/*.o bin/pianificatore
