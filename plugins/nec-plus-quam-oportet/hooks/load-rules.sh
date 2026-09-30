#!/usr/bin/env bash
# Hook di nec plus quam oportet. Senza argomenti: SessionStart (anche dopo /clear e
# compattazione). "subagent": SubagentStart. "prompt": UserPromptSubmit, segue il livello.
# Il livello (full, lite, ultra, off) sta nel flag, che la statusline legge per il badge.
# ParceEtRecte: un flag solo per tutte le sessioni aperte; un file per session_id se ne usi più insieme.
# ParceEtRecte: il flag resta se disinstalli il plugin; cancellalo a mano (~/.claude/.nec-plus-active).
FLAG="$HOME/.claude/.nec-plus-active"
RULES="${CLAUDE_PLUGIN_ROOT}/skills/nec-plus-quam-oportet/SKILL.md"
mode=$(head -1 "$FLAG" 2>/dev/null)
mode=${mode:-full}

case "$1" in
  subagent)
    [ "$mode" = off ] && exit
    # Il contesto di SessionStart non arriva ai subagent, e per loro lo stdout semplice
    # viene scartato: serve il JSON hookSpecificOutput.
    python3 -c 'import json, sys
rules = "NEC PLUS QUAM OPORTET ATTIVA — livello " + sys.argv[2] + " — regole:\n" + open(sys.argv[1]).read()
print(json.dumps({"hookSpecificOutput": {"hookEventName": "SubagentStart", "additionalContext": rules}}))' "$RULES" "$mode"
    ;;
  prompt)
    # Conta solo se il messaggio comincia con il comando: citarlo a metà frase non cambia niente.
    # Sigla e nomi scritti come nella skill: lingue/genera.py li traduce per gli altri set.
    new=$(python3 -c 'import json, re, sys
p = json.load(sys.stdin).get("prompt", "").strip()
m = re.match(r"/?(-NPQO|nec-plus-quam-oportet|nec plus quam oportet)\b(\s+(lite|levis|full|ultra|off)\b)?", p, re.I)
if m:
    livello = (m.group(3) or "full").lower()
    print({"levis": "lite"}.get(livello, livello))
elif re.match(r"(stop nec plus|normal mode)\b", p, re.I):
    print("off")')
    [ -z "$new" ] || echo "$new" > "$FLAG"
    ;;
  *)
    # Una sessione nuova riparte da full; /clear, compattazione e resume tengono il livello.
    source=$(python3 -c 'import json, sys; print(json.load(sys.stdin).get("source", ""))' 2>/dev/null)
    [ "$source" = startup ] && mode=full
    echo "$mode" > "$FLAG"
    [ "$mode" = off ] && exit
    echo "NEC PLUS QUAM OPORTET ATTIVA — livello $mode — regole caricate all'avvio:"
    cat "$RULES"
    ;;
esac
