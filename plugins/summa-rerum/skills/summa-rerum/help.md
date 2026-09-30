| Plugin | Skill | Cosa fa | Come si attiva | Sempre attiva |
|---|---|---|---|---|
| festina-lente | alea-iacta-est | Esegue un piano lungo senza fermarsi: sulle decisioni costose sceglie tra tre opzioni e registra la scelta | `Alea iacta est` / `-AIE` | |
| festina-lente | festina-lente | Esegue un piano lungo senza decidere al posto tuo: i dubbi costosi si fermano e finiscono in un file da controllare | `Festina lente` / `-FL` | |
| inspectio-decoris | inspectio-decoris | Analisi UX ed estetica di un'app web esistente, in quattro turni, con prove dal browser (anche headless) e dal codice | `Inspectio decoris` / `-ID` | |
| inspectio-decoris | sequere-pulchritudinem | Applica un restyle già approvato, fase per fase, e lo verifica nel browser | `Sequere pulchritudinem` / `-SP` | |
| limam-adhibere | intus-et-extra | Analisi SWOT: forze e debolezze, opportunità e minacce, poi gli incroci che dicono cosa farne | `Intus et extra` / `-IE` | |
| limam-adhibere | limam-adhibere | Pensiero critico su un'idea: niente codice né piani | `Limam adhibere` / `-LA` (completa) · `Celeri lima adhibita` / `-CLA` (rapida: 5 pregi, 5 difetti, 5 miglioramenti, 5 pensieri laterali) · `Advocatus diaboli` / `-AD` (solo contro) | |
| nec-plus-quam-oportet | nec-plus-quam-oportet | La soluzione più semplice che funziona: riuso, costanti, niente duplicati, marcatori `ParceEtRecte:` e `DefunctumEst:` | `Nec plus quam oportet` / `-NPQO` · `-NPQO levis` · `-NPQO ultra` · `-NPQO off` / `stop nec plus` | sì |
| nec-plus-quam-oportet | vitium-ostendere | Corregge un bug partendo da un test che fallisce: da rosso a verde | `Vitium ostendere` / `-VO` | |
| nomen-mutare | (solo hook) | Ogni 10 prompt dà alla sessione un titolo nuovo, come `/rename`, scritto da Haiku sugli ultimi prompt | Da sola. Ogni quanti prompt: `NOMEN_MUTARE_OGNI` in `env` dei settings; `0` la spegne | sì |
| sine-more-interposita | sine-more-interposita | Finire davvero, agire invece di chiedere, andare veloce, risposte corte in italiano facile; non tocca il lavoro di `-LA` / `-CLA` / `-AD` / `-IE` | `Sine more interposita` / `-SMI` | sì |
| status-rei | status-rei | Statusline con modello, effort, branch, contesto, quanto resta dei limiti di 5 ore e settimanale e badge delle modalità | `Status rei` / `-STR` (attiva) · `-STR off` (disattiva) | |
| summa-rerum | summa-rerum | L'help del marketplace: questa tabella | `Summa rerum` / `-SR` | |
| tabula-rasa | (hook) | Igiene dei file temporanei: Claude cancella quelli che crea, ferma i processi in background e chiude ogni task con lo scratchpad vuoto; dopo commit o push chiede `/compact` | Da sola | sì |
| tabula-rasa | tabula-rasa | Libera spazio in `/tmp`: sessioni Claude chiuse, file vecchi, log aperti troppo grandi; prima la simulazione, mai file in uso o di altri utenti; Linux e Windows | `Tabula rasa` / `-TR` · `-TR -s` (solo questa sessione) · `-d GIORNI` · `-i MINUTI` · `-t SIZE` | |
