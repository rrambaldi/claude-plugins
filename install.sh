#!/usr/bin/env bash
# Armamentarium in Claude Code: toglie ponytail e modalita-fastidio, aggiunge il marketplace e
# installa omnia (tutte le skill, con i loro hook). Si può rilanciare quante volte vuoi.
#
#   curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
set -euo pipefail

MARKETPLACE=armamentarium
REPO=rrambaldi/claude-plugins
PLUGIN="omnia@$MARKETPLACE"
SINGOLI="limam-adhibere inspectio-decoris sine-more-interposita nec-plus-quam-oportet festina-lente status-rei summa-rerum"

command -v claude >/dev/null || { echo "Claude Code non trovato: installalo prima." >&2; exit 1; }

installati=$(claude plugin list --json)
marketplace=$(claude plugin marketplace list)

echo "1/4 ponytail"
for id in $(grep -o '"ponytail@[^"]*"' <<<"$installati" | tr -d '"'); do
  claude plugin uninstall "$id"
done
if grep -qw ponytail <<<"$marketplace"; then
  claude plugin marketplace remove ponytail
fi

echo "2/4 modalita-fastidio"
# Solo le copie locali: l'originale su claude.ai si toglie dalle impostazioni di claude.ai.
for d in "$HOME"/.claude/skills/modalita-fastidio \
         "$HOME"/.claude/skills/synced/*/modalita-fastidio \
         "$HOME"/.claude/plugins/synced/*/modalita-fastidio; do
  if [ -e "$d" ]; then
    rm -rf "$d"
    echo "   tolto $d"
  fi
done

echo "3/4 marketplace $MARKETPLACE"
claude plugin marketplace add "$REPO"
claude plugin marketplace update "$MARKETPLACE"

echo "4/4 $PLUGIN"
# Un plugin singolo installato insieme a omnia fa comparire le sue skill due volte.
for p in $SINGOLI; do
  if grep -q "\"$p@$MARKETPLACE\"" <<<"$installati"; then
    claude plugin uninstall "$p@$MARKETPLACE"
  fi
done
if grep -q "\"$PLUGIN\"" <<<"$installati"; then
  claude plugin update "$PLUGIN"
else
  claude plugin install "$PLUGIN"
fi
out=$(claude plugin enable "$PLUGIN" 2>&1) || grep -q "already enabled" <<<"$out" || { echo "$out" >&2; exit 1; }

echo "Fatto. Riavvia Claude Code (o scrivi /reload-plugins) per caricare le skill."
