---
name: summa-rerum
description: L'help del marketplace - elenca i plugin e le skill contenuti in questo marketplace, con cosa fanno, come si attivano e quali sono sempre attive. Usala quando l'utente scrive "summa rerum", "/summa-rerum" o la sigla "-SR" (con o senza slash, maiuscole o minuscole), oppure chiede aiuto su plugin, skill o comandi, per esempio "help", "aiuto", "che comandi ho", "quali skill ho qui", "elenca le skill del marketplace", "cosa c'è nei miei plugin".
---

# summa rerum

Comando: `/summa-rerum` o `-SR`, come parola a sé.

1. Leggi il frontmatter di tutte le skill del marketplace che contiene questo
   plugin:

   ```bash
   for f in ~/.claude/plugins/marketplaces/*/plugins/summa-rerum/../*/skills/*/SKILL.md; do
     [ -f "$f" ] || continue
     echo "== ${f#*/../}" && sed -n '2,/^---$/p' "$f"
     skill=$(basename "$(dirname "$f")")
     grep -rqs "skills/$skill/" "${f%/skills/*}/hooks" && echo "SEMPRE ATTIVA: la carica un hook a ogni avvio"
   done
   ```

   Se non trova niente, il marketplace non è installato: dillo in una frase.

2. Rispondi con una tabella, una riga per skill:

   | Plugin | Skill | Cosa fa | Come si attiva | Sempre attiva |
   |---|---|---|---|---|

   - **Plugin**: la cartella sotto `plugins/`.
   - **Cosa fa**: una frase corta, presa dalla `description`.
   - **Come si attiva**: i comandi e le sigle della `description`, compresi
     livelli e spegnimento, non tutte le frasi di esempio.
   - **Sempre attiva**: "sì" se lo script ha stampato `SEMPRE ATTIVA`,
     altrimenti vuoto.

   Niente altro dopo la tabella.
