# claude-plugins

- Ogni volta che aggiungi, togli o modifichi un plugin, una skill, un comando o una sigla,
  aggiorna `plugins/summa-rerum/skills/summa-rerum/help.md`: è l'help che *Summa rerum* (`-SR`)
  stampa così com'è, e nessuno lo ricostruisce dalle skill.
- Quando una skill, un README o l'help suggeriscono un comando all'utente, scrivono
  l'incantesimo latino con la sigla: *Sequere pulchritudinem* (`-SP`), mai "fai -SP" da solo.
  In fondo è una magia.
- `plugins/` è il set latino, l'unico da scrivere a mano. Dopo ogni modifica lancia
  `python3 lingue/genera.py`: rigenera il set italiano (`lingue/it`), quello inglese (`lingue/en`)
  e i pacchetti `tutto` e `all`. Un comando nuovo vuole prima nomi e sigle in `lingue/genera.py`.
- Le altre regole per aggiungere o modificare un plugin sono nel README, sezione
  "Aggiungere un plugin".
