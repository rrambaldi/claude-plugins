# Modelli: rilievo, report, piano

## Indice

1. Formato del rilievo
2. Report di analisi
3. Piano per applica-restyle (contratto)

## 1. Formato del rilievo

ID con lettera di severità e numero: C1, A1, M1, B1 (Critica, Alta, Media, Bassa).

```markdown
### A3 · Contrasto insufficiente del testo attenuato nelle tabelle
- **Piano:** difetto oggettivo | composizione | carattere
- **Dove:** /fatture, colonna "Scadenza", 1440×900 e 390×844
- **Persona:** impiegata amministrativa
- **Riprodurre:** 1. apri /fatture 2. guarda la colonna Scadenza
- **Osservato:** `#9CA3AF` su `#FFFFFF`, 2.54:1 [M]
- **Atteso:** almeno 4.5:1 per testo di 14px
- **Prova:** uxMisure.contrasto() su /fatture; screenshot fatture-1440.png
- **Nel codice:** `src/styles/tokens.css:18` (`--text-muted`) [C]
- **Correzione minima:** `--text-muted: #6B7280` (4.83:1); nessun altro uso rompe il contrasto
- **Criterio di accettazione:** contrasto() non restituisce voci per `--text-muted` su superfici chiare
- **Fase:** interventi rapidi
```

Un rilievo senza riproduzione, prova e correzione concreta va riscritto o eliminato. Per i rilievi
`[P]` il campo "Atteso" diventa "Proposta" e va motivato.

## 2. Report di analisi

File: `docs/ux/analisi-AAAA-MM-GG.md`

```markdown
# Analisi UX: [nome app]
Data · URL e ambiente · commit analizzato · livello (rapido/standard/completo)
Persona · flussi percorsi · strumenti usati · cosa NON è stato verificato e perché

Legenda: [M] misurato · [V] visto · [C] codice · [S] stimato · [P] preferenza · [?] non verificato

## Verdetto
Pronta | Pronta con riserve | Non pronta | Incompleto
Dimensione più debole: [nome], con la sua prova in una riga
Conteggi: Critica N · Alta N · Media N · Bassa N — autocritica: scritti N, tenuti N, generici N, duplicati N
Controlli: errori console N · warning N · 5xx N · axe Critical/Serious N/N · overflow N · LCP · CLS

## Giudizio per dimensione
| Dimensione | Livello | Prova principale |

## Inventario
Pagine e flussi, stack, sistema di stili, componenti ricorrenti

## Punti di forza (da non toccare)
Ciascuno con prova e motivo

## Rilievi
Raggruppati per severità, nel formato della sezione 1

## Sistema visivo attuale
Palette reale con ruoli e contrasti · scala tipografica reale · spaziature · raggi · ombre · icone
Varianti in eccesso (per esempio 11 grigi, 7 dimensioni di testo)

## Direzioni di restyle
### Conservativa
### Trasformativa
Per ciascuna: personalità · palette con ruoli e contrasti verificati · font e scala · spaziatura,
raggi, superfici · icone e movimento · una pagina reale prima/dopo · compromessi e rischi

## Piano per fasi
Interventi rapidi · sistema visivo · strutturali, con ID dei rilievi, dipendenze e rischio di regressione

## Registro delle prove
(in appendice)

## Se fosse un oggetto
Paragrafo libero [P]
```

## 3. Piano per applica-restyle (contratto)

File: `docs/ux/piano-restyle.md`. È ciò che `applica-restyle` legge: deve bastare da solo, senza il
report. Aggiornalo invece di crearne un altro se esiste già.

```markdown
# Piano di restyle: [nome app]
Origine: docs/ux/analisi-AAAA-MM-GG.md · commit analizzato: abc1234 · URL: ...
Stato del piano: da approvare | approvato fino alla fase N
Direzione scelta: conservativa | trasformativa | da scegliere

## Da non toccare
- [elemento o pattern] — perché funziona — dove (file o pagina)

## Vincoli
Stack e librerie da mantenere, marchio, pagine escluse, browser da supportare

## Token proposti
(blocco CSS o JSON: colori per ruolo chiaro/scuro con contrasti, tipografia, spaziatura, raggi,
ombre, durate di movimento; per ciascuno: nuovo | sostituisce <valore attuale>)

## Interventi
| ID | Fase | Severità | Dove | Correzione minima | Criterio di accettazione | Stato |
|---|---|---|---|---|---|---|
| A3 | 1 rapidi | Alta | tokens.css:18 | --text-muted #6B7280 | contrasto() pulito | da fare |

Stati ammessi: da fare · fatto · verificato · ancora presente · nuovo problema · rinviato

## Fasi
1. Interventi rapidi — [ID…] — verifica: [viewport e misure]
2. Sistema visivo (token e componenti) — [ID…]
3. Strutturali — [ID…]

## Regole anti-regressione
Poche regole da copiare in CLAUDE.md/AGENTS.md dopo il restyle (usa solo i token; un'azione
primaria per area; contrasto verificato prima del merge; …), ciascuna con un esempio giusto e uno
sbagliato
```
