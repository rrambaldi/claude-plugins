| Plugin | Skill | Cosa fa | Come si attiva | Sempre attiva |
|---|---|---|---|---|
| cave-canem | (solo hook) | Prima di un `git commit` lanciato da Claude lo ferma se ci trova segreti (chiavi, token, password in chiaro, `.env`, chiavi private) o file cambiati prima della sessione, cioè non del task | Da solo. `CAVE_CANEM=perimetro` davanti a `git commit` salta il controllo sui file; con `CAVE_CANEM=segreti` decidi tu, da una richiesta di permesso | sì |
| make-haste-slowly | the-die-is-cast | Esegue un piano lungo senza fermarsi: sulle decisioni costose sceglie tra tre opzioni e registra la scelta | `The die is cast` / `-TDC` | |
| make-haste-slowly | make-haste-slowly | Esegue un piano lungo senza decidere al posto tuo: i dubbi costosi si fermano e finiscono in un file da controllare | `Make haste slowly` / `-MHS` | |
| ux-audit | ux-audit | Analisi UX ed estetica di un'app web esistente, in quattro turni, con prove dal browser (anche headless) e dal codice | `UX audit` / `-UXA` | |
| ux-audit | apply-restyle | Applica un restyle già approvato, fase per fase, e lo verifica nel browser | `Apply restyle` / `-AR` | |
| critical-review | swot-analysis | Analisi SWOT: forze e debolezze, opportunità e minacce, poi gli incroci che dicono cosa farne | `SWOT analysis` / `-SWOT` | |
| critical-review | critical-review | Pensiero critico su un'idea: niente codice né piani | `Critical review` / `-CR` (completa) · `Quick critique` / `-QC` (rapida: 5 pregi, 5 difetti, 5 miglioramenti, 5 pensieri laterali) · `Devil's advocate` / `-DA` (solo contro) | |
| critical-review | pariksam-kuru | *Critical review* con l'incantesimo in sanscrito | `Parīkṣāṃ kuru` / `-PK` (completa) · `Śīghraṃ parīkṣāṃ kuru` / `-SPK` (rapida) | |
| critical-review | profar-syniad | *Critical review* con l'incantesimo in gallese, la lingua di Merlino | `Profa'r syniad` / `-PS` (completa) · `Profa'r syniad yn gyflym` / `-PSG` (rapida) | |
| critical-review | qech-yipoj | *Critical review* con l'incantesimo in klingon | `qech yIpoj` / `-QP` (completa) · `nom qech yIpoj` / `-NQP` (rapida) | |
| critical-review | sanwe-kenta | *Critical review* con l'incantesimo in quenya, l'elfico di Tolkien | `Sanwe-kenta` / `-SK` (completa) · `Linta sanwe-kenta` / `-LSK` (rapida) | |
| keep-it-simple | house-rules | Scrive o aggiorna nel CLAUDE.md del progetto un blocco corto con le regole per il codice, per chiunque usi Claude su quel repo; mostra il diff e non committa. Con il blocco, all'avvio *Keep it simple* (livello di default) non ricarica le regole complete | `House rules` / `-HR` | |
| keep-it-simple | keep-it-simple | La soluzione più semplice che funziona: riuso, costanti, niente duplicati, marcatori `ParceEtRecte:` e `DefunctumEst:` | `Keep it simple` / `-KIS` · `-KIS lite` · `-KIS ultra` · `-KIS off` / `stop keep it simple` | sì |
| keep-it-simple | fresh-eyes | Fa rivedere il diff da un subagente che non l'ha scritto, con solo il task e il diff; parte da sola prima di chiudere un diff sopra le 50 righe o i 3 file, o che tocca soldi, dati o sicurezza | `Fresh eyes` / `-FE` · `-FE` seguito da un commit, un intervallo o una PR | |
| keep-it-simple | test-first | Corregge un bug partendo da un test che fallisce: da rosso a verde | `Test first` / `-TF` | |
| nomen-mutare | (solo hook) | Ogni 10 prompt dà alla sessione un titolo nuovo, come `/rename`, scritto da Haiku sugli ultimi prompt | Da sola. Ogni quanti prompt: `NOMEN_MUTARE_OGNI` in `env` dei settings; `0` la spegne | sì |
| no-delay | no-delay | Finire davvero, agire invece di chiedere, andare veloce, risposte corte in italiano facile; non tocca il lavoro di `-CR` / `-QC` / `-DA` / `-SWOT`, neanche con i loro incantesimi in altre lingue | `No delay` / `-ND` | sì |
| status-line | status-line | Statusline con modello, effort, branch, contesto, quanto resta dei limiti di 5 ore e settimanale e badge delle modalità | `Status line` / `-SL` (attiva) · `-SL off` (disattiva) | |
| spellbook | spellbook | L'help del marketplace: questa tabella | `Spellbook` / `-SB` | |
| clean-slate | (hook) | Igiene dei file temporanei: Claude cancella quelli che crea, ferma i processi in background e chiude ogni task con lo scratchpad vuoto; dopo commit o push chiede `/compact` | Da sola | sì |
| clean-slate | clean-slate | Libera spazio in `/tmp`: sessioni Claude chiuse, file vecchi, log aperti troppo grandi; prima la simulazione, mai file in uso o di altri utenti; Linux e Windows | `Clean slate` / `-CS` · `-CS -s` (solo questa sessione) · `-d GIORNI` · `-i MINUTI` · `-t SIZE` | |
