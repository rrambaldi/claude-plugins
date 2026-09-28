#!/usr/bin/env bash
# Armamentarium in Claude Code: toglie ponytail e modalita-fastidio (plugin, skill, hook), aggiunge
# il marketplace e installa omnia (tutte le skill, con i loro hook) a livello utente. Si può
# rilanciare quante volte vuoi. I livelli progetto e locale valgono per la cartella da cui lo lanci.
# Prima di cancellare i file rimasti chiede conferma; con -y li cancella senza chiedere.
#
#   curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash -s -- -y
set -euo pipefail

SI=no
[ "${1:-}" = -y ] && SI=si

MARKETPLACE=armamentarium
REPO=rrambaldi/claude-plugins
PLUGIN="omnia@$MARKETPLACE"
DA_TOGLIERE='ponytail|fastidio'
SETTINGS=("$HOME/.claude/settings.json" "$HOME/.claude/settings.local.json"
          "$PWD/.claude/settings.json" "$PWD/.claude/settings.local.json")
CARTELLE=("$HOME/.claude/skills" "$HOME/.claude/commands" "$HOME/.claude/agents"
          "$HOME/.claude/plugins/synced" "$HOME/.agents/skills"
          "$PWD/.claude/skills" "$PWD/.claude/commands" "$PWD/.claude/agents")

command -v claude >/dev/null || { echo "Claude Code non trovato: installalo prima." >&2; exit 1; }

# claude non deve mai leggere l'input: con curl | bash è il resto di questo script.
cl() { claude "$@" </dev/null; }

# Una riga "<id> <scope>" per installazione: lo stesso plugin può stare in user, project e local.
installati() {
  cl plugin list --json | awk -F'"' '/"id":/ {id=$4} /"scope":/ {print id, $4}'
}

# Le rimozioni non fermano lo script: se una fallisce lo dice e si va avanti.
togli() {
  cl plugin uninstall "$1" --scope "$2" || echo "   ⚠ non tolto $1 ($2), vado avanti" >&2
}

# Le cartelle che esistono, una volta sola (lanciato dalla home, $PWD/.claude è ~/.claude).
esistenti() { for c in "$@"; do [ -e "$c" ] && realpath "$c"; done | awk '!visto[$0]++'; }

# per_nome <profondità> <cartelle...>: file e cartelle che si chiamano ponytail o fastidio.
per_nome() {
  local profondita=$1; shift
  [ $# -gt 0 ] || return 0
  find "$@" -maxdepth "$profondita" \( -iname '*ponytail*' -o -iname '*fastidio*' \) -prune -print
}

echo "1/5 plugin ponytail e fastidio"
while read -r id scope; do
  case "$id" in *ponytail*|*fastidio*) togli "$id" "$scope" ;; esac
done < <(installati)
marketplace=$(cl plugin marketplace list)
if grep -qw ponytail <<<"$marketplace"; then
  cl plugin marketplace remove ponytail || echo "   ⚠ marketplace ponytail non tolto, vado avanti" >&2
fi

echo "2/5 hook, skill e comandi di ponytail e fastidio"
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
    echo "   ⚠ python3 non trovato: togli a mano gli hook che citano ponytail o fastidio da ${settings[*]}" >&2
  fi
fi
mapfile -t cartelle < <(esistenti "${CARTELLE[@]}")
if [ ${#cartelle[@]} -gt 0 ]; then
  while read -r d; do
    if rm -rf "$d"; then echo "   tolto $d"; else echo "   ⚠ non tolto $d, vado avanti" >&2; fi
  done < <(per_nome 3 "${cartelle[@]}")
fi

echo "3/5 marketplace $MARKETPLACE"
cl plugin marketplace add "$REPO" --scope user
cl plugin marketplace update "$MARKETPLACE"

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
  cl plugin update "$PLUGIN" --scope user
else
  cl plugin install "$PLUGIN" --scope user
fi
out=$(cl plugin enable "$PLUGIN" --scope user 2>&1) || grep -q "already enabled" <<<"$out" || { echo "$out" >&2; exit 1; }

echo "5/5 controllo finale"
mapfile -t cartelle < <(esistenti "${CARTELLE[@]}")
mapfile -t hookdir < <(esistenti "$HOME/.claude/hooks" "$PWD/.claude/hooks")
# I file che si chiamano ponytail o fastidio si possono togliere. Quelli che li citano soltanto
# (una statusline, un settings) restano come sono: vanno controllati a mano.
mapfile -t nominati < <(per_nome 1 "${hookdir[@]}"; per_nome 3 "${cartelle[@]}")
if [ ${#nominati[@]} -gt 0 ]; then
  echo "   restano questi file di ponytail o fastidio:"
  printf '     %s\n' "${nominati[@]}"
  risposta=n
  if [ "$SI" = si ]; then
    risposta=s
  elif { : </dev/tty; } 2>/dev/null; then
    read -r -p "   Li tolgo? [s/N] " risposta </dev/tty || risposta=n
  else
    echo "   nessun terminale per chiederlo: rilancia con -y per toglierli"
  fi
  if [[ "$risposta" =~ ^[sSyY] ]]; then
    for f in "${nominati[@]}"; do
      if rm -rf "$f"; then echo "   tolto $f"; else echo "   ⚠ non tolto $f, vado avanti" >&2; fi
    done
    nominati=()
  fi
fi
mapfile -t dove < <(esistenti "${SETTINGS[@]}" "${hookdir[@]}")
citano=$( { installati | grep -i -E "$DA_TOGLIERE";
            [ ${#dove[@]} -gt 0 ] && grep -r -l -i -E "$DA_TOGLIERE" "${dove[@]}";
          } 2>/dev/null | grep -v -x -F -f <(printf '%s\n' "${nominati[@]}") || true)
if [ -n "$citano" ]; then
  echo "   ⚠ questi citano ancora ponytail o fastidio, controllali a mano:" >&2
  sed 's/^/     /' <<<"$citano" >&2
  if grep -qi statusline <<<"$citano"; then
    echo "   Una statusline che li cita si può sostituire con Status rei (-STR)." >&2
  fi
  echo "   Le skill che tornano dopo ogni avvio arrivano da claude.ai: toglile da Customize → Skills / Plugins." >&2
elif [ ${#nominati[@]} -eq 0 ]; then
  echo "   niente più ponytail né fastidio"
fi

echo "Fatto. Riavvia Claude Code (o scrivi /reload-plugins) per caricare le skill."
