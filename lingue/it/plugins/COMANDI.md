<!-- Generata da lingue/genera.py a partire da plugins/COMANDI.md: non modificarla a mano. -->
# Comandi in italiano

Pacchetto `tutto`. Per installarlo da una shell:

```
curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash -s -- it
```

Da dentro Claude Code: `/plugin marketplace add rrambaldi/claude-plugins`, poi
`/plugin install tutto@armamentarium`. Cosa fa lo script e le altre opzioni sono nel
[README](../../../README.md).

## Come si usano

Scrivi l'incantesimo o la sigla, seguiti dalla richiesta:

```
-AC aggiungere API che ritorna password degli utenti in chiaro
```

```
Analisi critica '''aggiungere API che ritorna password degli utenti in chiaro'''
```

Le virgolette triple servono per i testi lunghi o su più righe. Maiuscole e slash non contano:
`/analisi-critica` e `Analisi critica` fanno la stessa cosa, e la sigla vale anche in minuscolo. Se
non ricordi un comando, *Grimorio* (`-GR`) stampa la tabella di tutte le skill.

## Analizzare e decidere

Qui si pensa e basta: niente codice né piani.

- *Analisi critica* (`-AC`): hai un'idea e vuoi sapere se sta in piedi prima di investirci tempo.
  Tre blocchi, uno per turno: capire, valutare, decidere. Scrivi `prosegui` per passare al blocco
  dopo.
- *Critica veloce* (`-CV`): una passata veloce su un'idea, un testo, un prompt o una
  decisione. 5 pregi, 5 difetti, 5 miglioramenti che riparano i difetti e 5 pensieri laterali che
  cambiano strada (ribalta, togli, esagera, prendi in prestito, cambia chi).
- *Avvocato del diavolo* (`-AD`): ti sembra già una buona idea e vuoi che qualcuno provi a smontarla.
  Solo contro: assunzioni nascoste, pre-mortem ("è passato un anno ed è fallito: perché?"),
  l'obiezione più forte. Se rispondi, ti dice se la tua difesa regge.
- *Analisi critica* (`-AC`) e *Critica veloce* (`-CV`) hanno anche un incantesimo in lingue
  più antiche o più lontane. In sanscrito *Parīkṣāṃ kuru* (`-PK`) e *Śīghraṃ parīkṣāṃ kuru*
  (`-SPK`), anche in devanagari o senza diacritici (`pariksham kuru`). In quenya, l'elfico di
  Tolkien, *Sanwe-kenta* (`-SK`) e *Linta sanwe-kenta* (`-LSK`). In klingon *qech yIpoj*
  (`-QP`) e *nom qech yIpoj* (`-NQP`). In gallese, la lingua di Merlino, *Profa'r syniad*
  (`-PS`) e *Profa'r syniad yn gyflym* (`-PSG`). Stessa analisi, e restano uguali in tutti i
  set.
- *Analisi SWOT* (`-SWOT`): analisi SWOT di un progetto, un prodotto o una decisione, meglio se
  con l'obiettivo. Forze e debolezze (dentro), opportunità e minacce (fuori), poi gli incroci
  (forza + opportunità, debolezza + minaccia...) e la cosa che pesa di più.

## Design UI e UX

- *Analisi UX* (`-AUX`) seguito da URL o cartella: l'app funziona ma sembra datata, o non
  sai perché una pagina non convince. Analisi UX ed estetica in quattro turni (ricognizione,
  percorso, misure, sintesi), con prove dal browser e dal codice. Scrivi `prosegui` per passare al
  turno dopo; il report in `docs/ux/` si aggiorna a ogni turno. Livelli: `-AUX rapida`, `-AUX`
  (standard), `-AUX completa`. Senza un browser MCP propone un Chromium headless, se sei d'accordo
  a scaricarlo. Non tocca il codice: il piano finisce in `docs/ux/piano-restyle.md`.
- *Applica restyle* (`-AR`): hai approvato il piano e vuoi applicarlo, per esempio
  `-AR applica la fase 1`. Ogni intervento viene verificato nel browser con le stesse misure
  dell'analisi.

## Sviluppo

- *Solo il necessario* (`-SN`), sempre attiva: quando chiedi del codice, Claude riusa quello
  che c'è già e scrive il minimo che funziona, con costanti al posto dei valori ripetuti, niente
  duplicati ed errori mai ingoiati. Basata su ponytail (MIT). `-SN leggero` la allenta,
  `-SN ultra` la stringe, `-SN off` o `stop solo il necessario` la spengono.
- *Prima il test* (`-PT`) seguito dalla descrizione del bug: prima un test che lo riproduce e
  fallisce, poi la correzione minima alla causa, poi lo stesso test verde.
- *Occhi nuovi* (`-ON`): una revisione che non sia Claude che rilegge il suo
  lavoro. Da sola rivede le modifiche non committate; seguita da un commit, un intervallo
  (`HEAD~3..`) o una PR, rivede quello. Un subagente riceve solo il task e il diff, senza la
  conversazione, e cerca cosa manca, cosa è di troppo, cosa si rompe. Claude verifica ogni
  rilievo, corregge quelli veri e ti dice perché scarta gli altri. Parte anche da sola prima di
  chiudere un diff di codice sopra le 50 righe o i 3 file, o che tocca soldi, dati o sicurezza.
- *Regole scritte* (`-RS`): vuoi che le regole valgano per tutto il team, anche per chi non ha il
  plugin. Scrive in fondo al CLAUDE.md del progetto un blocco di una ventina di righe
  (precedenza, riuso, niente duplicati, errori, test, revisione indipendente, commit puliti), ti
  mostra il diff e non committa. Rilanciata, aggiorna solo il blocco: le regole del progetto
  stanno fuori e restano. Il tono delle risposte e i file temporanei restano fuori, perché sono
  gusti tuoi. Il blocco è una regola del progetto: `-SN leggero`, `ultra` e `off` non lo
  toccano. Al livello di default, con il blocco, all'avvio *Solo il necessario* non ricarica
  le sue 11 KB.
- *Cave canem*, sempre attivo, senza sigla: prima di ogni `git commit` lanciato da Claude guarda
  cosa finirebbe nel commit. Lo ferma se trova segreti (chiavi AWS, GitHub, Anthropic, OpenAI,
  Slack, Google, Stripe, chiavi private, password in chiaro, file `.env`) o file cambiati prima
  della sessione, che quindi non sono del task: per esempio il tuo lavoro in corso finito dentro
  un `git add -A`. Dice file, riga e tipo del segreto, mai il valore. Se un file vecchio va
  committato davvero, Claude rilancia con `CAVE_CANEM=perimetro`. Per un falso allarme sui
  segreti rilancia con `CAVE_CANEM=segreti`, e decidi tu da una richiesta di permesso con
  l'elenco. I commit che fai tu a mano non li tocca.

## Piani lunghi senza di te

- *Chi va piano* (`-CVP`) seguito dal piano: devi allontanarti. Le attività con una decisione che
  costerebbe refactoring si fermano, Claude passa alle altre, e al ritorno trovi i dubbi in
  `DEBITI.md` (o in un doc claude.ai).
- *Il dado è tratto* (`-DT`) seguito dal piano: stesso caso, ma preferisci che decida Claude.
  Scrive almeno tre opzioni, sceglie, isola la scelta in un solo punto e la registra in
  `DECISIONI.md` (o in un doc claude.ai).

## Come lavora Claude

- *Niente indugi* (`-NI`), sempre attiva: risposte corte in italiano facile, lavoro
  finito invece di mezzo finito, domande solo quando servono davvero. Ogni risposta comincia con
  una riga ⚡. Se sparisce, e succede dopo una compattazione del contesto, riscrivi
  *Niente indugi* (`-NI`).
- *Nomen mutare*, sempre attivo, senza sigla: la sessione cambia argomento e il titolo resta
  quello del primo prompt. Ogni 10 prompt Haiku legge gli ultimi prompt e scrive un titolo nuovo,
  che arriva al prompt dopo, come un `/rename`. Ogni quanti prompt: `"env":
  {"NOMEN_MUTARE_OGNI": "5"}` nei settings; `"0"` lo spegne. Un `/rename` fatto a mano dura fino
  al giro successivo.

## File temporanei

- Regola sempre attiva: Claude cancella i file temporanei appena non servono, ferma i processi in
  background e chiude ogni task con lo scratchpad vuoto, controllato con `du -sh`. Tocca solo i
  file che ha creato nella sessione; quelli da tenere li sposta nel progetto e te lo dice. Dopo un
  commit o un push ti chiede di scrivere `/compact`, che da solo non può lanciare.
- *Fai pulizia* (`-FP`): `/tmp` è piena di sessioni Claude vecchie e file dimenticati. Prima fa
  la simulazione e ti dice quanto si libera, poi cancella solo dopo il tuo sì. Toglie le sessioni
  Claude chiuse (inattive da più di 120 minuti, `-i` per cambiare), i tuoi file non toccati da 7
  giorni (`-d`) e, con `-t 500M`, tronca i log aperti più grandi di così. Le sessioni vive, i file
  in uso e quelli di altri utenti restano sempre; niente sudo. `-FP -s` svuota solo la sessione
  da cui lo lanci. Funziona su Linux e su Windows (`%TEMP%`, senza `-t`), non su macOS.

## Aiuto e statusline

- *Grimorio* (`-GR`): l'help, la tabella di tutte le skill con cosa fanno e come si attivano.
- *Barra di stato* (`-BDS`): la statusline. Mostra modello, effort, cartella, branch e contesto
  usato; sotto, quanto resta dei limiti di 5 ore e settimanale e quando si azzerano
  (`5 ore resta 70% → 18:30 · settimana resta 1% → mer 00:00`, giallo sotto il 30%, rosso sotto
  il 10%), poi le modalità attive. `-BDS off` la toglie. Dopo un aggiornamento del plugin
  rilancia *Barra di stato* (`-BDS`) per copiare la versione nuova. I badge delle modalità sono in
  latino in tutti i set.
