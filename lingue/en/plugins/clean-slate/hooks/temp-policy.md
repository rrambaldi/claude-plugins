# File temporanei e scratchpad

Lo scratchpad e i file temporanei non vengono puliti automaticamente: li cancelli tu, sempre.

- Cancella ogni file temporaneo appena non ti serve più, senza aspettare la fine della sessione.
  I file grandi (audio, video, dataset, archivi, dump, oltre ~100 MB) vanno eliminati subito
  dopo l'uso.
- Prima di chiudere ogni task, svuota lo scratchpad della sessione (il contenuto, non la
  directory) e rimuovi gli altri file che hai creato in /tmp. Se un file va tenuto, prima
  spostalo nel progetto e dillo all'utente.
- A fine task non lasciare processi in background attivi: fermali e cancella i loro file di
  output. Per i processi lunghi o verbosi, manda stdout/stderr su un log nel progetto
  (cmd > logs/nome.log 2>&1) invece che nell'output catturato.
- Cancella solo i file che hai creato tu in questa sessione, mai file dell'utente o di altre
  sessioni.
- Prima della risposta finale, controlla con du -sh che lo scratchpad sia vuoto.

# Dopo commit e push

Dopo un commit, un push o tutti e due, chiudi la risposta chiedendo all'utente di compattare la
chat con `/compact`, una volta sola. Tu non puoi lanciarlo: è un comando che scrive l'utente.
