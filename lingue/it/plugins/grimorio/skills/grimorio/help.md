| Plugin | Skill | Cosa fa | Come si attiva | Sempre attiva |
|---|---|---|---|---|
| chi-va-piano | il-dado-e-tratto | Esegue un piano lungo senza fermarsi: sulle decisioni costose sceglie tra tre opzioni e registra la scelta | `Il dado è tratto` / `-DT` | |
| chi-va-piano | chi-va-piano | Esegue un piano lungo senza decidere al posto tuo: i dubbi costosi si fermano e finiscono in un file da controllare | `Chi va piano` / `-CVP` | |
| analisi-ux | analisi-ux | Analisi UX ed estetica di un'app web esistente, con prove dal browser e dal codice | `Analisi UX` / `-AUX` | |
| analisi-ux | applica-restyle | Applica un restyle già approvato, fase per fase, e lo verifica nel browser | `Applica restyle` / `-AR` | |
| analisi-critica | analisi-swot | Analisi SWOT: forze e debolezze, opportunità e minacce, poi gli incroci che dicono cosa farne | `Analisi SWOT` / `-SWOT` | |
| analisi-critica | analisi-critica | Pensiero critico su un'idea: niente codice né piani | `Analisi critica` / `-AC` (completa) · `Critica veloce` / `-CV` (rapida: 5 pregi, 5 difetti, 5 miglioramenti, 5 pensieri laterali) · `Avvocato del diavolo` / `-AD` (solo contro) | |
| solo-il-necessario | solo-il-necessario | La soluzione più semplice che funziona: riuso, costanti, niente duplicati, marcatori `ParceEtRecte:` e `DefunctumEst:` | `Solo il necessario` / `-SN` · `-SN leggero` · `-SN ultra` · `-SN off` / `stop solo il necessario` | sì |
| solo-il-necessario | prima-il-test | Corregge un bug partendo da un test che fallisce: da rosso a verde | `Prima il test` / `-PT` | |
| nomen-mutare | (solo hook) | Ogni 10 prompt dà alla sessione un titolo nuovo, come `/rename`, scritto da Haiku sugli ultimi prompt | Da sola. Ogni quanti prompt: `NOMEN_MUTARE_OGNI` in `env` dei settings; `0` la spegne | sì |
| niente-indugi | niente-indugi | Finire davvero, agire invece di chiedere, andare veloce, risposte corte in italiano facile; non tocca il lavoro di `-AC` / `-CV` / `-AD` / `-SWOT` | `Niente indugi` / `-NI` | sì |
| barra-di-stato | barra-di-stato | Statusline con modello, effort, branch, contesto, quanto resta dei limiti di 5 ore e settimanale e badge delle modalità | `Barra di stato` / `-BDS` (attiva) · `-BDS off` (disattiva) | |
| grimorio | grimorio | L'help del marketplace: questa tabella | `Grimorio` / `-GR` | |
| fai-pulizia | (hook) | Igiene dei file temporanei: Claude cancella quelli che crea, ferma i processi in background e chiude ogni task con lo scratchpad vuoto; dopo commit o push chiede `/compact` | Da sola | sì |
| fai-pulizia | fai-pulizia | Libera spazio in `/tmp`: sessioni Claude chiuse, file vecchi, log aperti troppo grandi; prima la simulazione, mai file in uso o di altri utenti; Linux e Windows | `Fai pulizia` / `-FP` · `-FP -s` (solo questa sessione) · `-d GIORNI` · `-i MINUTI` · `-t SIZE` | |
