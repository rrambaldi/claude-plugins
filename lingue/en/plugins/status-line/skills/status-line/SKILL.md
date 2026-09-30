---
name: status-line
description: Attiva o disattiva la statusline status-line in Claude Code - modello, effort, cartella, branch, contesto usato, quanto resta dei limiti di 5 ore e settimanale e badge delle modalità attive (nec plus, sine mora). Modifica file dell'utente, quindi usala solo su richiesta esplicita, per esempio "/status-line", la sigla "-SL" (attiva) o "-SL off" (disattiva), con o senza slash e in qualunque combinazione di maiuscole, "status line", "attiva status-line", "attiva la statusline", "togli status-line", "disattiva la statusline".
---

# status line

Comando: `/status-line` o `-SL` per attivare, `-SL off` per disattivare.

La statusline è `statusline.py`, nella stessa cartella di questa skill.
I badge delle modalità leggono i flag che i loro hook creano in `~/.claude/`:
`.nec-plus-active`, `.sine-more-active`.

## Attivare

1. Copia `statusline.py` di questa cartella in `~/.claude/status-line.py`.
   Si copia perché la cartella del plugin cambia a ogni versione.
2. Leggi la chiave `statusLine` in `~/.claude/settings.json`. Se c'è ed è
   diversa da quella del punto 3, salvala così com'è in
   `~/.claude/status-line.prev.json`, per poterla rimettere.
3. Imposta solo questa chiave, senza toccare le altre:

   ```json
   "statusLine": { "type": "command", "command": "python3 ~/.claude/status-line.py" }
   ```

4. Prova: `echo '{"model":{"display_name":"test"}}' | python3 ~/.claude/status-line.py`
   deve stampare una riga con `◆ test`.
5. Di' all'utente cosa hai cambiato e che la statusline compare al prossimo
   aggiornamento.

Dopo un aggiornamento del plugin, rilancia la skill per copiare lo script nuovo.

## Disattivare

Se esiste `~/.claude/status-line.prev.json`, rimetti quel valore in
`statusLine` e cancella il file. Se non esiste, togli la chiave `statusLine`.
Poi cancella `~/.claude/status-line.py`.
