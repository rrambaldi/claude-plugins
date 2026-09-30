#!/usr/bin/env bash
# Hook di keep it simple. Senza argomenti: SessionStart (anche dopo /clear e
# compattazione). "subagent": SubagentStart. "prompt": UserPromptSubmit, segue il livello.
# Il livello (full, lite, ultra, off) sta nel flag, che la statusline legge per il badge.
# ParceEtRecte: un flag solo per tutte le sessioni aperte; un file per session_id se ne usi più insieme.
# ParceEtRecte: il flag resta se disinstalli il plugin; cancellalo a mano (~/.claude/.nec-plus-active).
FLAG="$HOME/.claude/.nec-plus-active"
RULES="${CLAUDE_PLUGIN_ROOT}/skills/keep-it-simple/SKILL.md"
mode=$(head -1 "$FLAG" 2>/dev/null)
mode=${mode:-full}

case "$1" in
  subagent)
    [ "$mode" = off ] && exit
    # Il contesto di SessionStart non arriva ai subagent, e per loro lo stdout semplice
    # viene scartato: serve il JSON hookSpecificOutput.
    python3 -c 'import json, sys
rules = "KEEP IT SIMPLE ATTIVA — livello " + sys.argv[2] + " — regole:\n" + open(sys.argv[1]).read()
print(json.dumps({"hookSpecificOutput": {"hookEventName": "SubagentStart", "additionalContext": rules}}))' "$RULES" "$mode"
    ;;
  prompt)
    # Conta solo se il messaggio comincia con il comando: citarlo a metà frase non cambia niente.
    # Sigla e nomi scritti come nella skill: lingue/genera.py li traduce per gli altri set.
    new=$(python3 -c 'import json, re, sys
p = json.load(sys.stdin).get("prompt", "").strip()
m = re.match(r"/?(-KIS|keep-it-simple|keep it simple)\b(\s+(lite|lite|full|ultra|off)\b)?", p, re.I)
if m:
    livello = (m.group(3) or "full").lower()
    print({"lite": "lite"}.get(livello, livello))
elif re.match(r"(stop keep it simple|normal mode)\b", p, re.I):
    print("off")')
    [ -z "$new" ] || echo "$new" > "$FLAG"
    ;;
  *)
    # Una sessione nuova riparte da full; /clear, compattazione e resume tengono il livello.
    source=$(python3 -c 'import json, sys; print(json.load(sys.stdin).get("source", ""))' 2>/dev/null)
    [ "$source" = startup ] && mode=full
    echo "$mode" > "$FLAG"
    [ "$mode" = off ] && exit
    # Con il blocco di house-rules nel CLAUDE.md del progetto, al livello full le regole corte
    # bastano: le complete restano nella skill, e i subagent le ricevono comunque. Lo script lo
    # scrive nella radice git, anche in .claude/.
    dir=${CLAUDE_PROJECT_DIR:-$PWD}
    root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || echo "$dir")
    if [ "$mode" = full ] && grep -qsF '<!-- armamentarium:inizio' \
        "$dir/CLAUDE.md" "$dir/.claude/CLAUDE.md" "$root/CLAUDE.md" "$root/.claude/CLAUDE.md"; then
      echo "KEEP IT SIMPLE ATTIVA — livello $mode — regole corte nel CLAUDE.md del progetto; quelle complete sono nella skill keep-it-simple: caricala quando scrivi codice."
      exit
    fi
    echo "KEEP IT SIMPLE ATTIVA — livello $mode — regole caricate all'avvio:"
    cat "$RULES"
    ;;
esac
