#!/usr/bin/env bash
# SessionStart: carica niente indugi (anche dopo /clear e compattazione).
# Il flag lo legge la statusline barra-di-stato per il badge nel footer.
# ParceEtRecte: il flag resta se disinstalli il plugin; cancellalo a mano (~/.claude/.sine-more-active).
touch "$HOME/.claude/.sine-more-active"
echo "NIENTE INDUGI ATTIVA — regole caricate all'avvio:"
cat "${CLAUDE_PLUGIN_ROOT}/skills/niente-indugi/SKILL.md"
