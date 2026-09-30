# Criteri visivi ed estetici

Cosa controllare nella Fase 4. Non è una lista da riempire: segnala solo ciò che trovi, con la
prova. Le soglie numeriche sono punti di riferimento comuni, non leggi; quando una scelta del
progetto è coerente e motivata, prevale sulla soglia generica.

## Indice

1. Test rapidi
2. Layout e spaziatura
3. Tipografia
4. Colore e contrasto
5. Gerarchia e composizione
6. Coerenza dei componenti
7. Stati e interazione
8. Testi dell'interfaccia
9. Responsive
10. Carattere, identità e cliché

## 1. Test rapidi

- **5 secondi.** Guardando la pagina per 5 secondi: cos'è, di chi è, a cosa serve, qual è la
  prossima azione? Se decorazione, logo o un titolo enorme ritardano la risposta su una pagina di
  lavoro, è un problema di composizione.
- **Occhi socchiusi.** Sfocando lo screenshot, l'elemento che resta dominante è quello giusto?
  Se tutto pesa uguale, la gerarchia manca.
- **Scambio di settore.** Sostituendo il nome del prodotto con quello di un'azienda di un altro
  settore, la pagina reggerebbe identica? Se sì, manca identità di dominio.
- **"Sembra storto".** Di solito sono le spaziature: controlla prima margini e padding.

## 2. Layout e spaziatura

- Scala di spaziatura riconoscibile (per esempio 4/8/12/16/24/32) invece di valori sparsi
  (13px, 27px): verificalo con i valori reali del codice.
- Stesso spazio tra elementi dello stesso tipo; allineamenti a sinistra coerenti tra sezioni.
- Griglia leggibile; proporzioni sidebar/contenuto intenzionali a ogni larghezza.
- Spazio vuoto che incornicia il contenuto, non vuoto casuale o intrappolato.
- Su schermi larghi: contenuto a larghezza fissa isolato in mezzo al vuoto; divisori a tutta
  altezza che separano un pannello di lavoro da una zona decorativa senza funzione.

## 3. Tipografia

- Gerarchia chiara h1 → h2 → h3 → testo, con una scala coerente e poche dimensioni.
- Testo corrente 45-75 caratteri per riga; interlinea circa 1.5 per il testo, 1.1-1.3 per i titoli.
- Pesi con un ruolo (regolare per il testo, medio per le etichette, semibold per i titoli),
  non tutto grassetto né tutto regolare.
- Troncamenti con ellissi e testo completo accessibile; nessun testo che esce dal contenitore.
- Numeri in tabelle con cifre tabulari se la famiglia le offre.
- Famiglie: massimo due o tre; conta se danno carattere al prodotto, non se sono "di moda".

## 4. Colore e contrasto

- Contrasto misurato: 4.5:1 testo normale, 3:1 testo grande ed elementi grafici di interfaccia
  (bordi dei campi, icone che trasmettono significato, indicatore di focus).
- Colori per ruolo (sfondo, superficie, bordo, testo, testo attenuato, primario, stati) e non
  valori sparsi: nel codice, token o classi semantiche invece di colori grezzi ripetuti.
- Stesso colore = stesso significato ovunque (il blu non può essere "cliccabile" in una pagina e
  "informativo" in un'altra).
- Colori di stato coerenti; il significato non dipende dal solo colore (icona o testo accanto).
- Poche tinte più i neutri; neutri leggermente caldi o freddi coerenti con il primario.
- Modalità scura, se esiste: nessun elemento invisibile, bordi definiti, valori scuri che non
  collassano tra loro.

## 5. Gerarchia e composizione

- Un'azione primaria per area, visivamente dominante; le altre chiaramente secondarie.
- **Protagonista:** il login mette in primo piano l'autenticazione, la dashboard lo stato e le
  azioni, la pagina prodotto il prodotto. Marchio, illustrazioni ed effetti non pesano più del
  compito.
- Ogni grande regione della pagina ha un ruolo: funzionale, di prova, narrativo o percettivo.
- Rivelazione progressiva: l'essenziale visibile, i dettagli su richiesta.
- Raggruppamento per vicinanza prima che per bordi e sfondi.

## 6. Coerenza dei componenti

- Bottoni: una variante primaria, una secondaria, una distruttiva, usate con coerenza.
- Campi: stessa altezza, stesso bordo, stesso anello di focus.
- Card solo quando delimitano un oggetto reale; niente card dentro card.
- Una sola famiglia di icone, con dimensione e tratto coerenti; bottoni con sola icona dotati di
  nome accessibile.
- Raggi di bordo per ruolo (per esempio campi 4px, card 8px, modali 12px), non valori casuali.
- Uno o due livelli d'ombra, con una sola logica di luce.
- Il sintomo più comune nelle interfacce costruite dagli sviluppatori è proprio l'incoerenza tra
  componenti simili: conta le varianti con `uxMisure.palette()` e `uxMisure.tipografia()`.

## 7. Stati e interazione

- Per i componenti chiave: predefinito, hover, focus, attivo, disabilitato, caricamento, vuoto,
  errore, successo; dove serve anche permesso negato, offline, sessione scaduta.
- Focus visibile sullo sfondo reale; elemento attivo della navigazione distinguibile.
- Transizioni brevi (circa 150-250 ms, uscita più rapida dell'entrata), su transform e opacity;
  nessuna animazione continua senza scopo; rispetto di `prefers-reduced-motion`.
- Dimensioni stabili quando cambiano etichette, caricamenti o messaggi di validazione (niente
  salti di layout).
- Scheletri o indicatori durante i caricamenti; contenuto che non "salta dentro" all'improvviso.

## 8. Testi dell'interfaccia

- Etichette sopra i campi, persistenti; il placeholder è un esempio, non un'etichetta.
- Verbi precisi sui bottoni ("Salva fattura", "Invia richiesta") invece di "OK", "Invia", "Continua"
  quando esiste un verbo migliore.
- Errori che dicono cosa è successo e come rimediare, vicino al campo.
- Stati vuoti che spiegano come procedere.
- Lingua dell'utente, senza codici interni o gergo tecnico.
- Nessuna nota di prototipo o istruzione per sviluppatori visibile agli utenti.

## 9. Responsive

- Navigazione mobile deliberata (menu o foglio a comparsa), non la barra desktop compressa.
- Tabelle: scorrimento orizzontale dichiarato o trasformazione in elenco su mobile.
- Nessuno scorrimento orizzontale della pagina; nessuna navigazione che va a capo per caso.
- Immagini proporzionate, con dimensioni riservate.
- Nei compiti brevi (login, ricerca, pagamento) campi e azione primaria visibili a 390×844.

## 10. Carattere, identità e cliché

Qui i giudizi sono `[P]`. Chiediti se l'interfaccia è riconoscibile, adatta al dominio, fatta per
queste persone. Attenzione: "rendere più moderno" non è un rilievo; lo è indicare quali proprietà
cambiare, perché e con quali valori.

**Cliché dell'estetica generica da AI.** Il problema non è che siano brutti, ma che sono la media
di tutto ciò che esiste, e quindi non comunicano nessun marchio:

| Elemento | Perché è un cliché | Quando è legittimo |
|---|---|---|
| Sfumature viola o indaco su bianco | Formula "tecnologica" di ogni landing SaaS | Il marchio le usa davvero |
| Inter, Roboto, Arial o font di sistema come carattere di display | Nessun segnale di progetto | Il marchio le prevede; nel testo corrente di un gestionale sono spesso una scelta sensata |
| Card arrotondate identiche con bordo colorato a sinistra | Combinazione ormai rumore visivo | Richiesta esplicita o linee guida del marchio |
| Emoji come icone | Sostituto di un sistema di icone | Pubblico e tono che lo giustificano, o marchio che le usa |
| Illustrazioni SVG di persone o oggetti fatte a mano dall'AI | Proporzioni sbagliate, aspetto amatoriale | Quasi mai: meglio immagini reali o un segnaposto onesto |
| Fondo blu notte con accenti neon, finti terminali | Estetica "developer" copiata | Strumenti per sviluppatori con un marchio che va in quella direzione |
| Griglie, particelle, bagliori, vetro, rumore, bento, titoli giganti usati come decorazione | Atmosfera senza contenuto | Uno solo è tollerabile se coerente; due richiedono un ruolo visibile ciascuno; tre o più indicano che la composizione va ripensata |
| Numeri, icone o statistiche decorative ovunque | Riempitivo che imita la sostanza | Quando sono dati veri che l'utente usa |

**Cosa dà carattere invece:** una tipografia scelta per il contenuto; colori presi dal marchio o
derivati in modo coerente (per esempio in `oklch`), non inventati sul momento; un solo elemento
distintivo legato al soggetto, curato più degli altri; dettagli tipografici puliti (a capo
deliberati, `text-wrap: pretty` sui titoli); densità adatta al lavoro reale.

Quando suggerisci riferimenti ("come Linear per la densità"), spiega quale proprietà prendere e
perché, altrimenti il riferimento spinge verso un'altra estetica generica.
