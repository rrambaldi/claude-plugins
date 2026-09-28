#!/usr/bin/env bash
# Armamentarium in Claude Code: toglie ponytail e modalita-fastidio (plugin, skill, hook), aggiunge
# il marketplace e installa omnia (tutte le skill, con i loro hook) a livello utente. Si può
# rilanciare quante volte vuoi. I livelli progetto e locale valgono per la cartella da cui lo lanci.
#
#   curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
set -euo pipefail

MARKETPLACE=armamentarium
REPO=rrambaldi/claude-plugins
PLUGIN="omnia@$MARKETPLACE"
DA_TOGLIERE='ponytail|modalita-fastidio'
SETTINGS=("$HOME/.claude/settings.json" "$HOME/.claude/settings.local.json"
          "$PWD/.claude/settings.json" "$PWD/.claude/settings.local.json")
CARTELLE=("$HOME/.claude/skills" "$HOME/.claude/commands" "$HOME/.claude/agents"
          "$HOME/.claude/plugins/synced" "$HOME/.agents/skills"
          "$PWD/.claude/skills" "$PWD/.claude/commands" "$PWD/.claude/agents")

command -v claude >/dev/null || { echo "Claude Code non trovato: installalo prima." >&2; exit 1; }

# Una riga "<id> <scope>" per installazione: lo stesso plugin può stare in user, project e local.
installati() {
  claude plugin list --json | awk -F'"' '/"id":/ {id=$4} /"scope":/ {print id, $4}'
}

# Le rimozioni non fermano lo script: se una fallisce lo dice e si va avanti.
togli() {
  claude plugin uninstall "$1" --scope "$2" </dev/null || echo "   ⚠ non tolto $1 ($2), vado avanti" >&2
}

esistenti() { for c in "$@"; do [ -e "$c" ] && echo "$c"; done; true; }

echo "1/5 plugin ponytail"
while read -r id scope; do
  case "$id" in ponytail@*) togli "$id" "$scope" ;; esac
done < <(installati)
marketplace=$(claude plugin marketplace list)
if grep -qw ponytail <<<"$marketplace"; then
  claude plugin marketplace remove ponytail </dev/null || echo "   ⚠ marketplace ponytail non tolto, vado avanti" >&2
fi

echo "2/5 hook, skill e comandi di ponytail e modalita-fastidio"
mapfile -t settings < <(esistenti "${SETTINGS[@]}")
if [ ${#settings[@]} -gt 0 ]; then
  if command -v python3 >/dev/null; then
    python3 - "$DA_TOGLIERE" "${settings[@]}" <<'PY' || echo "   ⚠ hook non puliti, vado avanti" >&2
import json, re, shutil, sys
nomi = re.compile(sys.argv[1], re.I)
for f in dict.fromkeys(sys.argv[2:]):
    try:
        dati = json.load(open(f))
    except Exception as e:
        print(f"   ⚠ {f} non letto ({e}), vado avanti", file=sys.stderr)
        continue
    hooks = dati.get("hooks")
    if not isinstance(hooks, dict):
        continue
    tolti = 0
    for evento in list(hooks):
        gruppi = []
        for g in hooks[evento]:
            restano = [h for h in g.get("hooks", []) if not nomi.search(h.get("command", ""))]
            tolti += len(g.get("hooks", [])) - len(restano)
            if restano:
                gruppi.append({**g, "hooks": restano})
        if gruppi:
            hooks[evento] = gruppi
        else:
            del hooks[evento]
    if tolti:
        if not hooks:
            del dati["hooks"]
        shutil.copy(f, f + ".bak")
        with open(f, "w") as out:
            json.dump(dati, out, indent=2, ensure_ascii=False)
            out.write("\n")
        print(f"   tolti {tolti} hook da {f} (copia in {f}.bak)")
PY
  else
    echo "   ⚠ python3 non trovato: togli a mano gli hook che citano ponytail o modalita-fastidio da ${settings[*]}" >&2
  fi
fi
mapfile -t cartelle < <(esistenti "${CARTELLE[@]}")
if [ ${#cartelle[@]} -gt 0 ]; then
  while read -r d; do
    if rm -rf "$d"; then echo "   tolto $d"; else echo "   ⚠ non tolto $d, vado avanti" >&2; fi
  done < <(find "${cartelle[@]}" -maxdepth 3 \( -iname 'ponytail*' -o -iname 'modalita-fastidio*' \) -prune -print)
fi

echo "3/5 marketplace $MARKETPLACE"
claude plugin marketplace add "$REPO" --scope user
claude plugin marketplace update "$MARKETPLACE"

echo "4/5 $PLUGIN (utente)"
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

echo "5/5 controllo finale"
mapfile -t dove < <(esistenti "${SETTINGS[@]}" "$HOME/.claude/hooks" "$PWD/.claude/hooks")
resti=$( { installati | grep -i -E "$DA_TOGLIERE";
           [ ${#dove[@]} -gt 0 ] && grep -r -l -i -E "$DA_TOGLIERE" "${dove[@]}";
           [ ${#cartelle[@]} -gt 0 ] && find "${cartelle[@]}" -maxdepth 3 \( -iname 'ponytail*' -o -iname 'modalita-fastidio*' \) -prune -print;
         } 2>/dev/null || true)
if [ -n "$resti" ]; then
  echo "   ⚠ restano tracce da togliere a mano:" >&2
  sed 's/^/     /' <<<"$resti" >&2
  echo "   Le skill che tornano dopo ogni avvio arrivano da claude.ai: toglile da Customize → Skills / Plugins." >&2
else
  echo "   niente più ponytail né modalita-fastidio"
fi

echo "Fatto. Riavvia Claude Code (o scrivi /reload-plugins) per caricare le skill."
