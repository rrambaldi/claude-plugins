# claude-plugins

Plugin personali per Claude.

| Plugin | Cosa fa | Comandi |
|---|---|---|
| limam-adhibere | Analisi critica di un'idea: pro e contro, ipotesi e test, rischi, piano d'azione, criteri di decisione | `Limam adhibere` / `-LA` (completa, tre blocchi) · `Celeri lima adhibita` / `-CLA` (rapida) |
| inspectio-decoris | Analisi UX ed estetica di app web esistenti con prove dal browser e dal codice; restyle applicato e verificato fase per fase | `Inspectio decoris` / `-ID` (analisi: rapida, standard, completa) · `Sequere pulchritudinem` / `-SP` (restyle dal piano approvato) |

## Installazione in Claude Code

```
/plugin marketplace add rrambaldi/claude-plugins
/plugin install limam-adhibere@rrambaldi-plugins
/plugin install inspectio-decoris@rrambaldi-plugins
```

Per aggiornare dopo un push: `/plugin marketplace update rrambaldi-plugins`.

## Aggiungere un plugin

1. Crea `plugins/<nome>/.claude-plugin/plugin.json` e `plugins/<nome>/skills/<nome>/SKILL.md`.
2. Aggiungi la voce in `.claude-plugin/marketplace.json`.
3. Quando modifichi una skill, incrementa `version` sia in `plugin.json` sia in `marketplace.json`.
