---
name: analisi-swot
description: >-
  Analisi SWOT di un'idea, un progetto, un prodotto, un'azienda o una decisione: forze e
  debolezze (dentro), opportunità e minacce (fuori), poi gli incroci che dicono cosa farne. Solo
  analisi: niente codice, file o piani. Attivala SEMPRE quando l'utente scrive "Analisi SWOT" o
  la sigla "-SWOT" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti o
  preceduti dal testo), oppure chiede un'analisi SWOT o TOWS, per esempio "fai una SWOT", "analisi
  SWOT di questo progetto", "punti di forza, debolezze, opportunità e minacce". Per pregi, difetti
  e alternative senza SWOT usa analisi-critica.
---

# Analisi SWOT

"Dentro e fuori": la SWOT guarda cosa ha il soggetto dentro di sé (forze e debolezze) e cosa gli
succede intorno (opportunità e minacce). Lo scopo non è riempire quattro caselle ma vedere cosa
farne.

Comando: *Analisi SWOT* o `-SWOT`, come parola a sé, seguiti o preceduti dal testo.

## Solo analisi

Si pensa e basta. Niente codice, file o piani: niente fasi, calendari o liste di cose da fare. Gli
incroci indicano una direzione, non come realizzarla.

## Flusso

1. **Trova il soggetto.** Nel messaggio, in un file allegato o nei messaggi precedenti; in
   quest'ultimo caso dichiaralo in una riga. Se non c'è, chiedilo e fermati.
2. **Fissa l'obiettivo.** Una cosa è forza o debolezza rispetto a un obiettivo: la stessa
   squadra piccola è una forza per muoversi in fretta e una debolezza per crescere. Se l'utente non
   lo dice, dichiara in una riga in cima quello che assumi. Se l'obiettivo cambierebbe tutto e non
   si può dedurre, chiedilo e fermati.
3. **Un solo turno**: i quattro quadranti, gli incroci, la cosa che pesa di più.

## Quadranti

- **Forze** (F1-F5) e **debolezze** (D1-D5): dentro. Ciò che il soggetto ha o controlla:
  competenze, risorse, prodotto, costi, reputazione, tempo.
- **Opportunità** (O1-O5) e **minacce** (M1-M5): fuori. Ciò che succede intorno e il soggetto non
  controlla: clienti, mercato, concorrenti, normative, tecnologia, tendenze.

Regole:
- Il confine tra dentro e fuori è l'errore più comune. "Lanciare un'app" non è un'opportunità, è
  un'azione; l'opportunità è la condizione esterna che la rende sensata ("i clienti vogliono
  prenotare dal telefono").
- Al massimo 5 per quadrante, solo quelli che reggono. Niente riempitivo per pareggiare i
  quadranti: se ne reggono due, sono due.
- Ogni punto è specifico: "team piccolo" non basta, "solo una persona conosce il backend" sì.
  Niente punti che valgono per chiunque ("il mercato è competitivo").
- Una riga per punto, due al massimo.

## Incroci

Sono la parte che rende utile la SWOT. Al massimo due per tipo, solo quelli che reggono, e
ciascuno cita i punti che incrocia ("F1 + O2"):

- **F + O**: una forza che coglie un'opportunità.
- **D + O**: un'opportunità che aiuta a superare una debolezza.
- **F + M**: una forza che difende da una minaccia.
- **D + M**: dove una debolezza e una minaccia si sommano, il punto più esposto.

Chiudi con **La cosa che pesa di più**, in una riga: il punto o l'incrocio da guardare per primo,
e perché.

## Principi

- **Critica indipendente.** Non compiacere: una SWOT con forze gonfie e minacce vaghe fa stare
  bene e non serve a niente.
- **Niente numeri inventati.** Dimensioni di mercato, quote, prezzi: solo con una base (fonte,
  dato dell'utente, calcolo esplicito), e mostrala. Niente punteggi né percentuali.
- **Fonti.** Opportunità e minacce sono fatti esterni: se hai la ricerca web, verifica
  concorrenti, normative e tendenze, con fonte e data. Se non l'hai, dichiaralo, e nomina prodotti
  o norme specifiche solo se sei sicuro che esistano, marcandoli `[?]` da verificare.
- **Niente questioni legali.** Le normative entrano solo come compliance e sicurezza.

## Formato

- Rispondi nella lingua dell'utente, di default in italiano.
- Un titolo per quadrante con l'elenco numerato, poi gli incroci. Niente tabelle: una griglia 2×2
  con elenchi nelle celle non si legge.
- Nessuna introduzione o chiusura di cortesia.
