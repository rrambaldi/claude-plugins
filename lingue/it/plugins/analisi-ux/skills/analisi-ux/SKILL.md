---
name: analisi-ux
description: Analisi UX ed estetica di un'applicazione web esistente, con prove raccolte nel browser e nel codice sorgente - flussi, usabilità, accessibilità, colori, tipografia, layout, punti di forza e debolezza, direzioni di restyle e piano di interventi per priorità. Non modifica il codice. Attivala SEMPRE quando l'utente scrive "Analisi UX" o la sigla "-AUX" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti o preceduti da URL, percorso o richiesta), oppure chiede di analizzare, valutare, recensire o fare un audit UX, UI, visivo o estetico di un'app o di un sito web esistente, anche con parole come "cosa non va in questa interfaccia", "è bella questa app?", "sembra datata", "prepara il restyle", "review del design", "controlla l'accessibilità", "perché questa pagina sembra storta". Non usarla per creare interfacce da zero né per applicare modifiche - per implementare un piano già approvato usa applica-restyle.
---

# Analisi UX

"Esame della bellezza". Analizza un'applicazione web esistente come la userebbe una persona reale e restituisce due cose:
un report che distingue ciò che è misurato da ciò che è opinione, e un piano di restyle che
conserva ciò che funziona. Il valore della skill non sta nell'elencare principi (Nielsen, WCAG,
griglia a 8px: li conosci già) ma nella disciplina con cui li applichi: prove prima dei giudizi,
nessun numero senza base, nessun rilievo generico.

**Questa skill non modifica codice, configurazioni o dati.** L'implementazione è compito di
`applica-restyle`, dopo l'approvazione esplicita del piano.

## Comando e livelli

`Analisi UX` o `-AUX`. La sigla vale solo come parola a sé con il trattino (a inizio o fine
messaggio, o da sola), non quando "ID" compare nel testo, per esempio negli ID dei rilievi.

| Richiesta | Livello | Copertura |
|---|---|---|
| "-AUX rapida", "dai un'occhiata veloce" | Rapido | 1 flusso principale, viewport 390 e 1440, nessuno scenario di stress |
| "-AUX" o richiesta generica | Standard (default) | Flussi prioritari, 4 viewport, scenari di stress pertinenti |
| "-AUX completa", "audit completo" | Completo | Tutte le pagine, tutti gli scenari di `references/scenari.md` |

Se l'utente chiede solo un aspetto ("solo i colori", "solo l'accessibilità"), fai un'analisi
mirata con gli stessi principi e salta le sezioni non pertinenti, dichiarandolo in una riga.

## Principi

1. **Prova prima del giudizio.** Ogni rilievo che pesa sulla decisione porta un'etichetta:
   - `[M]` misurato con uno strumento (stili calcolati, axe-core, console, metriche di performance);
   - `[V]` visto durante l'interazione o in uno screenshot a una viewport precisa;
   - `[C]` letto nel codice, con `file:riga`;
   - `[S]` stimato da un'immagine (colori, dimensioni): approssimativo, da confermare;
   - `[P]` preferenza estetica ragionata, non un difetto;
   - `[?]` non verificato, con il motivo.

   Metti la legenda una sola volta, in testa al report. Il motivo: un report che mescola misure e
   gusti porta a correggere preferenze come se fossero bug, e a ignorare bug scambiati per gusti.

2. **Niente numeri inventati.** Codici colore, rapporti di contrasto, dimensioni e tempi si
   riportano solo se misurati; se stimati da immagine vanno marcati `[S]`. Non assegnare voti
   1-10, percentuali o punteggi sommati: nascondono i problemi gravi dentro una media. Usa la
   scala qualitativa della sezione "Giudizio".

3. **Nessuna quota.** Non produrre "5-7 punti di forza" o "almeno 3 direzioni": elenca ciò che
   regge. Dieci rilievi specifici valgono più di trenta, di cui venti validi per qualunque app.

4. **Correzione minima concreta.** Ogni rilievo indica l'intervento più piccolo che lo risolve,
   con valori o regole ("`--text-muted` da #9CA3AF a #6B7280 su #FFFFFF: 4.83:1"), mai
   "migliorare il contrasto" o "valutare di…".

5. **Proteggi ciò che funziona.** Un restyle che distrugge abitudini e pattern riusciti fa
   pagare agli utenti il gusto del designer. I punti di forza vanno nell'elenco "Da non toccare"
   del piano, che `applica-restyle` rispetterà.

6. **Il compito è il protagonista.** In una pagina di lavoro (login, form, tabella, dashboard)
   l'elemento più forte deve essere il compito dell'utente, non il marchio, un'illustrazione o un
   effetto. In un gestionale conta la velocità di lettura e di ripetizione più dello stupore.

7. **Estetica come identità, non come moda.** L'estetica "da AI" (Inter ovunque, sfumature
   viola, card identiche con bordo colorato a sinistra, emoji come icone, griglie e bagliori
   decorativi) è un problema perché cancella l'identità del prodotto, non perché è brutta. Se il
   marchio usa davvero uno di questi elementi, allora è firma e non difetto. Dettagli in
   `references/criteri-visivi.md`.

8. **Verità dei contenuti.** Non proporre metriche, testimonianze, loghi di clienti o dati
   operativi inventati per rendere un layout credibile. Un segnaposto onesto è meglio di un dato
   finto.

9. **Sicurezza durante il percorso.** Usa un account di test e, se possibile, un ambiente di
   staging. Non eseguire azioni irreversibili (eliminare, inviare, pagare, pubblicare,
   condividere) su dati reali senza consenso esplicito: in quel caso osserva la conferma e fermati
   prima dell'ultimo clic. Non salvare credenziali nel report.

## Flusso

Quattro turni, e alla fine di ciascuno ti fermi: in una sola risposta le ultime fasi (sintesi,
direzioni, piano) escono compresse, e sono quelle che l'utente userà. La pausa serve anche a
correggere persona e flussi prima che il resto dell'analisi li dia per buoni.

| Turno | Fasi | Chiusura |
|---|---|---|
| 1 | 0 Cancello, 1 Ricognizione | *"Scrivi **prosegui** per il percorso nel browser, oppure correggi flussi e persona."* |
| 2 | 2 Percorso nel browser | *"Scrivi **prosegui** per le misure e l'analisi visiva."* |
| 3 | 3 Misure, 4 Analisi visiva | *"Scrivi **prosegui** per sintesi, direzioni e piano."* |
| 4 | 5 Sintesi, 6 Autocritica, 7 Consegna | la chiusura della Fase 7 |

A ogni turno scrivi nel report (`docs/ux/analisi-AAAA-MM-GG.md`) quello che il turno ha trovato e
aggiorna la riga **Stato** in testa: il lavoro fatto è nel file, non solo nella conversazione. Se
in `docs/ux/` c'è già un report con uno stato intermedio, chiedi se riprenderlo dal turno dopo.

Al livello rapido i turni 2-4 sono uno solo, e se persona e flusso sono già chiari anche il primo:
dichiara le assunzioni in testa al report. Se l'utente chiede tutto in un turno, fai le fasi di
fila.

### Fase 0: Cancello

Raccogli ciò che serve, usando quello che già sai dalla conversazione e dal repository invece di
chiederlo di nuovo:

- URL e ambiente (produzione o staging), credenziali di test se serve il login;
- percorso del repository;
- chi usa l'app e per fare cosa (la **persona**: ruolo, dimestichezza con la tecnologia, fretta,
  dispositivo). Senza una persona i rilievi scivolano verso il generico;
- i 2-4 flussi che contano di più;
- vincoli: marchio da rispettare, stack da non cambiare, pagine escluse.

Se manca qualcosa che cambierebbe le conclusioni (persona, flussi, accesso), fai al massimo 4
domande in un solo messaggio e fermati. Altrimenti dichiara le assunzioni e procedi.

Verifica anche gli strumenti: browser disponibile (Playwright MCP, Claude in Chrome, browser
integrato o altro) e capacità di eseguire JavaScript nella pagina. Se manca ma c'è Node, proponi il
ripiego headless di `references/prove-browser.md` §8: scarica Playwright e Chromium, quindi serve
il consenso. Senza consenso, senza Node o senza un URL raggiungibile, dillo: l'analisi diventa
statica (codice e screenshot forniti) e ogni conclusione visiva sarà `[S]` o `[?]`.

### Fase 1: Ricognizione del codice

Senza modificare nulla, ricava dal repository:

- stack, librerie UI, icone, sistema di stili (CSS variables, Tailwind config, tema);
- **inventario pagine e flussi** dalle rotte;
- token e design system esistenti, anche impliciti (colori e spaziature più ricorrenti);
- componenti riusati e duplicati (per esempio tre varianti di bottone).

Poi presenta in forma breve: persona, flussi scelti, inventario, livello di analisi, strumenti
disponibili, assunzioni e dove salverai il report. La pausa costa un messaggio; un percorso nel
browser sui flussi sbagliati costa tutta l'analisi.

### Fase 2: Percorso nel browser

Per ogni flusso scelto, usa l'app come la persona: digita testo reale, attiva l'azione primaria,
apri dettagli e modali, verifica lo stato dopo l'azione (campo svuotato, messaggio di conferma,
lista aggiornata, cambio di rotta). Dopo ogni azione principale leggi la console e le richieste di
rete.

Tieni un **registro delle prove**: una riga per azione, con ora, cosa hai fatto, dove (selettore o
etichetta) e cosa hai osservato. Un giudizio su un flusso che non hai percorso vale `[?]`: senza
registro, il verdetto dell'analisi è **Incompleto**.

Applica lo **sguardo del nuovo utente**: si riesce a completare il compito senza sapere come è
fatto il codice? Etichette in lingua dell'utente o gergo interno (`slug`, `agentClass`)? Menu che
mostrano cosa fa ogni opzione o solo un codice?

Poi gli scenari di stress pertinenti al livello, da `references/scenari.md`.

Procedure, viewport e comandi: `references/prove-browser.md`.

### Fase 3: Misure

Esegui le misure automatiche descritte in `references/prove-browser.md`, sulle pagine dei flussi:

- contrasto calcolato sugli stili reali con `scripts/misure.js`;
- accessibilità con axe-core, se caricabile;
- overflow orizzontale e testo tagliato a ogni viewport;
- metriche di caricamento (LCP, CLS) su una pagina rappresentativa;
- errori e warning in console, risposte 4xx/5xx.

### Fase 4: Analisi visiva ed estetica

Usa `references/criteri-visivi.md`. Tieni separati tre piani, perché richiedono rimedi diversi:

1. **Difetti oggettivi:** contrasto, incoerenze tra componenti, stati mancanti, rotture responsive.
2. **Qualità della composizione:** gerarchia, protagonista, uso dello spazio, ritmo, densità.
3. **Carattere e identità:** l'app è riconoscibile o potrebbe essere di chiunque? È adatta al
   dominio? Qui i giudizi sono `[P]` e vanno motivati.

Estrai la palette e la scala tipografica reali (dal codice e dagli stili calcolati, non a occhio),
con il ruolo di ciascun valore.

### Fase 5: Sintesi e direzioni

- **Punti di forza:** cosa funziona e perché. Diventano l'elenco "Da non toccare".
- **Rilievi:** nel formato di `references/modello-report.md`, con la scala di severità qui sotto.
- **Giudizio per dimensione** (sezione "Giudizio").
- **Direzioni di restyle:** di norma due, *conservativa* (stessa struttura, sistema visivo
  ripulito) e *trasformativa* (composizione ripensata dove l'audit lo giustifica). Proponine una
  terza solo se cambia davvero il rapporto con l'utente. Due direzioni che differiscono solo per
  la palette non sono due direzioni. Per ciascuna: personalità in poche parole, palette con ruoli
  e contrasti verificati, font e scala, spaziatura, raggi, superfici, icone, movimento, una
  pagina reale descritta "prima e dopo", compromessi e rischi.
- **Piano per fasi:** interventi rapidi (ore), restyle del sistema visivo (token e componenti),
  interventi strutturali (layout e flussi). Ogni voce richiama gli ID dei rilievi.

### Fase 6: Autocritica

Prima di consegnare, rileggi i rilievi e per ciascuno decidi: TENERE (specifico di questa app,
persona e pagina), GENERICO (varrebbe per qualunque app) o DUPLICATO (stessa causa di un altro).
Elimina generici e duplicati. Se puoi lanciare un subagente, affidagli questo passaggio con il solo
elenco dei rilievi: chi li ha scritti tende a difenderli. Registra il conteggio nel report
("Rilievi scritti: 23, tenuti: 14, generici: 5, duplicati: 4").

### Fase 7: Consegna

Nel repository restano due file, nella posizione detta al turno 1 (non committare senza consenso):

- `docs/ux/analisi-AAAA-MM-GG.md`: il report, ora con **Stato: completo**;
- `docs/ux/piano-restyle.md`: il contratto per `applica-restyle`.

Modelli di entrambi in `references/modello-report.md`.

In chat scrivi solo: verdetto, dimensione più debole con la sua prova, i 3 interventi a maggior
impatto, cosa non è stato possibile verificare, e dove sono i file. Chiudi chiedendo quale
direzione adottare e se approvare il piano, fase per fase, per passarlo a *Applica restyle* (`-AR`).

## Severità

Una sola scala per tutto il report:

| Livello | Significato | Esempi |
|---|---|---|
| **Critica** | Impedisce il compito, perde dati o esclude utenti | errore in console che blocca il salvataggio, risposta 5xx, violazione axe Critical, campo irraggiungibile da tastiera |
| **Alta** | Il compito riesce con fatica o con errori probabili, o l'aspetto sembra rotto | contrasto sotto soglia su testo di lavoro, layout che collassa a 768px, azione distruttiva senza conferma, violazione axe Serious |
| **Media** | Frizione o aspetto poco curato | spaziature incoerenti, tre stili di bottone, stato vuoto muto, icone di famiglie diverse |
| **Bassa** | Rifinitura | 1-2px di allineamento, ombra troppo forte, transizione brusca |

Errori in console, 5xx e violazioni axe Critical sono Critica per definizione; non esiste un
"errore di console di severità media".

## Giudizio

Valuta queste dimensioni su quattro livelli: **Rotto**, **Usabile** (funziona ma è generico o
irrisolto), **Solido**, **Eccellente**. Non sommare e non fare medie: **decide la dimensione più
debole**, perché un'app bellissima con un form inaccessibile non è pronta.

- chiarezza del compito (in 5 secondi si capisce cos'è, per chi, cosa fare);
- qualità del percorso (flussi completabili, errori recuperabili);
- accessibilità;
- coerenza del sistema visivo (componenti, token, stati);
- resistenza responsive e ai dati reali (0, 1, molti elementi; testi lunghi);
- carattere e adeguatezza al dominio.

**Verdetto** dell'app:

- **Pronta:** nessuna Critica né Alta, tutte le dimensioni almeno Solido;
- **Pronta con riserve:** nessuna Critica né Alta e nessuna dimensione Rotta, ma restano rilievi
  Medi o Bassi o dimensioni solo Usabili;
- **Non pronta:** almeno una Critica o Alta, oppure una dimensione Rotta;
- **Incompleto:** registro delle prove assente o flussi prioritari non percorsi. Non si può
  promuovere a "Pronta" perché "sembrava tutto a posto".

## Chiusura del report

Termina con un paragrafo libero, senza schema: *se questa app fosse un oggetto fisico, vorresti
tenerlo in mano?* È l'unico punto in cui l'impressione d'insieme è lo scopo, e serve a cogliere
ciò che nessuna checklist vede. Marcalo `[P]`.

## Riferimenti

| Quando | Leggi |
|---|---|
| Fase 2 e 3: browser, viewport, registro, misure, ripiego headless, assenza di browser | `references/prove-browser.md` |
| Fase 2: scenari di stress e sguardo per dominio | `references/scenari.md` |
| Fase 4: criteri visivi, estetica, catalogo dei cliché | `references/criteri-visivi.md` |
| Fase 5 e 7: formato dei rilievi, report, piano per applica-restyle | `references/modello-report.md` |
| Misure automatiche nel browser | `scripts/misure.js` |
| Screenshot e misure senza browser MCP | `scripts/headless.cjs` |

## Formato

- Rispondi nella lingua dell'utente, di default in italiano.
- Nessun ruolo dichiarato ("come team di esperti…"), nessuna introduzione di cortesia.
- Tabelle solo per confrontare più elementi su più attributi.
