# Progetto_ASM

Il fine di questo progetto è quello di calcolare l'ordine di produzione di non più di dieci 
ordini, con eventuali penalità dovute a dei ritardi nei tempi. Gli ordini, salvati in un file di 
testo, vengono prelevati ed ordinati in base ad una scelta fatta dall’utente: la prima scelta 
consiste nell’inserire 1 dove di conseguenza vengono ordinati con l’algoritmo EDF 
(Earliest Deadline First) cioè ordina secondo scadenza più vicina (in caso di parità di 
scadenza, si considera la priorità maggiore), la seconda scelta consiste nell’inserire 2 
dove di conseguenza vengono ordinati con l’algoritmo HPF (High Priority First) cioè ordina 
secondo priorità maggiore (in caso di parità di priorità si ordina per scadenza) ed in fine si 
ha una terza scelta cioè se si desidera chiudere il programma si inserisce 0.