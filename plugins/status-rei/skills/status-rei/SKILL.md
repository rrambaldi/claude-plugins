---
name: status-rei
description: Attiva o disattiva la statusline status-rei in Claude Code - modello, effort, cartella, branch, contesto usato, quanto resta dei limiti di 5 ore e settimanale e badge delle modalità attive (nec plus, sine mora). Modifica file dell'utente, quindi usala solo su richiesta esplicita, per esempio "/status-rei", la sigla "-STR" (attiva) o "-STR off" (disattiva), con o senza slash e in qualunque combinazione di maiuscole, "status rei", "attiva status-rei", "attiva la statusline", "togli status-rei", "disattiva la statusline".
---

# status rei

Comando: `/status-rei` o `-STR` per attivare, `-STR off` per disattivare.

La statusline è `statusline.py`, nella stessa cartella di questa skill.
I badge delle modalità leggono i flag che i loro hook creano in `~/.claude/`:
`.nec-plus-active`, `.sine-more-active`.

## Attivare

1. Copia `statusline.py` di questa cartella in `~/.claude/status-rei.py`.
   Si copia perché la cartella del plugin cambia a ogni versione.
2. Leggi la chiave `statusLine` in `~/.claude/settings.json`. Se c'è ed è
   diversa da quella del punto 3, salvala così com'è in
   `~/.claude/status-rei.prev.json`, per poterla rimettere.
3. Imposta solo questa chiave, senza toccare le altre:

   ```json
   "statusLine": { "type": "command", "command": "python3 ~/.claude/status-rei.py" }
   ```

4. Prova: `echo '{"model":{"display_name":"test"}}' | python3 ~/.claude/status-rei.py`
   deve stampare una riga con `◆ test`.
5. Di' all'utente cosa hai cambiato e che la statusline compare al prossimo
   aggiornamento.

Dopo un aggiornamento del plugin, rilancia la skill per copiare lo script nuovo.

## Disattivare

Se esiste `~/.claude/status-rei.prev.json`, rimetti quel valore in
`statusLine` e cancella il file. Se non esiste, togli la chiave `statusLine`.
Poi cancella `~/.claude/status-rei.py`.
