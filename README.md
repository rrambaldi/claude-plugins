# claude-plugins

Armamentarium: plugin personali per Claude.

| Plugin | Cosa fa | Comandi |
|---|---|---|
| limam-adhibere | Analisi critica di un'idea: pro e contro, ipotesi e test, rischi, piano d'azione, criteri di decisione | `Limam adhibere` / `-LA` (completa, tre blocchi) · `Celeri lima adhibita` / `-CLA` (rapida) |
| inspectio-decoris | Analisi UX ed estetica di app web esistenti con prove dal browser e dal codice; restyle applicato e verificato fase per fase | `Inspectio decoris` / `-ID` (analisi: rapida, standard, completa) · `Sequere pulchritudinem` / `-SP` (restyle dal piano approvato) |
| sine-more-interposita | Modalità di lavoro per tutta la sessione: finire davvero, agire invece di chiedere, andare veloce, risposte corte | `/sine-more-interposita` / `-SMI` |
| nec-plus-quam-oportet | Modalità di lavoro per tutta la sessione, basata su ponytail (MIT): la soluzione più semplice che funziona, riuso di codice e API esistenti, costanti, niente duplicati, errori mai ingoiati, `DefunctumEst:` sul codice cancellato; bug corretti partendo da un test che fallisce | `/nec-plus-quam-oportet` / `-NPQO` `[levis\|ultra\|off]` · `Vitium ostendere` / `-VO` |
| festina-lente | Eseguire un piano lungo senza di te: le attività con decisioni che costano refactoring si fermano e finiscono in un file di debiti, oppure Claude le decide, isola la scelta in un punto e la registra | `Festina lente` / `-FL` (ferma e segna i debiti) · `Alea iacta est` / `-AIE` (decide, isola e registra) |
| status-rei | Statusline su richiesta: modello, effort, cartella, branch, contesto usato e badge delle modalità attive (nec plus, sine mora) | `/status-rei` / `-STR` (attiva) · `-STR off` (disattiva) |
| summa-rerum | Help del marketplace: elenca plugin e skill, con cosa fanno, come si attivano e quali sono sempre attive | `Summa rerum` / `/summa-rerum` / `-SR` |

## Installazione in Claude Code

```
/plugin marketplace add rrambaldi/claude-plugins
/plugin install omnia@armamentarium
/plugin install limam-adhibere@armamentarium
/plugin install inspectio-decoris@armamentarium
/plugin install sine-more-interposita@armamentarium
/plugin install nec-plus-quam-oportet@armamentarium
/plugin install festina-lente@armamentarium
/plugin install status-rei@armamentarium
/plugin install summa-rerum@armamentarium
```

La prima riga `install` installa tutto. Le altre servono solo se vuoi un plugin alla volta: non installare entrambe le cose, o ogni skill compare due volte.

Per aggiornare dopo un push: `/plugin marketplace update armamentarium`.

## Aggiungere un plugin

1. Crea `plugins/<nome>/.claude-plugin/plugin.json` e `plugins/<nome>/skills/<nome>/SKILL.md`.
2. Aggiungi la voce in `.claude-plugin/marketplace.json`, e aggiungi le sue skill (e gli hook, se ne ha) alla voce `omnia` dello stesso file.
3. Quando modifichi una skill, incrementa `version` in `plugin.json`, nella sua voce di `marketplace.json` e nella voce `omnia`.
4. Aggiorna `plugins/summa-rerum/skills/summa-rerum/help.md`, l'help che `-SR` stampa così com'è.
