---
name: regole-scritte
description: Scrive, o aggiorna, nel CLAUDE.md del progetto un blocco corto con le regole per il codice (precedenza, riuso, niente duplicati, errori, test, revisione indipendente, commit puliti), così valgono per chiunque usi Claude su quel repo, anche senza plugin. Attivala SEMPRE quando l'utente scrive "Regole scritte" o la sigla "-RS" (con o senza slash, in qualunque combinazione di maiuscole), oppure chiede di mettere queste regole nel repo, per esempio "metti le regole nel CLAUDE.md", "scrivi le regole per il team", "aggiorna le regole nel CLAUDE.md". Non usarla per scrivere nel CLAUDE.md altre istruzioni, che l'utente detta.
---

# Regole scritte

"Legge scritta". Comando: `Regole scritte` o `-RS`, come parola a sé.

Le regole di un plugin valgono solo per chi l'ha installato. Scritte nel CLAUDE.md del progetto
valgono per chiunque usi Claude su quel codice, anche su claude.ai, e cambiano insieme al codice.
Il blocco è corto apposta: il CLAUDE.md si carica a ogni avvio.

## Passi

1. Lancia lo script della cartella `scripts/` di questa skill con la cartella del progetto:
   `python3 <cartella della skill>/scripts/scrivi.py <cartella del progetto>`. Scrive nel
   CLAUDE.md della radice git (o in `.claude/CLAUDE.md`, se c'è solo quello): mette il blocco in
   fondo, o lo aggiorna se c'è già, e il resto del file non lo tocca. Se il file non c'è, lo crea.
2. Riporta all'utente il diff che lo script stampa. Se dice "già aggiornato", basta una riga. Se
   trova il blocco doppio o a metà, si ferma: di' all'utente cosa sistemare, senza correggerlo tu.
3. Non committare: il file è di tutto il team, e il commit lo decide l'utente.

## Cosa c'è nel blocco

- **Dentro**: in breve, le regole sul codice di *Solo il necessario*, il test prima del fix di
  *Prima il test*, la soglia di *Occhi nuovi* e i due controlli di *Cave canem*.
  Scritti come regole, senza comandi né nomi di skill: chi legge può non avere il plugin.
- **Fuori**: il tono delle risposte (*Niente indugi*) e i file temporanei
  (*Fai pulizia*), che sono gusti di chi usa il plugin, non regole del progetto. E l'hook di
  *Cave canem*: in un CLAUDE.md un hook non gira.

Il testo è `regole.md`, accanto a questa skill. Le regole proprie del progetto vanno fuori dal
blocco: dentro, il comando le sovrascrive.

Il blocco è una regola del progetto, non una modalità: `-SN leggero`, `ultra` e `off` non lo
toccano. Al livello di default, se trova il blocco, *Solo il necessario* all'avvio non ricarica
le sue regole complete nel contesto principale: bastano quelle corte, e la skill si carica quando
si scrive codice. Agli altri livelli le ricarica, perché servono per sapere cosa cambia. I
subagent le ricevono sempre.
