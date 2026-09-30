# claude-plugins

Armamentarium: plugin personali per Claude.

## Installa tutto

Da una shell, anche dal terminale di VS Code:

```
curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
```

Dentro Claude Code puoi lanciarlo così com'è mettendo `!` davanti.

Ti chiede in che lingua vuoi i comandi: latino (invio), italiano o inglese (sezione "Lingua dei
comandi"). Per sceglierla subito: `curl -fsSL …/install.sh | bash -s -- it` (o `la`, `en`).

Cosa fa:

- toglie ponytail e modalita-fastidio: plugin, skill, comandi e hook in `settings.json` (con copia
  `.bak`), a livello utente, progetto e locale;
- aggiunge il marketplace e installa a livello utente il pacchetto della lingua scelta, con tutte le
  skill e i loro hook: `omnia` (latino), `tutto` (italiano) o `all` (inglese). Toglie gli altri
  pacchetti, che raddoppierebbero le skill. Se l'organizzazione ne dà già uno da claude.ai (Required
  o Installed by default), Claude Code lo sincronizza da solo: lo script usa quello, non installa
  niente e toglie le copie locali;
- mette le skill del pacchetto su `on` in `skillOverrides` (settings utente) e toglie le eccezioni
  che le spengono nei settings del progetto;
- accende `autoUpdate` sul marketplace (settings utente): a ogni avvio Claude Code scarica le
  versioni nuove, se in `marketplace.json` è cambiata `version`;
- alla fine elenca i file rimasti di ponytail o fastidio e chiede se toglierli; quelli che li
  citano soltanto, come una statusline, li segnala e basta.

Per toglierli senza domande: `curl -fsSL …/install.sh | bash -s -- -y`. Con `-y` non chiede
neanche la lingua: se non la scrivi, è il latino.

In un'organizzazione che ha appena aggiunto un pacchetto, apri Claude Code una volta prima di lanciarlo:
il sync avviene all'avvio, e senza lo script non lo vede.

Si può rilanciare: la volta dopo aggiorna. I livelli progetto e locale valgono per la cartella da
cui lo lanci. Poi riavvia Claude Code.

Da dentro Claude Code, senza script:

```
/plugin marketplace add rrambaldi/claude-plugins
/plugin install omnia@armamentarium
```

Al posto di `omnia`: `tutto` per i comandi in italiano, `all` per quelli in inglese. Uno solo.

Su claude.ai (chat e Claude Code sul web) gli script non girano: skill e plugin si gestiscono da
Customize → Skills e Customize → Plugins. Se installi il marketplace sia lì sia in locale, ogni
skill compare due volte.

<details>
<summary>Un plugin alla volta (solo in latino)</summary>

```
/plugin install limam-adhibere@armamentarium
/plugin install inspectio-decoris@armamentarium
/plugin install sine-more-interposita@armamentarium
/plugin install nec-plus-quam-oportet@armamentarium
/plugin install festina-lente@armamentarium
/plugin install nomen-mutare@armamentarium
/plugin install tabula-rasa@armamentarium
/plugin install status-rei@armamentarium
/plugin install summa-rerum@armamentarium
```

Non installarli insieme a un pacchetto (`omnia`, `tutto` o `all`), o ogni skill compare due volte.

</details>

## Skill

Scrivi l'incantesimo latino o la sigla, seguiti dalla richiesta:

```
-LA aggiungere API che ritorna password degli utenti in chiaro
```

```
Limam adhibere '''aggiungere API che ritorna password degli utenti in chiaro'''
```

Le virgolette triple servono per i testi lunghi o su più righe. Maiuscole e slash non contano:
`-la`, `/limam-adhibere` e `Limam adhibere` fanno la stessa cosa.

Qui sotto i comandi sono in latino. Con `tutto` o `all` usi i nomi della sezione "Lingua dei
comandi".

### Analizzare e prendere decisioni (limam-adhibere)

- *Limam adhibere* (`-LA`): analisi completa di un'idea in tre blocchi: capire, valutare, decidere.
- *Celeri lima adhibita* (`-CLA`): passata veloce: 5 pregi, 5 difetti, 5 miglioramenti, 5 pensieri laterali.
- *Advocatus diaboli* (`-AD`): solo contro, per smontare un'idea che ti sembra già buona.
- *Intus et extra* (`-IE`): analisi SWOT: forze, debolezze, opportunità, minacce e cosa farne.

### Design UI e UX (inspectio-decoris, sequere-pulchritudinem)

- *Inspectio decoris* (`-ID`): analisi UX ed estetica di un'app web esistente, con prove dal browser e dal codice. Non tocca il codice.
- *Sequere pulchritudinem* (`-SP`): applica un restyle già approvato, fase per fase, e lo verifica nel browser.

### Sviluppo (nec-plus-quam-oportet, vitium-ostendere)

- *Nec plus quam oportet* (`-NPQO`), sempre attiva: per la scrittura di codice. La soluzione più semplice che funziona, basata su ponytail (MIT).
- *Vitium ostendere* (`-VO`): corregge un bug partendo da un test che fallisce.

### Piani lunghi senza di te (festina-lente, alea-iacta-est)

- *Festina lente* (`-FL`): esegue il piano; le decisioni costose si fermano in un file di debiti.
- *Alea iacta est* (`-AIE`): esegue il piano; le decisioni costose le prende Claude e le registra.

### Come lavora Claude (sine-more-interposita)

- *Sine more interposita* (`-SMI`), sempre attiva: finire davvero, agire invece di chiedere, risposte corte in italiano facile.

### Titolo della sessione (nomen-mutare)

- *Nomen mutare*, sempre attivo, senza sigla: ogni 10 prompt dà alla sessione un titolo nuovo, come `/rename`.

### File temporanei (tabula-rasa)

- Regola sempre attiva: Claude cancella i file temporanei che crea e chiude ogni task con lo scratchpad vuoto. Dopo un commit o un push ti chiede di scrivere `/compact`.
- *Tabula rasa* (`-TR`): libera spazio in `/tmp`, prima in simulazione; `-TR -s` solo per la sessione da cui lo lanci.

### Aiuto e statusline (summa-rerum, status-rei)

- *Summa rerum* (`-SR`): l'help del marketplace.
- *Status rei* (`-STR`): statusline con modello, effort, branch, contesto usato, limiti di 5 ore e settimanale e modalità attive.

## Lingua dei comandi

Tre set con le stesse skill, uno per lingua: se ne installa uno solo. Cambiano solo incantesimi, sigle
e comandi slash (`/limam-adhibere`, `/analisi-critica`, `/critical-review`). Le istruzioni delle
skill restano in italiano, e Claude risponde nella tua lingua.

| Latino (`omnia`) | Italiano (`tutto`) | English (`all`) |
|---|---|---|
| *Alea iacta est* (`-AIE`) | *Il dado è tratto* (`-DT`) | *The die is cast* (`-TDC`) |
| *Festina lente* (`-FL`) | *Chi va piano* (`-CVP`) | *Make haste slowly* (`-MHS`) |
| *Inspectio decoris* (`-ID`) | *Analisi UX* (`-AUX`) | *UX audit* (`-UXA`) |
| *Sequere pulchritudinem* (`-SP`) | *Applica restyle* (`-AR`) | *Apply restyle* (`-AR`) |
| *Intus et extra* (`-IE`) | *Analisi SWOT* (`-SWOT`) | *SWOT analysis* (`-SWOT`) |
| *Limam adhibere* (`-LA`) | *Analisi critica* (`-AC`) | *Critical review* (`-CR`) |
| *Celeri lima adhibita* (`-CLA`) | *Critica veloce* (`-CV`) | *Quick critique* (`-QC`) |
| *Advocatus diaboli* (`-AD`) | *Avvocato del diavolo* (`-AD`) | *Devil's advocate* (`-DA`) |
| *Nec plus quam oportet* (`-NPQO`) levis, ultra, off | *Solo il necessario* (`-SN`) leggero, ultra, off | *Keep it simple* (`-KIS`) lite, ultra, off |
| *Vitium ostendere* (`-VO`) | *Prima il test* (`-PT`) | *Test first* (`-TF`) |
| *Sine more interposita* (`-SMI`) | *Niente indugi* (`-NI`) | *No delay* (`-ND`) |
| *Status rei* (`-STR`) | *Barra di stato* (`-BDS`) | *Status line* (`-SL`) |
| *Summa rerum* (`-SR`) | *Grimorio* (`-GR`) | *Spellbook* (`-SB`) |
| *Tabula rasa* (`-TR`) | *Fai pulizia* (`-FP`) | *Clean slate* (`-CS`) |

nomen-mutare non ha comandi ed è uguale nei tre set. I badge della statusline restano in latino.

Il set latino in `plugins/` è l'unico che si scrive a mano. `python3 lingue/genera.py` ne ricava
`lingue/it` e `lingue/en`, cambiando nomi e sigle, e i pacchetti `tutto` e `all` in
`marketplace.json`, copiati da `omnia` con la sua versione.

## Casi d'uso

### limam-adhibere

- Hai un'idea e vuoi sapere se sta in piedi prima di investirci tempo: *Limam adhibere* (`-LA`) seguito dall'idea. Tre blocchi (capire, valutare, decidere), uno per turno; scrivi `prosegui` per passare al successivo.
- Vuoi una passata veloce su un testo, un prompt, un progetto o una decisione: *Celeri lima adhibita* (`-CLA`) seguito dal testo. 5 pregi, 5 difetti, 5 miglioramenti che riparano i difetti e 5 pensieri laterali che cambiano strada (ribalta, togli, esagera, prendi in prestito, cambia chi).
- Ti sembra già una buona idea e vuoi che qualcuno provi a smontarla: *Advocatus diaboli* (`-AD`). Solo contro: assunzioni nascoste, pre-mortem ("è passato un anno ed è fallito: perché?"), l'obiezione più forte. Poi puoi rispondere, e ti dice se la tua difesa regge.
- Ti serve una SWOT per un progetto, un prodotto o una decisione: *Intus et extra* (`-IE`) seguito dal testo, meglio se con l'obiettivo. Forze e debolezze (dentro), opportunità e minacce (fuori), poi gli incroci (forza + opportunità, debolezza + minaccia...) e la cosa che pesa di più.

### inspectio-decoris e sequere-pulchritudinem

- L'app funziona ma sembra datata, o non sai perché una pagina non convince: *Inspectio decoris* (`-ID`) seguito da URL o cartella. Livelli: `-ID rapida`, `-ID` (standard), `-ID completa`. Quattro turni (ricognizione, percorso, misure, sintesi): scrivi `prosegui` per passare al successivo, e il report si aggiorna nel file a ogni turno. Senza un browser MCP propone un Chromium headless, se sei d'accordo a scaricarlo. Non tocca il codice; il piano di interventi finisce in `docs/ux/piano-restyle.md`.
- Hai approvato il piano e vuoi applicarlo: *Sequere pulchritudinem* (`-SP`), per esempio `-SP applica la fase 1`. Ogni intervento viene verificato nel browser con le stesse misure dell'analisi.

### nec-plus-quam-oportet e vitium-ostendere

- Sempre attiva: quando chiedi del codice, Claude riusa quello che c'è già e scrive il minimo che funziona. *Nec plus quam oportet* (`-NPQO`): `-NPQO levis` per allentare, `-NPQO ultra` per stringere, `-NPQO off` per spegnerla.
- C'è un bug e vuoi la certezza che non torni: *Vitium ostendere* (`-VO`) seguito dalla descrizione. Prima un test che lo riproduce e fallisce, poi la correzione minima, poi lo stesso test verde.

### sine-more-interposita

- Sempre attiva: risposte corte, lavoro finito invece di mezzo finito, domande solo quando servono davvero. Ogni risposta inizia con una riga ⚡: se sparisce (succede dopo una compattazione del contesto), riscrivi *Sine more interposita* (`-SMI`).

### nomen-mutare

- La sessione cambia argomento e il titolo di Claude Code resta quello del primo prompt: ogni 10 prompt Haiku legge gli ultimi prompt e scrive un titolo nuovo, che arriva al prompt dopo, come un `/rename`. Per cambiare ogni quanti prompt, nei settings: `"env": {"NOMEN_MUTARE_OGNI": "5"}`; `"0"` lo spegne. Un `/rename` fatto a mano dura fino al giro successivo.

### tabula-rasa

- Lo scratchpad e `/tmp` si riempiono di file che nessuno cancella: a ogni avvio un hook carica la regola. Claude cancella i file temporanei appena non servono e ferma i processi in background. Prima di chiudere un task svuota lo scratchpad e lo controlla con `du -sh`. Tocca solo i file che ha creato nella sessione; quelli da tenere li sposta nel progetto e te lo dice. Dopo un commit, un push o tutti e due, chiude la risposta chiedendoti `/compact`: lanciarlo da solo non può.
- `/tmp` è piena di sessioni Claude vecchie e file dimenticati: *Tabula rasa* (`-TR`). Prima fa la simulazione e ti dice quanto si libera, poi cancella solo dopo il tuo sì. Toglie le sessioni Claude chiuse (inattive da più di 120 minuti, `-i` per cambiare), i tuoi file non toccati da 7 giorni (`-d`) e, con `-t 500M`, tronca i log aperti più grandi di così. Le sessioni Claude vive restano sempre, come i file in uso e quelli di altri utenti. Niente sudo: ognuno pulisce la sua roba. Funziona su Linux e su Windows (`%TEMP%`, senza `-t`); su macOS no.
- Vuoi svuotare solo la sessione in cui sei: *Tabula rasa* (`-TR -s`). Toglie i file non in uso di scratchpad e task, e lascia le cartelle.

### festina-lente e alea-iacta-est

- Hai un piano lungo e devi allontanarti: *Festina lente* (`-FL`) seguito dal piano. Le attività con una decisione che costerebbe refactoring si fermano, Claude passa alle altre, e al ritorno trovi i dubbi in `DEBITI.md` (o in un doc claude.ai).
- Stesso caso, ma preferisci che decida Claude: *Alea iacta est* (`-AIE`) seguito dal piano. Scrive almeno tre opzioni, sceglie, isola la scelta in un solo punto e la registra in `DECISIONI.md` (o in un doc claude.ai).

### status-rei

- Vuoi vedere in basso modello, contesto usato e modalità attive: *Status rei* (`-STR`). `-STR off` per toglierla.
- Vuoi sapere quanto lavoro ti resta: la seconda riga della statusline mostra `5 ore resta 70% → 18:30 · settimana resta 1% → mer 00:00`, cioè quanto resta del limite di 5 ore e di quello settimanale, e quando si azzerano, poi le modalità attive. Giallo sotto il 30%, rosso sotto il 10%. Dopo un aggiornamento del plugin rilancia *Status rei* (`-STR`) per copiare la versione nuova.

### summa-rerum

- Non ricordi un incantesimo: *Summa rerum* (`-SR`) stampa la tabella di tutte le skill.

## Aggiungere un plugin

1. Crea `plugins/<nome>/.claude-plugin/plugin.json` e `plugins/<nome>/skills/<nome>/SKILL.md`.
2. Aggiungi la voce in `.claude-plugin/marketplace.json`, e aggiungi le sue skill (e gli hook, se ne ha) alla voce `omnia` dello stesso file.
3. Quando modifichi una skill, incrementa `version` in `plugin.json`, nella sua voce di `marketplace.json` e nella voce `omnia`.
4. Aggiorna `plugins/summa-rerum/skills/summa-rerum/help.md`, l'help che *Summa rerum* (`-SR`) stampa così com'è.
5. Quando una skill o un testo suggerisce un comando, scrivi l'incantesimo latino con la sigla: *Sequere pulchritudinem* (`-SP`), mai `-SP` da solo. In fondo è una magia.
6. Un comando o una skill nuovi: aggiungi nomi e sigle in italiano e inglese in `COMANDI` e `SKILL` di `lingue/genera.py`. Una sigla non deve indicare due skill diverse, in nessuna lingua.
7. Alla fine lancia `python3 lingue/genera.py`, che rigenera il set italiano, quello inglese e i pacchetti `tutto` e `all`. `lingue/it` e `lingue/en` non si toccano a mano.
