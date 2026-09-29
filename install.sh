#!/usr/bin/env bash
# Armamentarium in Claude Code: toglie ponytail e modalita-fastidio (plugin, skill, hook), aggiunge
# il marketplace, installa omnia (tutte le skill, con i loro hook) a livello utente se l'organizzazione
# non lo dà già da claude.ai, ne accende le skill in skillOverrides e accende l'aggiornamento
# automatico del marketplace. Si può rilanciare quante volte vuoi. I livelli progetto e locale
# valgono per la cartella da cui lo lanci.
# Prima di cancellare i file rimasti chiede conferma; con -y li cancella senza chiedere.
#
#   curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash -s -- -y
set -euo pipefail

SI=no
[ "${1:-}" = -y ] && SI=si
# Ogni settings modificato viene copiato in .bak una volta per giro, prima della prima modifica.
export INIZIO=$(date +%s)

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
import json, os, re, shutil, sys
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
        if not os.path.exists(f + ".bak") or os.path.getmtime(f + ".bak") < float(os.environ["INIZIO"]):
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
# Se l'organizzazione mette omnia su claude.ai come Required o Installed by default, Claude Code lo
# sincronizza da solo: installato anche qui, ogni skill comparirebbe due volte.
sincronizzato=no
if command -v python3 >/dev/null && python3 - "$HOME/.claude/plugins/synced" <<'PY'
import glob, json, os, sys
for f in glob.glob(os.path.join(sys.argv[1], "*", "manifest.json")):
    try:
        plugins = json.load(open(f)).get("plugins", [])
    except Exception:
        continue
    if any(p.get("name") == "omnia" and p.get("installationPreference") in ("required", "auto_install")
           for p in plugins):
        sys.exit(0)
sys.exit(1)
PY
then
  sincronizzato=si
fi
# Solo omnia e solo a livello utente: un plugin singolo, o omnia in un altro livello, fanno
# comparire le skill due volte.
utente=no
while read -r id scope; do
  if [ "$id" = "$PLUGIN" ] && [ "$scope" = user ] && [ "$sincronizzato" = no ]; then
    utente=si
  elif [[ "$id" == *@"$MARKETPLACE" ]]; then
    togli "$id" "$scope"
  fi
done < <(installati)
if [ "$sincronizzato" = si ]; then
  echo "   omnia arriva già dall'organizzazione (claude.ai): non lo installo anche qui"
else
  if [ "$utente" = si ]; then
    cl plugin update "$PLUGIN" --scope user
  else
    cl plugin install "$PLUGIN" --scope user
  fi
  out=$(cl plugin enable "$PLUGIN" --scope user 2>&1) || grep -q "already enabled" <<<"$out" || { echo "$out" >&2; exit 1; }
fi
# Skill di omnia su "on" nei settings utente. Nei settings di progetto e locali un'eccezione per la
# stessa skill vincerebbe su quella utente: lì si tolgono quelle che la spengono.
# Nei settings utente anche autoUpdate: per i marketplace non ufficiali parte spento.
mapfile -t locali < <(esistenti "$HOME/.claude/settings.local.json" "$PWD/.claude/settings.json" "$PWD/.claude/settings.local.json")
if command -v python3 >/dev/null; then
  python3 - "$MARKETPLACE" "$HOME/.claude/plugins/marketplaces/$MARKETPLACE" "$HOME/.claude/settings.json" "${locali[@]}" <<'PY' || echo "   ⚠ skillOverrides e autoUpdate non aggiornati, vado avanti" >&2
import json, os, re, shutil, sys
nome, radice, utente, *altri = sys.argv[1:]

def salva(f, dati):
    if not os.path.exists(f + ".bak") or os.path.getmtime(f + ".bak") < float(os.environ["INIZIO"]):
        shutil.copy(f, f + ".bak")
    with open(f, "w") as out:
        json.dump(dati, out, indent=2, ensure_ascii=False)
        out.write("\n")

# L'elenco delle skill di omnia viene dal marketplace, così non va aggiornato qui.
catalogo = json.load(open(os.path.join(radice, ".claude-plugin", "marketplace.json")))
omnia = next(p for p in catalogo["plugins"] if p["name"] == "omnia")
chiavi = set()
for cartella in omnia["skills"]:
    testo = open(os.path.join(radice, cartella, "SKILL.md")).read()
    chiavi.add("omnia:" + re.search(r"^name:\s*(\S+)", testo, re.M).group(1))

dati = json.load(open(utente))
cambiati = False
override = dati.setdefault("skillOverrides", {})
if any(override.get(k) != "on" for k in chiavi):
    override.update(dict.fromkeys(sorted(chiavi), "on"))
    cambiati = True
# La voce la scrive "marketplace add --scope user"; senza, autoUpdate da solo non basta.
voce = dati.get("extraKnownMarketplaces", {}).get(nome)
if voce is not None and voce.get("autoUpdate") is not True:
    voce["autoUpdate"] = True
    cambiati = True
if cambiati:
    salva(utente, dati)
print(f"   skillOverrides: {len(chiavi)} skill di omnia su on in {utente}")
if voce is None:
    print(f"   ⚠ {nome} non è in {utente}: accendi l'aggiornamento da /plugin → Marketplaces", file=sys.stderr)
else:
    print(f"   autoUpdate: {nome} si aggiorna da solo a ogni avvio di Claude Code")

for f in dict.fromkeys(altri):
    if os.path.realpath(f) == os.path.realpath(utente):
        continue
    dati = json.load(open(f))
    override = dati.get("skillOverrides") or {}
    spente = [k for k, v in override.items() if v != "on" and (k in chiavi or "omnia:" + k in chiavi)]
    if spente:
        for k in spente:
            del override[k]
        if not override:
            del dati["skillOverrides"]
        salva(f, dati)
        print(f"   tolte {len(spente)} eccezioni che spegnevano omnia da {f}")
PY
else
  echo "   ⚠ python3 non trovato: metti a mano le skill di omnia su \"on\" in skillOverrides e accendi l'aggiornamento da /plugin → Marketplaces" >&2
fi

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
