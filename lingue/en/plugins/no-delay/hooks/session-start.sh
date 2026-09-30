#!/usr/bin/env bash
# SessionStart: carica no delay (anche dopo /clear e compattazione).
# Il flag lo legge la statusline status-line per il badge nel footer.
# ParceEtRecte: il flag resta se disinstalli il plugin; cancellalo a mano (~/.claude/.sine-more-active).
touch "$HOME/.claude/.sine-more-active"
echo "NO DELAY ATTIVA — regole caricate all'avvio:"
cat "${CLAUDE_PLUGIN_ROOT}/skills/no-delay/SKILL.md"
