# claude-plugins

Armamentarium: plugin personali per Claude.

## Installa tutto

Da una shell, anche dal terminale di VS Code:

```
curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
```

Toglie ponytail e modalita-fastidio, aggiunge il marketplace e installa `omnia`, che contiene tutte
le skill e i loro hook. Si può rilanciare: la volta dopo aggiorna. Poi riavvia Claude Code.

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
/plugin install status-rei@armamentarium
/plugin install summa-rerum@armamentarium
```

Non installarli insieme a `omnia`, o ogni skill compare due volte.

</details>

## Skill

- **limam-adhibere** (`-LA` · `-CLA` · `-AD`): pensiero critico e laterale su un'idea o su qualunque cosa, senza codice né piani.
- **inspectio-decoris** (`-ID`): analisi UX ed estetica di un'app web esistente, con prove dal browser e dal codice.
- **sequere-pulchritudinem** (`-SP`): applica un restyle già approvato, fase per fase, e lo verifica nel browser.
- **nec-plus-quam-oportet** (`-NPQO`, sempre attiva): la soluzione più semplice che funziona, basata su ponytail (MIT).
- **vitium-ostendere** (`-VO`): corregge un bug partendo da un test che fallisce.
- **sine-more-interposita** (`-SMI`, sempre attiva): finire davvero, agire invece di chiedere, risposte corte in italiano facile.
- **festina-lente** (`-FL`): esegue un piano lungo senza di te; le decisioni costose si fermano in un file di debiti.
- **alea-iacta-est** (`-AIE`): esegue un piano lungo senza di te; le decisioni costose le prende Claude e le registra.
- **status-rei** (`-STR`): statusline con modello, effort, branch, contesto usato e modalità attive.
- **summa-rerum** (`-SR`): l'help del marketplace.

## Casi d'uso

### limam-adhibere

- Hai un'idea e vuoi sapere se sta in piedi prima di investirci tempo: `-LA` seguito dall'idea. Tre blocchi (capire, valutare, decidere), uno per turno; scrivi `prosegui` per passare al successivo.
- Vuoi una passata veloce su un testo, un prompt, un progetto o una decisione: `-CLA` seguito dal testo. 5 pregi, 5 difetti, 5 miglioramenti, di cui almeno due nati dal pensiero laterale.
- Ti sembra già una buona idea e vuoi che qualcuno provi a smontarla: `-AD`. Solo contro: assunzioni nascoste, pre-mortem ("è passato un anno ed è fallito: perché?"), l'obiezione più forte. Poi puoi rispondere, e ti dice se la tua difesa regge.

### inspectio-decoris e sequere-pulchritudinem

- L'app funziona ma sembra datata, o non sai perché una pagina non convince: `-ID` seguito da URL o cartella. Livelli: `-ID rapida`, `-ID` (standard), `-ID completa`. Non tocca il codice; il piano di interventi finisce in `docs/ux/piano-restyle.md`.
- Hai approvato il piano e vuoi applicarlo: `-SP applica la fase 1`. Ogni intervento viene verificato nel browser con le stesse misure dell'analisi.

### nec-plus-quam-oportet e vitium-ostendere

- Sempre attiva: quando chiedi del codice, Claude riusa quello che c'è già e scrive il minimo che funziona. `-NPQO levis` per allentare, `-NPQO ultra` per stringere, `-NPQO off` per spegnerla.
- C'è un bug e vuoi la certezza che non torni: `-VO` seguito dalla descrizione. Prima un test che lo riproduce e fallisce, poi la correzione minima, poi lo stesso test verde.

### sine-more-interposita

- Sempre attiva: risposte corte, lavoro finito invece di mezzo finito, domande solo quando servono davvero. Ogni risposta inizia con una riga ⚡: se sparisce (succede dopo una compattazione del contesto), riscrivi `-SMI`.

### festina-lente e alea-iacta-est

- Hai un piano lungo e devi allontanarti: `-FL` seguito dal piano. Le attività con una decisione che costerebbe refactoring si fermano, Claude passa alle altre, e al ritorno trovi i dubbi in `DEBITI.md` (o in un doc claude.ai).
- Stesso caso, ma preferisci che decida Claude: `-AIE` seguito dal piano. Scrive almeno tre opzioni, sceglie, isola la scelta in un solo punto e la registra in `DECISIONI.md` (o in un doc claude.ai).

### status-rei

- Vuoi vedere in basso modello, contesto usato e modalità attive: `-STR`. `-STR off` per toglierla.

### summa-rerum

- Non ricordi una sigla: `-SR` stampa la tabella di tutte le skill.

## Aggiungere un plugin

1. Crea `plugins/<nome>/.claude-plugin/plugin.json` e `plugins/<nome>/skills/<nome>/SKILL.md`.
2. Aggiungi la voce in `.claude-plugin/marketplace.json`, e aggiungi le sue skill (e gli hook, se ne ha) alla voce `omnia` dello stesso file.
3. Quando modifichi una skill, incrementa `version` in `plugin.json`, nella sua voce di `marketplace.json` e nella voce `omnia`.
4. Aggiorna `plugins/summa-rerum/skills/summa-rerum/help.md`, l'help che `-SR` stampa così com'è.
