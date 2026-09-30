# UX audit

Due skill che lavorano in coppia su un'applicazione web esistente.

| Skill | Comando | Cosa fa | Modifica il codice |
|---|---|---|---|
| `ux-audit` | `UX audit` / `-UXA` (anche `-UXA rapida`, `-UXA completa`) | Percorre l'app nel browser come la persona che la usa, legge il codice, misura contrasto, overflow, bersagli e accessibilità, valuta composizione ed estetica, propone direzioni di restyle e un piano per fasi | No |
| `apply-restyle` | `Apply restyle` / `-AR` | Applica il piano approvato fase per fase (token, componenti, pagine) e verifica ogni intervento con le stesse misure | Sì, solo le fasi approvate |

## Flusso

1. *UX audit* (`-UXA`) sull'app, in quattro turni: ricognizione del codice, percorso nel browser, misure e
   analisi visiva, sintesi. Dopo ciascuno si ferma: scrivi `prosegui`, o correggi persona e flussi. Il report si
   aggiorna a ogni turno, e alla fine restano due file:
   - `docs/ux/analisi-AAAA-MM-GG.md`, il report;
   - `docs/ux/piano-restyle.md`, il contratto per il restyle.
2. Scegli la direzione (conservativa o trasformativa) e approva una o più fasi nel piano.
3. *Apply restyle* (`-AR`): applica la fase, la verifica nel browser, aggiorna lo stato degli interventi nel piano
   e si ferma prima della fase successiva.

## Requisiti

- Uno strumento browser capace di eseguire JavaScript nella pagina: Playwright MCP in Claude
  Code, oppure Claude in Chrome o il browser integrato in Cowork. Senza, se c'è Node e sei d'accordo
  a scaricarli, usa Playwright con un Chromium headless (`scripts/headless.cjs`). Se non si può,
  l'analisi diventa statica e lo dichiara.
- Accesso al repository dell'app e, se serve, un account di test. Meglio uno staging: la skill
  non esegue azioni irreversibili su dati reali senza consenso.

## Contenuto

```
skills/ux-audit/
  SKILL.md
  references/prove-browser.md    viewport, registro delle prove, console, axe-core, metriche
  references/scenari.md          scenari di stress e sguardo per dominio
  references/criteri-visivi.md   criteri visivi, estetica, catalogo dei cliché
  references/modello-report.md   formato dei rilievi, report, piano per apply-restyle
  scripts/misure.js              contrasto, overflow, bersagli, palette, tipografia nella pagina
skills/apply-restyle/
  SKILL.md
evals/evals.json                 casi di prova per confrontare le skill con Claude senza skill
```

## Fonti

Distillato e riscritto a partire dai materiali in `cantiere/UX`. Le idee di metodo principali
vengono da:
- `ux-audit` e `design-review` di [jezweb/claude-skills](https://github.com/jezweb/claude-skills)
  (licenza MIT): prove d'interazione, verdetto "Incompleto", sguardo del nuovo utente, scenari di
  stress, autocritica dei rilievi, correzione minima;
- `design-visual-frontend` (xialiang98): protagonista, budget di cliché, controlli non
  compensabili, matrice di viewport, verità dei contenuti;
- `huashu-design`: l'estetica generica come perdita d'identità del marchio, segnaposto onesti.

I principi sullo stato epistemico, sui numeri senza base e sulle quote vengono da `critical-review`.
