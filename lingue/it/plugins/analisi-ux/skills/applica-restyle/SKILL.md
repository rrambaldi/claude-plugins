---
name: applica-restyle
description: Implementa nel codice un restyle o redesign già approvato di un'applicazione web esistente, fase per fase, partendo dal piano prodotto da analisi-ux (docs/ux/piano-restyle.md) - token di design, componenti, stati, layout - e verifica ogni intervento nel browser con le stesse misure dell'analisi. Attivala SEMPRE quando l'utente scrive "Applica restyle" o la sigla "-AR" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti o preceduti dalla richiesta), oppure chiede di applicare, implementare o eseguire il restyle, il piano di restyle, le correzioni dell'audit UX o una direzione visiva scelta, per esempio "applica la fase 1", "implementa i quick win dell'audit", "passa ai nuovi token", "sistema i rilievi A1-A5". Non usarla per analizzare un'interfaccia (usa analisi-ux) né per creare da zero un'app o una pagina senza un'interfaccia esistente.
---

# Applica restyle

"Segui la bellezza". Comando: `Applica restyle` o `-AR`, come parola a sé.

Applica al codice un piano di restyle approvato, un pezzo alla volta, e dimostra che ogni pezzo
funziona. La difficoltà di un restyle non è scrivere CSS: è non rompere ciò che funziona, non
scivolare verso un'estetica generica e non dichiarare "fatto" senza averlo visto nel browser.

## Cosa serve prima di iniziare

1. **Il piano.** Cerca `docs/ux/piano-restyle.md` (o il percorso indicato dall'utente). È il
   contratto: interventi con ID, criteri di accettazione, elenco "Da non toccare", vincoli, token
   proposti, fasi.
   - Se non c'è, proponi di eseguire prima *Analisi UX* (`-AUX`). Per una richiesta piccola e precisa
     ("correggi il contrasto dei link") puoi procedere senza, ma scrivi prima una mini-scheda
     (problema, correzione, criterio di accettazione, cosa non tocchi) e falla approvare.
2. **L'approvazione.** Esegui solo le fasi approvate esplicitamente dall'utente. Se il piano dice
   "da approvare" o la direzione è "da scegliere", presenta in breve la scelta e fermati.
3. **Il repository pulito.** Controlla `git status`. Con modifiche non committate dell'utente,
   fermati e chiedi. Proponi un branch dedicato (per esempio `restyle/fase-1`); crealo solo con il
   consenso.

I percorsi `../analisi-ux/…` puntano alla skill gemella dello stesso plugin. Se non sono
raggiungibili, applica gli stessi controlli a mano e dillo nel rapporto.

## Principi

1. **Il piano comanda, "Da non toccare" è un vincolo.** Non intervenire su elementi di quell'elenco
   né su pagine escluse, anche se ti sembrano migliorabili. Se un intervento li coinvolge per
   forza, fermati e chiedi. Aggiungere interventi fuori piano è una scelta dell'utente: proponili in
   fondo al rapporto, non eseguirli.

2. **Restyle sul posto.** Mantieni stack, librerie, struttura delle rotte e pattern locali.
   Nessuna nuova dipendenza senza consenso. Nessuna riscrittura da zero di pagine che il piano non
   mette nella fase strutturale.

3. **Prima i token, poi i componenti, poi le pagine.** Codifica colori, tipografia, spaziature,
   raggi, ombre e durate come variabili o configurazione del tema, poi fai usare i token ai
   componenti condivisi, infine sistema i casi particolari. Correggere una pagina alla volta con
   valori scritti a mano crea la stessa incoerenza che il restyle doveva togliere.

4. **Stati reali.** Ogni componente toccato ha i suoi stati: hover, focus visibile, attivo,
   disabilitato, caricamento, errore, vuoto, dove pertinenti. Le dimensioni restano stabili quando
   cambia lo stato. Lo stato non dipende dal solo colore.

5. **Niente estetica generica, niente contenuti finti.** Valgono le regole di
   `../analisi-ux/references/criteri-visivi.md` §10: nessun cliché decorativo non giustificato, colori
   dal marchio o dai token approvati e non inventati sul momento, nessuna metrica, testimonianza o
   dato inventato per riempire uno spazio. Un segnaposto onesto è meglio.

6. **Movimento sobrio.** Solo transform e opacity, durate brevi, nessuna animazione continua senza
   scopo, rispetto di `prefers-reduced-motion`, pulizia di listener e observer.

7. **Accessibilità non negoziabile.** Contrasto misurato sui colori finali, semantica corretta,
   nomi accessibili per i controlli con sola icona, ordine di focus logico, bersagli adeguati.

8. **Nessuna verifica immaginaria.** "Fatto" vuol dire: modificato nel codice. "Verificato" vuol
   dire: controllato nel browser con il criterio di accettazione del piano. Se il browser non è
   disponibile, lo stato resta "fatto" e consegni all'utente le verifiche manuali da eseguire.

## Flusso per ogni fase

1. **Annuncia la fase.** ID degli interventi, file che prevedi di toccare, rischi di regressione
   (quali pagine usano i componenti che cambi: cercale nel codice).
2. **Implementa** nell'ordine token → componenti → pagine, riusando ciò che esiste.
3. **Verifica.** Per ogni intervento applica il suo criterio di accettazione:
   - apri le pagine coinvolte nel browser alle viewport indicate dal piano (di norma 390, 768,
     1440, 1920; aggiungi 2560 per layout a tutta larghezza);
   - rifai l'interazione che aveva fatto emergere il problema, con uno screenshot nuovo;
   - riesegui le misure con `../analisi-ux/scripts/misure.js` (contrasto, overflow, bersagli) e, se
     disponibile, axe-core come descritto in `../analisi-ux/references/prove-browser.md`;
   - leggi la console: nessun errore o warning nuovo;
   - controlla anche le pagine che condividono i componenti modificati, non solo quella del
     rilievo: è lì che nascono le regressioni.
4. **Controlli non compensabili.** La fase non è conclusa se c'è anche uno solo di questi:
   scorrimento orizzontale, testo tagliato o sovrapposto, focus invisibile, contrasto sotto soglia,
   errori in console, un elemento "Da non toccare" cambiato, un'azione primaria non visibile a
   390×844 in un compito breve. Correggi e riverifica prima di andare avanti.
5. **Aggiorna il piano.** In `docs/ux/piano-restyle.md` imposta lo stato di ogni ID: `fatto`,
   `verificato`, `ancora presente`, `nuovo problema` (con descrizione), `rinviato` (con motivo).
6. **Commit** solo con il consenso dell'utente, uno per fase o per gruppo coerente, con gli ID nel
   messaggio (per esempio `restyle fase 1: A3 A4 M2 token testo e focus`).
7. **Rapporto e pausa.** In chat: cosa è stato fatto, cosa è verificato e come, cosa resta
   aperto, eventuali nuovi problemi, file toccati. Poi chiedi se procedere con la fase successiva.
   Non concatenare fasi senza approvazione: ogni fase cambia ciò che l'utente vede e deve poterla
   provare.

## Alla fine del piano

- Proponi di copiare in `CLAUDE.md` o `AGENTS.md` le "Regole anti-regressione" del piano, così
  il lavoro futuro rispetta il nuovo sistema. Scrivi solo con il consenso.
- Proponi una nuova *Analisi UX* rapida (`-AUX rapida`) sui flussi principali, per confermare
  il risultato con occhi nuovi.

## Formato

- Rispondi nella lingua dell'utente, di default in italiano.
- Nessuna introduzione di cortesia; rapporti brevi, con i dettagli nel file del piano.
