# claude-plugins

Armamentarium: plugin personali per Claude.

## Installa tutto

Da una shell, anche dal terminale di VS Code:

```
curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
```

Dentro Claude Code puoi lanciarlo così com'è mettendo `!` davanti.

Cosa fa:

- toglie ponytail e modalita-fastidio: plugin, skill, comandi e hook in `settings.json` (con copia
  `.bak`), a livello utente, progetto e locale;
- aggiunge il marketplace e installa `omnia` a livello utente, con tutte le skill e i loro hook;
- mette le skill di omnia su `on` in `skillOverrides` (settings utente) e toglie le eccezioni che
  le spengono nei settings del progetto;
- alla fine elenca i file rimasti di ponytail o fastidio e chiede se toglierli; quelli che li
  citano soltanto, come una statusline, li segnala e basta.

Per toglierli senza domande: `curl -fsSL …/install.sh | bash -s -- -y`.

Si può rilanciare: la volta dopo aggiorna. I livelli progetto e locale valgono per la cartella da
cui lo lanci. Poi riavvia Claude Code.

Da dentro Claude Code, senza script:

```
/plugin marketplace add rrambaldi/claude-plugins
/plugin install omnia@armamentarium
```

Su claude.ai (chat e Claude Code sul web) gli script non girano: skill e plugin si gestiscono da
Customize → Skills e Customize → Plugins. Se installi il marketplace sia lì sia in locale, ogni
skill compare due volte.

<details>
<summary>Un plugin alla volta</summary>

```
/plugin install limam-adhibere@armamentarium
/plugin install inspectio-decoris@armamentarium
/plugin install sine-more-interposita@armamentarium
/plugin install nec-plus-quam-oportet@armamentarium
/plugin install festina-lente@armamentarium
/plugin install nomen-mutare@armamentarium
/plugin install status-rei@armamentarium
/plugin install summa-rerum@armamentarium
```

Non installarli insieme a `omnia`, o ogni skill compare due volte.

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

### Analizzare e prendere decisioni (limam-adhibere)

- *Limam adhibere* (`-LA`): analisi completa di un'idea in tre blocchi: capire, valutare, decidere.
- *Celeri lima adhibita* (`-CLA`): passata veloce: 5 pregi, 5 difetti, 5 miglioramenti.
- *Advocatus diaboli* (`-AD`): solo contro, per smontare un'idea che ti sembra già buona.

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

### Aiuto e statusline (summa-rerum, status-rei)

- *Summa rerum* (`-SR`): l'help del marketplace.
- *Status rei* (`-STR`): statusline con modello, effort, branch, contesto usato e modalità attive.

## Casi d'uso

### limam-adhibere

- Hai un'idea e vuoi sapere se sta in piedi prima di investirci tempo: *Limam adhibere* (`-LA`) seguito dall'idea. Tre blocchi (capire, valutare, decidere), uno per turno; scrivi `prosegui` per passare al successivo.
- Vuoi una passata veloce su un testo, un prompt, un progetto o una decisione: *Celeri lima adhibita* (`-CLA`) seguito dal testo. 5 pregi, 5 difetti, 5 miglioramenti, di cui almeno due nati dal pensiero laterale.
- Ti sembra già una buona idea e vuoi che qualcuno provi a smontarla: *Advocatus diaboli* (`-AD`). Solo contro: assunzioni nascoste, pre-mortem ("è passato un anno ed è fallito: perché?"), l'obiezione più forte. Poi puoi rispondere, e ti dice se la tua difesa regge.

### inspectio-decoris e sequere-pulchritudinem

- L'app funziona ma sembra datata, o non sai perché una pagina non convince: *Inspectio decoris* (`-ID`) seguito da URL o cartella. Livelli: `-ID rapida`, `-ID` (standard), `-ID completa`. Non tocca il codice; il piano di interventi finisce in `docs/ux/piano-restyle.md`.
- Hai approvato il piano e vuoi applicarlo: *Sequere pulchritudinem* (`-SP`), per esempio `-SP applica la fase 1`. Ogni intervento viene verificato nel browser con le stesse misure dell'analisi.

### nec-plus-quam-oportet e vitium-ostendere

- Sempre attiva: quando chiedi del codice, Claude riusa quello che c'è già e scrive il minimo che funziona. *Nec plus quam oportet* (`-NPQO`): `-NPQO levis` per allentare, `-NPQO ultra` per stringere, `-NPQO off` per spegnerla.
- C'è un bug e vuoi la certezza che non torni: *Vitium ostendere* (`-VO`) seguito dalla descrizione. Prima un test che lo riproduce e fallisce, poi la correzione minima, poi lo stesso test verde.

### sine-more-interposita

- Sempre attiva: risposte corte, lavoro finito invece di mezzo finito, domande solo quando servono davvero. Ogni risposta inizia con una riga ⚡: se sparisce (succede dopo una compattazione del contesto), riscrivi *Sine more interposita* (`-SMI`).

### nomen-mutare

- La sessione cambia argomento e il titolo di Claude Code resta quello del primo prompt: ogni 10 prompt Haiku legge gli ultimi prompt e scrive un titolo nuovo, che arriva al prompt dopo, come un `/rename`. Per cambiare ogni quanti prompt, nei settings: `"env": {"NOMEN_MUTARE_OGNI": "5"}`; `"0"` lo spegne. Un `/rename` fatto a mano dura fino al giro successivo.

### festina-lente e alea-iacta-est

- Hai un piano lungo e devi allontanarti: *Festina lente* (`-FL`) seguito dal piano. Le attività con una decisione che costerebbe refactoring si fermano, Claude passa alle altre, e al ritorno trovi i dubbi in `DEBITI.md` (o in un doc claude.ai).
- Stesso caso, ma preferisci che decida Claude: *Alea iacta est* (`-AIE`) seguito dal piano. Scrive almeno tre opzioni, sceglie, isola la scelta in un solo punto e la registra in `DECISIONI.md` (o in un doc claude.ai).

### status-rei

- Vuoi vedere in basso modello, contesto usato e modalità attive: *Status rei* (`-STR`). `-STR off` per toglierla.

### summa-rerum

- Non ricordi un incantesimo: *Summa rerum* (`-SR`) stampa la tabella di tutte le skill.

## Aggiungere un plugin

1. Crea `plugins/<nome>/.claude-plugin/plugin.json` e `plugins/<nome>/skills/<nome>/SKILL.md`.
2. Aggiungi la voce in `.claude-plugin/marketplace.json`, e aggiungi le sue skill (e gli hook, se ne ha) alla voce `omnia` dello stesso file.
3. Quando modifichi una skill, incrementa `version` in `plugin.json`, nella sua voce di `marketplace.json` e nella voce `omnia`.
4. Aggiorna `plugins/summa-rerum/skills/summa-rerum/help.md`, l'help che *Summa rerum* (`-SR`) stampa così com'è.
5. Quando una skill o un testo suggerisce un comando, scrivi l'incantesimo latino con la sigla: *Sequere pulchritudinem* (`-SP`), mai `-SP` da solo. In fondo è una magia.
