---
name: fai-pulizia
description: Fai pulizia. Libera spazio in /tmp (%TEMP% su Windows) con gli script tmp-clean - sessioni Claude chiuse, file vecchi, log aperti troppo grandi - senza toccare file in uso, sessioni Claude vive o file di altri utenti; prima la simulazione, poi cancella dopo il sì dell'utente. Attivala SEMPRE quando l'utente scrive "Fai pulizia" o la sigla "-FP" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti da opzioni come -s, -d, -i, -t), oppure chiede di pulire /tmp, liberare spazio in /tmp, cancellare le vecchie sessioni Claude da /tmp o svuotare lo scratchpad di questa sessione. Funziona su Linux e Windows, non su macOS.
---

# fai pulizia

Comando: `/fai-pulizia` o `-FP`, come parola a sé, seguito o no da opzioni.

Gli script sono nella cartella `scripts/` di questa skill, con le stesse opzioni:

- Linux: `bash scripts/tmp-clean.sh [opzioni]`. Pulisce solo la roba dell'utente che lo
  lancia: mai con sudo, e da root si rifiuta.
- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/tmp-clean.ps1 [opzioni]`.
  Pulisce solo `%TEMP%`, che è dell'utente. Non ha `-t`, e `-s` svuota solo lo scratchpad.

| Richiesta | Cosa lanci |
|---|---|
| `-FP` | lo script senza opzioni: sessioni Claude chiuse, file dell'utente non toccati da 7 giorni, file cancellati ma ancora aperti (solo elencati) |
| `-FP sessione` o `-FP -s` | `-s`: solo questa sessione, i file non in uso di scratchpad e task |
| `-FP -d 3`, `-FP -i 30`, `-FP -t 500M` | le opzioni così come sono; `-h` le elenca (su Linux) |

Su macOS non c'è uno script: dillo, senza improvvisare.

Qui l'utente chiede di pulire anche fuori da questa sessione: vale la sua richiesta, non la
regola sui file temporanei che ti fa cancellare solo i tuoi.

## Passi

1. Lancia lo script con le opzioni della richiesta, senza `-y`: è la simulazione, non tocca niente.
2. Riassumi in poche righe: quanto si libera, le voci più grandi, cosa resta e perché.
3. Chiedi conferma, perché cancellare non si annulla. Con `-s` non serve: sono i file temporanei
   di questa sessione, che la regola ti fa già cancellare. Se tra questi c'è qualcosa da tenere,
   prima spostalo nel progetto e dillo.
4. Rilancia con le stesse opzioni più `-y` e di' quanto spazio si è liberato.

Le sessioni Claude vive restano con qualunque `-i`: il loro pid è in `~/.claude/sessions/`.
Con `-t` lo script tronca log ancora aperti, e il processo che li scrive ne perde il contenuto:
dillo prima di chiedere conferma.
