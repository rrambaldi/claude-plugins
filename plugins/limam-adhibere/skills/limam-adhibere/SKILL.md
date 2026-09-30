---
name: limam-adhibere
description: >-
  Pensiero critico e laterale su un'idea, un progetto o qualunque cosa: pregi, difetti,
  alternative, ipotesi, rischi e criteri per proseguire o abbandonare. Solo analisi: niente
  codice, file o piani. Attivala SEMPRE quando l'utente scrive "Limam adhibere" o "-LA" (analisi
  completa), "Celeri lima adhibita" o "-CLA" (rapida: 5 pregi, 5 difetti, 5 miglioramenti, 5
  pensieri laterali), "Advocatus diaboli" o "-AD" (solo contro: il caso più forte per non
  farlo): con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti o preceduti
  dal testo.
  Attivala anche quando l'utente chiede esplicitamente di analizzare o valutare criticamente
  un'idea, di trovarne pro e contro, di metterla alla prova o di fare l'avvocato del diavolo, per
  esempio "analizza questa idea", "questa idea sta in piedi?", "valuta criticamente questo
  progetto", "smontala". Non usarla per domande tecniche puntuali, né per scrivere piani d'azione
  o codice. Per un'analisi SWOT usa intus-et-extra.
---

# Limam adhibere

"Passare la lima": sottoporre un'idea al lavoro critico che la rende solida, o ne mostra i limiti,
prima che costi tempo e denaro. Lo scopo non è confermare l'idea ma produrre uno strumento per
decidere.

## Comandi

| Comando | Sigla | Modalità |
|---|---|---|
| Limam adhibere | -LA | Analisi completa in tre blocchi |
| Celeri lima adhibita | -CLA | 5 pregi, 5 difetti, 5 miglioramenti, 5 pensieri laterali, in un turno |
| Advocatus diaboli | -AD | Solo contro: assunzioni nascoste, pre-mortem, obiezione più forte |

Le sigle valgono quando compaiono come parola a sé (a inizio o fine messaggio, o da sole), non
quando fanno parte di un'altra parola.

## Solo pensiero critico

Con -LA, -CLA e -AD si pensa e basta. Non scrivere codice, non creare né modificare file, non scrivere
piani: niente fasi, calendari o liste di cose da fare. Se l'idea riguarda un software, analizzala
senza implementarne nessuna parte. Se l'utente vuole passare all'azione, lo chiederà dopo, fuori
da questa skill.

## Flusso

1. **Trova l'idea.** Può essere nel messaggio insieme al comando, in un file allegato o nei
   messaggi precedenti. In quest'ultimo caso usa l'ultima idea discussa e dichiarala in una riga.
   Se non c'è nessuna idea, chiedila, proponi il modello di input qui sotto e fermati.
2. **Passa dal cancello iniziale** (sezione dedicata).
3. **Svolgi l'analisi in tre blocchi, un turno per blocco**, fermandoti alla fine di ciascuno.
   Il motivo è pratico: in una sola risposta le ultime sezioni (rischi, criteri, decisione) vengono
   compresse, e sono proprio quelle che servono di più. La pausa tra i blocchi permette inoltre
   all'utente di correggere le assunzioni prima che si propaghino.

Varianti:
- **Rapida**: se l'utente scrive "Celeri lima adhibita" o "-CLA", o chiede comunque una versione
  breve, fai un solo turno: 5 pregi, 5 difetti, 5 miglioramenti, 5 pensieri laterali (sezione
  "Modalità rapida").
- **Avvocato del diavolo**: se l'utente scrive "Advocatus diaboli" o "-AD", o chiede di smontare
  l'idea, fai un solo turno di soli contro (sezione "Advocatus diaboli").
- **Tutto in un turno**: se l'utente lo chiede esplicitamente, esegui i tre blocchi di fila in
  forma compatta.

### Modello di input

Proponilo quando l'idea manca o è troppo scarna:

```
Idea: [cosa è, per chi, quale problema risolve]
Obiettivo: [reddito, prodotto, progetto aziendale, uso interno, personale...]
Risorse: [tempo settimanale, budget, competenze, contatti, asset già disponibili]
Mercato/area: [paese, settore, B2B/B2C]
Vincoli: [scadenze, normative, tecnologie obbligate o escluse]
Già fatto: [ricerche, prototipi, conversazioni con potenziali clienti...]
```

## Principi

1. **Critica indipendente.** Non dare per scontato che l'idea sia valida, originale o vendibile,
   e non cercare di compiacere. Una valutazione indulgente fa perdere mesi, una critica fondata
   costa qualche minuto di fastidio. Critico non vuol dire distruttivo: per ogni problema cerca
   cosa lo risolverebbe (tranne in -AD, dove le soluzioni spettano all'utente).

2. **Stato epistemico esplicito.** Per le affermazioni da cui dipende una conclusione usa
   etichette inline:
   - `[F]` fatto verificato (con fonte, se esterno)
   - `[I]` ipotesi da dimostrare
   - `[S]` stima su dati incompleti, con la base su cui poggia
   - `[O]` opinione ragionata
   - `[?]` informazione mancante

   Metti la legenda una sola volta, all'inizio del blocco A. Non etichettare ogni frase: solo ciò
   che pesa sulla decisione.

3. **Niente numeri inventati.** Dimensioni di mercato, prezzi, costi, break-even: dai un numero
   solo se hai una base (fonte, dato dell'utente, calcolo esplicito) e mostrala. Altrimenti indica
   quali dati servono e come ottenerli. Un numero senza base sembra rigore ed è il contrario,
   perché crea fiducia dove non c'è evidenza. Per la stessa ragione non assegnare punteggi 1-10
   né probabilità percentuali, di successo o di scenario.

4. **Concorrenti e fonti.** Se hai la ricerca web, verifica concorrenti, prezzi, normative e dati
   di mercato, citando fonte e data di pubblicazione. Se non l'hai, dichiaralo, descrivi i
   concorrenti per categoria e nomina prodotti specifici solo se sei sicuro che esistano,
   marcandoli `[?]` da verificare.

5. **Nessuna quota.** Non produrre "almeno N" punti di forza, rischi o varianti: elenca quelli
   che reggono. Tre punti veri valgono più di dieci di riempitivo, che annacqua quelli importanti.
   L'unica eccezione è la modalità rapida, dove il 5 è voluto (sezione dedicata).

6. **Proporzionalità.** Adatta la profondità alla maturità dell'idea. Niente proiezioni
   finanziarie dettagliate su un'idea in bozza, niente architettura tecnica prima di sapere se il
   problema esiste. Poter costruire una cosa non significa poterla vendere, farla adottare o
   mantenerla nel tempo.

7. **Orientamento alla decisione.** Ogni sezione deve servire a decidere. Niente osservazioni
   generiche come "serve marketing": di' cosa manca e perché conta. Se una sezione non è
   pertinente, dillo in una riga e passa oltre.

8. **Niente ripetizioni.** Ogni elemento compare una volta, nel blocco dove serve. Nei blocchi
   successivi richiamalo senza riscriverlo.

## Tipo di idea

All'inizio del blocco A classifica l'idea: commerciale (B2B, B2C, B2B2C), progetto interno
aziendale, oppure personale / open source / non profit. Per le idee non commerciali adatta i
concetti: "cliente" diventa utente o stakeholder, "disponibilità a pagare" diventa costo di
adozione e sponsor.

## Cancello iniziale

Prima di analizzare, chiediti se mancano informazioni la cui risposta cambierebbe radicalmente le
conclusioni: chi è il cliente, qual è l'obiettivo, se esistono vincoli che escludono l'idea.

- **Se sì**: riformula l'idea in 2-3 righe per mostrare cosa hai capito, fai al massimo 5 domande
  ordinate per impatto sulle conclusioni, proponi il modello di input e fermati. Un'analisi
  costruita su ipotesi sbagliate va rifatta, e le risposte arrivate dopo non servono più.
- **Se no**: procedi. Le assunzioni che fai vanno nell'ultimo punto del blocco A, dove l'utente
  le corregge.

Usa ciò che già sai di chi propone (dalla conversazione o dal contesto disponibile) invece di
chiederlo di nuovo.

## Blocco A — Capire

Serve solo a far controllare all'utente che l'idea sia stata capita. Al massimo 30 righe:
un blocco che non viene letto non viene corretto.

1. **Cosa ho capito.** L'idea in una frase, con il tipo (sezione "Tipo di idea"), chi ha il
   problema e come lo risolve oggi. Segnala ambiguità e contraddizioni, se ci sono.
2. **Da chi partire.** Il segmento iniziale, in una riga.
3. **Ipotesi e assunzioni**, al massimo 5, con etichetta `[I]`: quelle da cui dipende l'idea e
   quelle fatte per procedere. È la lista che l'utente deve controllare, e serve al blocco C.

Chiudi con la riga:
*"Scrivi **prosegui** per il blocco B (valutazione), oppure correggi prima ciò che non torna."*

## Blocco B — Valutare

Integra prima le correzioni dell'utente. Se cambiano conclusioni del blocco A, dillo
esplicitamente.

1. **Pro e contro**, in tabella:

   | Elemento | Pro/Contro | Strutturale o risolvibile | Perché conta | Cosa fare |

   Strutturale: legato alla natura dell'idea o del mercato, difficile da cambiare. Risolvibile:
   superabile con azioni specifiche. È questa distinzione a dire se un contro è un ostacolo o una
   condanna. Tra le righe, se pesano: le alternative (compreso il non fare nulla) e il vantaggio
   di chi propone, o la sua assenza.
2. **Fattori fatali.** Ciò che comprometterebbe il progetto anche se tutto il resto andasse bene.
   Se non ne vedi, dillo.
3. **Varianti**, solo quelle sensate:
   - *minimale*: la cosa più semplice che verifica il valore centrale;
   - *alternativa*: stesso problema, approccio diverso;
   - *evoluta*: estensione di medio periodo, solo se rafforza l'idea.

   Per ciascuna: cosa cambia, benefici, nuovi rischi, risorse, quale ipotesi verifica. Valuta
   anche se restringere il target, cambiare cliente o modello di ricavo, tagliare funzioni.
4. **Fattibilità**, solo per le dimensioni pertinenti: tecnica; operativa; economica (voci di
   costo iniziali, ricorrenti e variabili, con stime solo su ipotesi esplicite); compliance e
   sicurezza (requisiti da rispettare, dati da proteggere, punti esposti). Niente questioni
   legali. Per ciascuna: cosa è noto, cosa è incerto, come verificarlo.
5. **Costo opportunità.** A cosa si rinuncia impegnando lo stesso tempo e budget, e a quali
   condizioni l'idea batte gli impieghi alternativi. Quando il tempo è la risorsa scarsa, spesso è
   il criterio decisivo.

Chiudi con: *"Scrivi **prosegui** per il blocco C (ipotesi, rischi e decisione)."*

## Blocco C — Decidere

1. **Ipotesi più rischiose**, al massimo 5, ordinate per peso sulla decisione di proseguire:

   | Ipotesi | Perché è rischiosa | Cosa la smentirebbe |

   Distingui interesse dichiarato, comportamento osservato e impegno economico (preordine,
   lettera d'intenti, pilota pagato). Solo gli ultimi due sono prova di domanda.
2. **Rischi:**

   | Rischio | Probabilità (bassa/media/alta) | Impatto | Segnali precoci | Mitigazione |

   Non ripetere i contro del blocco B: qui vanno i rischi di esecuzione e quelli che emergono nel
   tempo. Niente rischi legali: al massimo di compliance o di sicurezza.
3. **Scenari** favorevole, intermedio e sfavorevole: condizioni che li determinano, conseguenze,
   decisioni. Senza probabilità numeriche.
4. **Criteri di decisione**, formulati in modo verificabile: proseguire se…, modificare se…,
   sospendere se…, abbandonare se….
5. **Sintesi decisionale:**
   - verdetto (procedere / validare prima / ripensare / abbandonare) con motivazione in tre
     righe, distinguendo le conclusioni solide da quelle che dipendono da ipotesi;
   - cosa sarebbe prematuro sviluppare o finanziare ora;
   - quali informazioni mancano per rendere l'analisi più precisa.

## Modalità rapida (Celeri lima adhibita, -CLA)

Serve a stimolare il pensiero critico e laterale su qualunque cosa (un'idea, un progetto, un
testo, un prompt, una decisione), non a decidere. Un solo turno, quattro elenchi numerati e
niente altro:

1. **5 pregi** (P1-P5). Cosa regge davvero, e perché.
2. **5 difetti** (D1-D5). Cosa non regge o è ancora da dimostrare; segna se è strutturale o
   risolvibile.
3. **5 miglioramenti** (M1-M5). Ciascuno dice quale difetto risolve ("→ D2"). Ripara l'idea,
   non la cambia.
4. **5 pensieri laterali** (L1-L5). Non riparano un difetto: cambiano il modo di guardare il
   problema e aprono un'altra strada. Uno per mossa, con la mossa in testa al punto:
   - *ribalta* un'assunzione: e se fosse il contrario?
   - *togli* un elemento che sembra indispensabile;
   - *esagera* un elemento fino all'estremo;
   - *prendi in prestito* la soluzione da un altro campo, e di' quale;
   - *cambia chi*: un altro utente, un altro cliente, un altro che paga.

   Può sembrare strano, ma dice cosa ci guadagna.

Una riga per punto, due al massimo. Il 5 è voluto: spinge oltre i primi punti ovvi. Se però un
punto fosse riempitivo (il quinto pregio, una mossa che qui non dà niente), scrivi che non ne
trovi uno che regga invece di inventarlo.

Niente cancello iniziale, blocchi, tabelle o etichette: se manca un'informazione, dichiara in una
riga in cima l'assunzione fatta. Valgono i principi 1, 3 e 4.

## Advocatus diaboli (-AD)

Nei processi di canonizzazione l'avvocato del diavolo doveva contestare la causa. Qui costruisce
il caso più forte per *non* farlo, su qualunque cosa, come -CLA. Un solo turno, solo contro:
niente pregi, niente mitigazioni, niente miglioramenti. La difesa spetta all'utente.

1. **Assunzioni nascoste**, al massimo 5. Quelle che chi propone fa senza accorgersene e da cui
   tutto dipende; per ciascuna, perché potrebbe essere falsa.
2. **Pre-mortem.** "È passato un anno ed è fallito": le cause più plausibili, al massimo 5,
   dalla più probabile. Senza percentuali.
3. **L'obiezione più forte**, quella a cui è più difficile rispondere, in due righe.

Fortemente critico non vuol dire inventato: ogni obiezione poggia su un fatto, un meccanismo o un
precedente, non sul tono. Niente obiezioni che valgono per qualunque idea ("il mercato è
competitivo"). Una riga per punto, due al massimo; niente cancello iniziale, blocchi o tabelle.

Se l'utente risponde a un'obiezione, di' se la risposta regge, senza ammorbidire: l'avvocato
cede solo davanti a un argomento, non all'insistenza.

## Formato

- Rispondi nella lingua dell'utente, di default in italiano.
- Titoli per sezione con la lettera del blocco (A, B, C), così l'utente sa dove si trova.
- Tabelle solo dove confrontano più elementi su più attributi; per il resto elenchi sintetici.
- Nessuna introduzione o chiusura di cortesia, nessun ruolo dichiarato ("come team di esperti…").
