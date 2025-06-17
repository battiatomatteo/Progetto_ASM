# Progetto_ASM

## 📌 Descrizione
Questo progetto in **Assembly** ha lo scopo di calcolare l'ordine di produzione di massimo **dieci ordini**, tenendo conto di eventuali penalità per ritardi nei tempi.  
Gli ordini vengono letti da un file di testo e ordinati secondo la scelta dell'utente:

1️⃣ **EDF (Earliest Deadline First)** - Ordina per **scadenza più vicina** (in caso di parità, si considera la priorità maggiore).  
2️⃣ **HPF (High Priority First)** - Ordina per **priorità maggiore** (in caso di parità, si ordina per scadenza).  
0️⃣ **Chiudi il programma**.

## 📂 Struttura della Repository
Per garantire un'organizzazione chiara, si consiglia di creare le seguenti cartelle **vuote** prima dell'esecuzione:

- `bin` → Per i file eseguibili.
- `obj` → Per gli oggetti compilati.

## 🔧 Linguaggi Utilizzati
- **Assembly** - Linguaggio principale del progetto.

## 💻 Esecuzione
Il programma legge il file di testo contenente gli ordini, li ordina secondo la modalità scelta dall'utente e restituisce la lista ordinata con eventuali penalità applicate ai ritardi.
