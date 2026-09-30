---
name: test-first
description: Corregge un bug partendo da un test che lo riproduce e fallisce, poi applica la correzione minima alla causa e mostra lo stesso test passare da rosso a verde. Attivala SEMPRE quando l'utente scrive "Test first" o la sigla "-TF" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti o preceduti dalla descrizione del bug), oppure chiede di correggere un bug partendo dal test, per esempio "prima scrivi un test che riproduce il bug", "fammi vedere il test rosso prima del fix", "voglio un test di regressione per questo errore", "TDD su questo bug", "riproduci il problema con un test". Non usarla per scrivere test su codice che funziona né per aggiungere funzionalità nuove.
---

# Test first

"Mostrare il difetto". Comando: `Test first` o `-TF`, come parola a sé.

Correggi un bug in quest'ordine: prima un test che lo mostra fallendo, poi la correzione, poi lo
stesso test che passa. Il test rosso è la prova che hai capito il bug: se non riesci a farlo
fallire, non sai ancora cosa stai correggendo, e qualunque fix è un tentativo. Il test verde è la
prova che la correzione funziona, e resta nel repo come difesa contro il ritorno del bug.

## Flusso

### 1. Delimita il bug

Scrivi in 2-3 righe: comportamento atteso, comportamento osservato, come si produce (input, passi,
ambiente). Se c'è un messaggio di errore o uno stack trace, parti da lì.

Se manca qualcosa senza cui non puoi riprodurlo (l'input che lo scatena, la versione, i passi),
chiedi solo quello e fermati. Tutto il resto cercalo nel codice.

### 2. Scegli dove e come testare

- **Framework.** Se il progetto ne ha uno, usa quello, nelle sue cartelle e con le sue convenzioni
  (nomi dei file, fixture e helper esistenti). Se non ne ha, proponi in una riga il runner incluso
  nel linguaggio (`unittest`, `node:test`, `go test`) o lo standard dello stack (Vitest con Vite),
  e aspetta l'OK prima di aggiungerlo: un framework è una scelta per tutto il progetto.
- **Livello.** Il più basso che mostra il bug: unit test se il bug sta in una funzione,
  integrazione se sta nell'incontro tra due parti (una query, una chiamata HTTP, un componente con
  il suo store). Più il test è basso, più è veloce e più dice con precisione dove si rompe.
- **Confini.** Simula solo ciò che sta fuori dal processo e non controlli: rete, servizi esterni,
  orologio, numeri casuali. Il codice del progetto gira vero: sostituendolo con un mock rischi di
  testare il mock invece del bug.

### 3. Scrivi il test

- Un test per bug.
- Il nome dice il comportamento atteso, non il bug: `test_total_includes_discount_for_single_item`,
  non `test_bug_123`. Chi lo vedrà fallire tra un anno deve capire cosa si è rotto.
- Usa il caso minimo: il più piccolo input che scatena il bug.
- L'asserzione controlla il valore giusto, quello che l'utente si aspetta, non solo che il codice
  non vada in errore.

### 4. Guardalo fallire, per il motivo giusto

Eseguilo e mostra l'output. Deve fallire sull'asserzione che descrive il bug. Un fallimento per un
import sbagliato, una fixture mancante o un errore di sintassi non conta: sistema il test e
rieseguilo.

Se passa, il bug non è riprodotto. Non correggere niente: o il test non percorre la strada giusta,
o l'ipotesi sul bug è sbagliata. Torna al punto 1 con quello che hai imparato.

Da qui in poi il test non si cambia per farlo passare: si cambia il codice.

### 5. Trova la causa

Il sintomo sta dove il test fallisce, la causa può stare più a monte. Segui il dato fino al punto
in cui diventa sbagliato. Prima di correggere una funzione cerca tutti i suoi chiamanti: se la
causa è in una funzione condivisa, la correzione va lì, una volta sola, e ripara tutti i percorsi.

### 6. Correggi

Il diff più piccolo che corregge la causa, non il sintomo. Niente modifiche estranee al bug nello
stesso diff: confondono la prova rosso-verde. Se vedi altro da sistemare, segnalalo o correggilo a
parte.

### 7. Guardalo passare

Riesegui il test: ora deve passare. Poi esegui i test del modulo toccato, o tutta la suite se è
veloce, per vedere se la correzione ha rotto altro. Se qualcosa si rompe, dillo con l'output.

## Casi difficili

- **Bug non deterministico** (concorrenza, tempo, ordine). Fissa ciò che varia (seed, orologio
  finto, ordine esplicito) finché il test fallisce sempre. Se non ci riesci, eseguilo più volte e
  riporta quante volte fallisce su quante.
- **Bug che un test automatico non raggiunge** (solo in produzione, hardware, resa visiva, servizio
  esterno non simulabile). Dillo. Scrivi la riproduzione più vicina possibile (uno script, i passi
  manuali esatti) e dichiara il fix non verificato da test.
- **Codice senza test e difficile da isolare.** Scrivi prima un test che fissa il comportamento
  attuale attorno al bug (test di caratterizzazione), poi quello del bug: così vedi se la
  correzione cambia anche ciò che doveva restare uguale.
- **Più bug nella stessa segnalazione.** Un ciclo rosso-verde per ciascuno, uno alla volta.
- **Il difetto è in un test esistente, non nel codice.** Dillo e mostra perché, prima di toccarlo.

## Report

Alla fine, in poche righe:

- **Bug:** atteso / osservato.
- **Causa:** dove e perché (`file:riga`).
- **Test:** nome e percorso.
- **Rosso → verde:** le righe essenziali dell'output prima e dopo la correzione.
- **Correzione:** cosa è cambiato.
- **Altri test:** quali, con che esito.
- **Aperto:** cosa resta da fare, se c'è.
