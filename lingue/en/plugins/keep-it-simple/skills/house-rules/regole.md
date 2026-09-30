<!-- armamentarium:inizio · blocco generato dal plugin armamentarium: non modificarlo qui, le regole del progetto vanno fuori dal blocco -->
## Regole per il codice

Quando due regole tirano in direzioni opposte, vince quella che viene prima:

1. **Capire il problema**: leggi il codice che la modifica tocca e segui il flusso vero, da capo a fondo.
2. **Sicurezza e dati**: validazione ai confini di fiducia, errori gestiti dove si perdono dati, controlli di accesso e permessi, segreti fuori dal codice, accessibilità, tutto ciò che l'utente ha chiesto esplicitamente.
3. **Niente duplicati**, di codice o di forme di dati: una funzione chiamata da due punti batte sempre la copia.
4. **YAGNI**: niente di speculativo, niente astrazioni non richieste (un'interfaccia con una sola implementazione, una factory per un solo prodotto, una config per un valore che non cambia).
5. **Il diff più corto** che corregge la causa, non il sintomo.

Prima di scrivere, fermati al primo gradino che regge: serve davvero? C'è già nel progetto? Lo fa la libreria standard, la piattaforma o una dipendenza già installata? Basta una riga? Solo allora, il minimo che funziona.

- Segui il progetto: nomi, cartelle, stile degli errori; linter e formatter girano prima di dire finito.
- Un valore che indica uno stato, un tipo, un ruolo o una chiave diventa una costante o un enum, anche se oggi compare una volta. Ciò che cambia tra ambienti (URL, host, chiavi) sta in variabili d'ambiente o nella config.
- Mai errori ingoiati: niente `catch {}` vuoti né `except: pass`.
- Il codice sostituito si cancella, non si commenta. Niente avanzi: output di debug, import e variabili inutili.
- La logica non banale (un ramo, un ciclo, un parser, soldi o sicurezza) lascia un test, il più piccolo che fallisce se la logica si rompe, con il framework del progetto. Se il progetto non ne ha uno, proponilo e aggiungilo solo dopo l'OK.
- Un bug si corregge partendo da un test che lo riproduce e fallisce; poi la correzione alla causa; poi lo stesso test, verde.
- Un diff di codice sopra le 50 righe o i 3 file, o che tocca soldi, dati o sicurezza, prima della consegna lo rivede un subagente che non l'ha scritto, con solo il task e il diff.
- In un commit vanno solo i file del task, e nessun segreto.
<!-- armamentarium:fine -->
