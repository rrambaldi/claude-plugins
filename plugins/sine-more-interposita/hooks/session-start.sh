#!/usr/bin/env bash
# SessionStart: carica sine more interposita (anche dopo /clear e compattazione).
# Il flag lo legge la statusline status-rei per il badge nel footer.
# ParceEtRecte: il flag resta se disinstalli il plugin; cancellalo a mano (~/.claude/.sine-more-active).
touch "$HOME/.claude/.sine-more-active"
echo "SINE MORE INTERPOSITA ATTIVA — regole caricate all'avvio:"
cat "${CLAUDE_PLUGIN_ROOT}/skills/sine-more-interposita/SKILL.md"
