---
name: alea-iacta-est
description: Alea iacta est. Esegue un piano con tante attività mentre l'utente non può controllare, senza fermarsi - sulle decisioni che costano refactoring scrive almeno tre opzioni, sceglie, isola la scelta in un solo punto e la registra in un artefatto con cosa ci ha costruito sopra. Attivala SEMPRE quando l'utente scrive "Alea iacta est" o la sigla "-AIE" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti o preceduti dal piano). Per fermare invece quelle attività e lasciar decidere l'utente usa festina-lente.
---

# Alea iacta est

"Il dado è tratto": esegui il piano fino in fondo e decidi tu, anche dove
festina lente si fermerebbe. Ma ogni decisione deve costare poco da cambiare,
e resta scritta.

## Comandi

| Comando | Sigla | Cosa fa |
|---|---|---|
| Festina lente | -FL | Le attività con decisioni che costano refactoring si fermano e finiscono nel file dei debiti |
| Alea iacta est | -AIE | Claude decide anche quelle: tre opzioni, scelta isolata in un punto, registrata con cosa ci ha costruito sopra |

Le sigle valgono quando compaiono come parola a sé (a inizio o fine messaggio, o da sole), non
quando fanno parte di un'altra parola.

## Quale dubbio conta

Lo stesso di festina-lente. Chiediti: se questa scelta è sbagliata, quanto
costa cambiarla dopo che il resto del piano ci ha costruito sopra? Conta se la
scelta:

- è una base per altro: schema dei dati, interfacce tra moduli, struttura di
  file e cartelle, convenzioni che si ripetono in più file;
- aggiunge o cambia una dipendenza, un servizio, una tecnologia;
- cambia cosa vede o usa l'utente finale.

Una scelta locale, che si cambia in pochi minuti in un solo posto, non conta:
decidi e vai avanti, senza registrarla.

## Regole

1. Prima di partire leggi il piano, segna quali attività dipendono da quali e
   crea l'artefatto delle decisioni. Aggiornalo mentre lavori, non alla fine.
2. Davanti a un dubbio che conta scrivi almeno tre opzioni davvero diverse.
   "Non farlo" o "rimandare" contano come opzioni, se sono sensate.
3. Scegli quella che serve meglio lo scopo del piano; a parità, quella più
   facile da cambiare dopo. Poi prosegui.
4. Isola la scelta: mettila in un solo punto (una funzione, un modulo, una
   chiave di configurazione) e fai passare da lì il resto del piano. Se la
   decisione è sbagliata, si cambia lì e non in venti file.
5. Tre casi non li decidi, come in festina-lente: qualcosa che arriva a una
   persona, qualcosa da cui non si torna indietro, qualcosa che costa caro.
   Ferma l'attività e quelle che ne dipendono, scrivi il debito, passa alla
   prossima libera.
6. Alla fine: attività finite, decisioni prese, attività ferme, e l'invito a
   controllare l'artefatto, con link o percorso.

## L'artefatto delle decisioni

Un doc claude.ai se hai lo strumento Artifact, altrimenti `DECISIONI.md`
nella cartella del progetto. Titolo: "Decisioni — <piano>". Lo crei sempre:
senza decisioni, lo dice in una riga.

Una decisione sotto l'altra, mai in tabella: le frasi strette nelle celle
non si leggono. In cima quelle con più attività costruite sopra, perché sono
quelle che costano di più se sbagliate. Ogni decisione è un titolo numerato
con sei punti:

```markdown
### 1. <la decisione, in poche parole>

- **Scelta:** l'opzione presa.
- **Perché:** una o due frasi.
- **Scartate:**
    - un'opzione per riga;
    - anche "non farlo" o "rimandare", se erano sensate.
- **Dove si cambia:** il punto in cui hai isolato la scelta (file, funzione, chiave).
- **Ci poggia sopra:** le attività del piano che dipendono da questa scelta.
- **Da controllare:** cosa guardare per sapere se la scelta era giusta.
```

Sotto, se ci sono, i debiti dei tre casi, come in festina-lente: un'attività
ferma sotto l'altra.

```markdown
### <l'attività ferma>

- **Domanda per l'utente:** la domanda, fatta perché si risponda in fretta.
- **Opzioni che vedo:**
    - un'opzione per riga, per prima quella che sceglieresti tu, segnata "(la mia)".
- **Perché non ho deciso:** quale dei tre casi.
- **Ferme a cascata:** le attività che aspettano la risposta.
```

In fondo lo stato del piano: un titolo per attività, con i punti **Fatto**
(cosa c'è adesso) e **Provato** (come l'hai verificato).
