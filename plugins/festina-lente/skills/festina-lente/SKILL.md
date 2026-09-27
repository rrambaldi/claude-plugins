---
name: festina-lente
description: Festina lente. Esegue un piano con tante attività mentre l'utente non può controllare, senza prendere decisioni che poi costano refactoring - un'attività con un dubbio di quel tipo si ferma, si passa alla successiva che non ne dipende, e i debiti finiscono in un artefatto o file da controllare alla fine. Attivala SEMPRE quando l'utente scrive "Festina lente" o la sigla "-FL" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti o preceduti dal piano). Per far decidere Claude anche sui dubbi usa invece alea-iacta-est.
---

# Festina lente

"Affrettati lentamente": esegui il piano fino in fondo, ma non prendere al
posto dell'utente le decisioni che, se sbagliate, costano refactoring.

## Comandi

| Comando | Sigla | Cosa fa |
|---|---|---|
| Festina lente | -FL | Le attività con decisioni che costano refactoring si fermano e finiscono nel file dei debiti |
| Alea iacta est | -AIE | Claude decide anche quelle: tre opzioni, scelta isolata in un punto, registrata con cosa ci ha costruito sopra |

Le sigle valgono quando compaiono come parola a sé (a inizio o fine messaggio, o da sole), non
quando fanno parte di un'altra parola.

## Quale dubbio ferma un'attività

Chiediti: se questa scelta è sbagliata, quanto costa cambiarla dopo che il
resto del piano ci ha costruito sopra? Ferma l'attività se la scelta:

- è una base per altro: schema dei dati, interfacce tra moduli, struttura di
  file e cartelle, convenzioni che si ripetono in più file;
- aggiunge o cambia una dipendenza, un servizio, una tecnologia;
- cambia cosa vede o usa l'utente finale;
- è uno dei casi in cui anche sine-more-interposita chiederebbe: arriva a una
  persona, non si torna indietro, costa caro.

Una scelta locale, che si cambia in pochi minuti in un solo posto, non ferma
niente: decidi e vai avanti.

## Regole

1. Prima di partire leggi il piano e segna quali attività dipendono da quali.
2. Davanti a un dubbio che ferma: non fare l'attività, nemmeno in parte con una
   scelta provvisoria. Scrivi il debito e passa alla prossima attività che non
   dipende da quelle ferme.
3. Le attività che dipendono da una ferma sono ferme anche loro: segnale nello
   stesso debito.
4. Crea il file al primo debito e aggiornalo subito, non alla fine: se la
   sessione si interrompe, i debiti restano.
5. Alla fine: attività finite, attività ferme, e l'invito a controllare il
   file dei debiti, con link o percorso. Senza debiti, niente file: dillo in
   una riga.

## Il file dei debiti

Un doc claude.ai se hai lo strumento Artifact, altrimenti `DEBITI.md` nella
cartella del progetto. Titolo: "Debiti — <piano>". Una riga per dubbio, i più
bloccanti in cima:

| Attività | Domanda per l'utente | Opzioni che vedo | Perché non ho deciso | Ferme a cascata |
|---|---|---|---|---|

"Opzioni che vedo": quelle vere, con quella che sceglieresti tu, così
l'utente risponde in fretta.
