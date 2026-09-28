#!/usr/bin/env bash
# Armamentarium in Claude Code: toglie ponytail e modalita-fastidio, aggiunge il marketplace e
# installa omnia (tutte le skill, con i loro hook) a livello utente. Si può rilanciare quante
# volte vuoi. I livelli progetto e locale valgono per la cartella da cui lo lanci.
#
#   curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
set -euo pipefail

MARKETPLACE=armamentarium
REPO=rrambaldi/claude-plugins
PLUGIN="omnia@$MARKETPLACE"

command -v claude >/dev/null || { echo "Claude Code non trovato: installalo prima." >&2; exit 1; }

# Una riga "<id> <scope>" per installazione: lo stesso plugin può stare in user, project e local.
installati() {
  claude plugin list --json | awk -F'"' '/"id":/ {id=$4} /"scope":/ {print id, $4}'
}

# Le rimozioni non fermano lo script: se una fallisce lo dice e si va avanti.
togli() {
  claude plugin uninstall "$1" --scope "$2" </dev/null || echo "   ⚠ non tolto $1 ($2), vado avanti" >&2
}

echo "1/4 ponytail"
while read -r id scope; do
  case "$id" in ponytail@*) togli "$id" "$scope" ;; esac
done < <(installati)
marketplace=$(claude plugin marketplace list)
if grep -qw ponytail <<<"$marketplace"; then
  claude plugin marketplace remove ponytail </dev/null || echo "   ⚠ marketplace ponytail non tolto, vado avanti" >&2
fi

echo "2/4 modalita-fastidio"
# Solo le copie locali: l'originale su claude.ai si toglie dalle impostazioni di claude.ai.
for d in "$HOME"/.claude/skills/modalita-fastidio \
         "$HOME"/.claude/skills/synced/*/modalita-fastidio \
         "$HOME"/.claude/plugins/synced/*/modalita-fastidio \
         "$PWD"/.claude/skills/modalita-fastidio; do
  if [ -e "$d" ]; then
    if rm -rf "$d"; then echo "   tolto $d"; else echo "   ⚠ non tolto $d, vado avanti" >&2; fi
  fi
done

echo "3/4 marketplace $MARKETPLACE"
claude plugin marketplace add "$REPO" --scope user
claude plugin marketplace update "$MARKETPLACE"

echo "4/4 $PLUGIN (utente)"
# Solo omnia e solo a livello utente: un plugin singolo, o omnia in un altro livello, fanno
# comparire le skill due volte.
utente=no
while read -r id scope; do
  if [ "$id" = "$PLUGIN" ] && [ "$scope" = user ]; then
    utente=si
  elif [[ "$id" == *@"$MARKETPLACE" ]]; then
    togli "$id" "$scope"
  fi
done < <(installati)
if [ "$utente" = si ]; then
  claude plugin update "$PLUGIN" --scope user
else
  claude plugin install "$PLUGIN" --scope user
fi
out=$(claude plugin enable "$PLUGIN" --scope user 2>&1) || grep -q "already enabled" <<<"$out" || { echo "$out" >&2; exit 1; }

echo "Fatto. Riavvia Claude Code (o scrivi /reload-plugins) per caricare le skill."
