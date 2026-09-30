| Plugin | Skill | Cosa fa | Come si attiva | Sempre attiva |
|---|---|---|---|---|
| make-haste-slowly | the-die-is-cast | Esegue un piano lungo senza fermarsi: sulle decisioni costose sceglie tra tre opzioni e registra la scelta | `The die is cast` / `-TDC` | |
| make-haste-slowly | make-haste-slowly | Esegue un piano lungo senza decidere al posto tuo: i dubbi costosi si fermano e finiscono in un file da controllare | `Make haste slowly` / `-MHS` | |
| ux-audit | ux-audit | Analisi UX ed estetica di un'app web esistente, in quattro turni, con prove dal browser (anche headless) e dal codice | `UX audit` / `-UXA` | |
| ux-audit | apply-restyle | Applica un restyle già approvato, fase per fase, e lo verifica nel browser | `Apply restyle` / `-AR` | |
| critical-review | swot-analysis | Analisi SWOT: forze e debolezze, opportunità e minacce, poi gli incroci che dicono cosa farne | `SWOT analysis` / `-SWOT` | |
| critical-review | critical-review | Pensiero critico su un'idea: niente codice né piani | `Critical review` / `-CR` (completa) · `Quick critique` / `-QC` (rapida: 5 pregi, 5 difetti, 5 miglioramenti, 5 pensieri laterali) · `Devil's advocate` / `-DA` (solo contro) | |
| keep-it-simple | keep-it-simple | La soluzione più semplice che funziona: riuso, costanti, niente duplicati, marcatori `ParceEtRecte:` e `DefunctumEst:` | `Keep it simple` / `-KIS` · `-KIS lite` · `-KIS ultra` · `-KIS off` / `stop keep it simple` | sì |
| keep-it-simple | test-first | Corregge un bug partendo da un test che fallisce: da rosso a verde | `Test first` / `-TF` | |
| nomen-mutare | (solo hook) | Ogni 10 prompt dà alla sessione un titolo nuovo, come `/rename`, scritto da Haiku sugli ultimi prompt | Da sola. Ogni quanti prompt: `NOMEN_MUTARE_OGNI` in `env` dei settings; `0` la spegne | sì |
| no-delay | no-delay | Finire davvero, agire invece di chiedere, andare veloce, risposte corte in italiano facile; non tocca il lavoro di `-CR` / `-QC` / `-DA` / `-SWOT` | `No delay` / `-ND` | sì |
| status-line | status-line | Statusline con modello, effort, branch, contesto, quanto resta dei limiti di 5 ore e settimanale e badge delle modalità | `Status line` / `-SL` (attiva) · `-SL off` (disattiva) | |
| spellbook | spellbook | L'help del marketplace: questa tabella | `Spellbook` / `-SB` | |
| clean-slate | (hook) | Igiene dei file temporanei: Claude cancella quelli che crea, ferma i processi in background e chiude ogni task con lo scratchpad vuoto; dopo commit o push chiede `/compact` | Da sola | sì |
| clean-slate | clean-slate | Libera spazio in `/tmp`: sessioni Claude chiuse, file vecchi, log aperti troppo grandi; prima la simulazione, mai file in uso o di altri utenti; Linux e Windows | `Clean slate` / `-CS` · `-CS -s` (solo questa sessione) · `-d GIORNI` · `-i MINUTI` · `-t SIZE` | |
