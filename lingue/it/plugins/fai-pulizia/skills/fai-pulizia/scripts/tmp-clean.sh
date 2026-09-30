#!/usr/bin/env bash
# tmp-clean.sh — libera spazio in /tmp senza toccare file in uso né sessioni Claude attive.
# Pulisce solo la roba di chi lo lancia: niente sudo, niente root.
#
# Uso:  ./tmp-clean.sh           simulazione: mostra cosa farebbe, non tocca nulla
#       ./tmp-clean.sh -y        applica
#
#   -y         applica davvero
#   -s         solo la sessione Claude da cui lo lanci: file non in uso di scratchpad e task
#   -d GIORNI  file generici non toccati (mtime, atime e ctime) da più di GIORNI   [7]
#   -i MINUTI  sessione Claude considerata chiusa se inattiva da più di MINUTI     [120]
#   -t SIZE    tronca a zero i log ancora aperti più grandi di SIZE (es. 500M, 2G),
#              anche quelli già cancellati ma tenuti aperti da un processo          [off]
#
# Non tocca mai: file di altri utenti, file aperti o mappati in memoria da un processo, file
# nella directory di lavoro di un processo, socket, file lock/pid, ticket Kerberos, lock
# PostgreSQL, systemd-private-*, snap-private-tmp, tmux-*, ssh-*, .X11-unix e simili.
# Le sessioni Claude vive restano con qualunque -i: il loro pid è in ~/.claude/sessions/.

set -o nounset
shopt -s nullglob

TMP=/tmp APPLY=0 SESSION=0 AGE_DAYS=7 IDLE_MIN=120 TRUNC="" TRUNC_BYTES=0
CL=$TMP/claude-$EUID

usage() { awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; exit "${1:-0}"; }
die()   { echo "errore: $*" >&2; exit 1; }

while getopts "ysd:i:t:h" o; do
  case $o in
    y) APPLY=1 ;;
    s) SESSION=1 ;;
    d) AGE_DAYS=$OPTARG ;;
    i) IDLE_MIN=$OPTARG ;;
    t) TRUNC=$OPTARG ;;
    h) usage 0 ;;
    *) usage 1 ;;
  esac
done

(( EUID )) || die "niente sudo né root: ognuno pulisce solo la sua roba"
[[ $AGE_DAYS =~ ^[0-9]+$ ]] || die "-d vuole un numero di giorni"
[[ $IDLE_MIN =~ ^[0-9]+$ ]] || die "-i vuole un numero di minuti"
if [[ -n $TRUNC ]]; then
  TRUNC_BYTES=$(numfmt --from=iec "$TRUNC" 2>/dev/null) || die "-t: dimensione non valida '$TRUNC'"
fi
if (( SESSION )); then
  [[ -n ${CLAUDE_CODE_SESSION_ID:-} ]] || die "-s va lanciato da Claude Code (manca CLAUDE_CODE_SESSION_ID)"
fi
# Solo se è una directory vera, mia e che nessun altro può scrivere: dentro nessuno può
# sostituire una cartella con un link tra la scansione e l'rm.
CL_OK=0
find "$CL" -maxdepth 0 -type d -user "$EUID" ! -perm /022 2>/dev/null | grep -q . && CL_OK=1

# Lavoro in RAM: /tmp potrebbe essere piena (anche sort usa TMPDIR).
WORK=$(mktemp -d -p /dev/shm tmpclean.XXXXXX 2>/dev/null || mktemp -d) || die "mktemp fallito"
trap 'rm -rf -- "$WORK"' EXIT
export TMPDIR=$WORK

TOTAL=0
human()      { numfmt --to=iec "$1" 2>/dev/null || echo "$1"; }
show()       { printf '%-6s %7s  %s  [%s]\n' "$1" "$(human "$2")" "$3" "$4"; }   # AZIONE BYTES PATH MOTIVO
disk_bytes() { local s; s=$(stat -L -c '%b %B' -- "$1" 2>/dev/null) || { echo 0; return; }; echo $(( ${s% *} * ${s#* } )); }
is_log()     { case $1 in "$TMP"/claude-*/tasks/*|*.log|*.out|*.output) return 0 ;; esac; return 1; }

# not_in_use <argomenti di find>: "byte<TAB>percorso" dei file trovati che nessun processo usa,
# dal più grande.
not_in_use() {
  find "$@" -printf '%b\t%p\n' 2>/dev/null \
  | awk -v OPEN="$WORK/open" -v CWD="$WORK/cwd" '
      BEGIN { while ((getline l < OPEN) > 0) open[l] = 1
              while ((getline l < CWD)  > 0) cwd[++n] = l "/" }
      { b = $0; sub(/\t.*/, "", b); p = substr($0, length(b) + 2)
        if ((p "/") in open) next
        for (i = 1; i <= n; i++) if (index(p, cwd[i]) == 1) next
        printf "%.0f\t%s\n", b * 512, p }' \
  | sort -t$'\t' -k1,1nr
}

# delete_list <lista> <motivo>: mostra i 30 file più grandi e il totale; con -y li cancella tutti.
delete_list() {
  local n sum
  n=$(wc -l <"$1")
  sum=$(awk -F'\t' '{ s += $1 } END { printf "%.0f", s }' "$1")
  head -n 30 "$1" | while IFS=$'\t' read -r b p; do show CANC "$b" "$p" "$2"; done
  (( n > 30 )) && echo "... e altri $(( n - 30 )) file"
  echo "Totale: $n file, $(human "$sum")"
  TOTAL=$(( TOTAL + sum ))
  if (( APPLY )); then
    while IFS=$'\t' read -r _ p; do rm -f -- "$p"; done <"$1"
  fi
}

summary() {
  echo
  if (( APPLY )); then
    echo "Liberati circa $(human "$TOTAL")."
  else
    echo "Simulazione: si libererebbero circa $(human "$TOTAL"). Rilancia con -y per applicare."
  fi
  df -h "$TMP"
}

df -h "$TMP"

# ---------------------------------------------------------------------------
# File aperti, mappati e directory di lavoro dei processi (senza root: solo i miei)
# ---------------------------------------------------------------------------
echo; echo "Scansione dei processi..."
find /proc/[0-9]*/fd -mindepth 1 -maxdepth 1 -type l -lname "$TMP/*" -printf '%l\n' 2>/dev/null >"$WORK/fd"
find /proc/[0-9]*/cwd -maxdepth 0 -lname "$TMP/*" -printf '%l\n' 2>/dev/null \
  | sed 's/ (deleted)$//' | sort -u >"$WORK/cwd"
cat /proc/[0-9]*/maps 2>/dev/null \
  | awk -v t=" $TMP/" '{ i = index($0, t); if (i) print substr($0, i + 1) }' | sort -u >"$WORK/maps"
# Elenco "in uso" con "/" finale, per poter confrontare anche i prefissi di directory.
cat "$WORK/fd" "$WORK/cwd" "$WORK/maps" | sed 's/ (deleted)$//; s|$|/|' | sort -u >"$WORK/open"

(( CL_OK )) || [[ ! -e $CL ]] || echo "ATTENZIONE: $CL non è una cartella solo tua: sessioni Claude saltate." >&2

# ---------------------------------------------------------------------------
# -s: solo la sessione da cui lo lanci, $CL/<progetto>/<sessione>/
# ---------------------------------------------------------------------------
if (( SESSION )); then
  echo; echo "== Sessione $CLAUDE_CODE_SESSION_ID =="
  if (( CL_OK )); then
    for sdir in "$CL"/*/"$CLAUDE_CODE_SESSION_ID"/; do
      not_in_use "$sdir" -mindepth 1 -name $'*\n*' -prune -o -type f >"$WORK/session"
      delete_list "$WORK/session" "sessione corrente, non in uso"
      # Restano scratchpad/ e tasks/, vuote.
      if (( APPLY )); then find "$sdir" -mindepth 2 -type d -empty -delete; fi
    done
  fi
  summary
  exit 0
fi

# ---------------------------------------------------------------------------
# 1. Sessioni Claude: $CL/<progetto>/<sessione>/
# ---------------------------------------------------------------------------
echo; echo "== Sessioni Claude =="
# Ogni claude vivo scrive sessions/<pid>.json con la sessione attuale: dopo /clear l'id cambia,
# e la cartella tasks/ che tiene aperta resta quella della sessione di prima.
: >"$WORK/live"
for j in "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"/sessions/*.json; do
  pid=${j##*/}; pid=${pid%.json}
  [[ $pid =~ ^[0-9]+$ && -d /proc/$pid ]] || continue
  grep -o '"sessionId":"[^"]*' "$j" | cut -d'"' -f4 >>"$WORK/live"
done
for sdir in "$CL"/*/*/; do
  (( CL_OK )) || break
  sdir=${sdir%/}
  sid=${sdir##*/}; slug=${sdir%/*}; slug=${slug##*/}
  size=$(du -sB1 -- "$sdir" 2>/dev/null | cut -f1); size=${size:-0}

  if grep -qxF -- "$sid" "$WORK/live"; then
    show TIENI "$size" "$sdir" "sessione viva"; continue
  fi
  if grep -qF -- "$sdir/" "$WORK/open"; then
    show TIENI "$size" "$sdir" "file aperti da un processo"; continue
  fi
  if [[ -n $(find "$sdir" -mmin -"$IDLE_MIN" -print -quit 2>/dev/null) ]]; then
    show TIENI "$size" "$sdir" "modificata negli ultimi $IDLE_MIN min"; continue
  fi
  if [[ -n $(find "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/$slug/$sid.jsonl" -maxdepth 0 -mmin -"$IDLE_MIN" 2>/dev/null) ]]; then
    show TIENI "$size" "$sdir" "conversazione attiva negli ultimi $IDLE_MIN min"; continue
  fi

  show CANC "$size" "$sdir" "inattiva da più di $IDLE_MIN min"
  TOTAL=$(( TOTAL + size ))
  if (( APPLY )); then rm -rf -- "$sdir"; fi
done

# ---------------------------------------------------------------------------
# 2. File generici vecchi, miei e non in uso (anche quelli sciolti in $CL)
# ---------------------------------------------------------------------------
echo; echo "== File non toccati da più di $AGE_DAYS giorni =="
not_in_use "$TMP" -xdev -mindepth 1 \
  \( -path "$CL/*/*" -o -path "$TMP/systemd-private-*" -o -path "$TMP/snap-private-tmp" \
     -o -path "$TMP/.*-unix" -o -path "$TMP/tmux-*" -o -path "$TMP/ssh-*" -o -path "$TMP/screens" \
     -o -path "$TMP/hsperfdata_*" -o -path "$WORK" -o -name $'*\n*' \) -prune -o \
  -type f -user "$EUID" ! -name 'krb5cc_*' ! -name '.s.PGSQL.*' ! -name '*.pid' ! -name '*.lock' ! -name '*.lck' \
  -mtime +"$AGE_DAYS" -atime +"$AGE_DAYS" -ctime +"$AGE_DAYS" >"$WORK/old"
delete_list "$WORK/old" "vecchio, non in uso"

# ---------------------------------------------------------------------------
# 3. Log miei ancora aperti oltre soglia (solo con -t)
# ---------------------------------------------------------------------------
if [[ -n $TRUNC ]]; then
  echo; echo "== Log aperti più grandi di $TRUNC =="
  while IFS= read -r f; do
    is_log "$f" || continue
    grep -qxF -- "$f" "$WORK/maps" && continue          # mappato in memoria: troncarlo farebbe crashare il processo
    [[ -f $f && -O $f ]] || continue
    b=$(disk_bytes "$f"); (( b > TRUNC_BYTES )) || continue
    show TRONCA "$b" "$f" "log ancora aperto"
    TOTAL=$(( TOTAL + b ))
    if (( APPLY )); then truncate -s 0 -- "$f"; fi
  done < <(grep -v ' (deleted)$' "$WORK/fd" | sort -u)
fi

# ---------------------------------------------------------------------------
# 4. File già cancellati ma tenuti aperti: occupano spazio finché il processo vive
# ---------------------------------------------------------------------------
echo; echo "== File cancellati ma ancora aperti =="
declare -A seen=()
found=0
while IFS= read -r fdp; do
  tgt=$(readlink -- "$fdp" 2>/dev/null) || continue
  id=$(stat -L -c '%d:%i' -- "$fdp" 2>/dev/null) || continue
  [[ -n ${seen[$id]:-} ]] && continue
  seen[$id]=1
  b=$(disk_bytes "$fdp"); (( b > 0 )) || continue
  f=${tgt% (deleted)}; pid=${fdp#/proc/}; pid=${pid%%/*}
  who="$(cat "/proc/$pid/comm" 2>/dev/null) pid $pid"
  found=1
  if [[ -n $TRUNC && -O $fdp ]] && (( b > TRUNC_BYTES )) && is_log "$f" && ! grep -qxF -- "$tgt" "$WORK/maps"; then
    show TRONCA "$b" "$f" "cancellato, aperto da $who"
    TOTAL=$(( TOTAL + b ))
    if (( APPLY )); then truncate -s 0 -- "$fdp"; fi
  else
    show INFO "$b" "$f" "cancellato, aperto da $who: si libera quando il processo termina"
  fi
done < <(find /proc/[0-9]*/fd -mindepth 1 -maxdepth 1 -type l -lname "$TMP/* (deleted)" -printf '%p\n' 2>/dev/null)
(( found )) || echo "nessuno"

summary
