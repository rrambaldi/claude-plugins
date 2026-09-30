#!/usr/bin/env python3
# UserPromptSubmit: ogni NOMEN_MUTARE_OGNI prompt (10 se non c'è, 0 lo spegne) chiede a Haiku un
# titolo per gli ultimi prompt; al prompt dopo lo applica con sessionTitle, che fa come /rename.
# Haiku gira in background: ci mette qualche secondo, e il prompt non deve aspettarlo.
# ParceEtRecte: un /rename fatto a mano dura fino al giro successivo.
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

FIGLIO = "NOMEN_MUTARE_FIGLIO"  # il claude -p lanciato da qui non deve rilanciare l'hook
ISTRUZIONI = ("Dai un titolo breve a questa conversazione: al massimo 6 parole, in italiano, "
              "senza virgolette né punto finale. Rispondi solo con il titolo.")
MAX_PROMPT = 300  # caratteri di ogni prompt passati a Haiku
MAX_TITOLO = 60

if os.environ.get(FIGLIO):
    sys.exit(0)
ogni = int(os.environ.get("NOMEN_MUTARE_OGNI", "10"))
if ogni <= 0:
    sys.exit(0)

evento = json.load(sys.stdin)
cartella = Path(tempfile.gettempdir()) / "nomen-mutare"
cartella.mkdir(exist_ok=True)
titolo = cartella / f"{evento['session_id']}.titolo"
contatore = cartella / f"{evento['session_id']}.n"

if titolo.exists():
    nome = titolo.read_text().strip().split("\n")[0][:MAX_TITOLO]
    titolo.unlink()
    if nome:
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "sessionTitle": nome}}))

n = int(contatore.read_text()) + 1 if contatore.exists() else 1
contatore.write_text(str(n))
if n % ogni:
    sys.exit(0)

# I prompt scritti dall'utente: niente risultati dei tool, niente comandi o notifiche (<...>).
# Al primo prompt di una sessione nuova il transcript non c'è ancora.
transcript = Path(evento["transcript_path"])
prompt = []
for riga in transcript.read_text().splitlines() if transcript.exists() else []:
    r = json.loads(riga)
    testo = r.get("message", {}).get("content") if r.get("type") == "user" and not r.get("isMeta") else None
    if isinstance(testo, str) and not testo.startswith("<"):
        prompt.append(testo[:MAX_PROMPT])
corrente = evento["prompt"][:MAX_PROMPT]
if not prompt or prompt[-1] != corrente:
    prompt.append(corrente)
testo = "Prompt dell'utente, dal più vecchio:\n" + "\n".join("- " + p.replace("\n", " ") for p in prompt[-ogni:])

# --setting-sources local da una cartella vuota: niente plugin dell'utente, quindi niente hook.
subprocess.Popen(
    ["sh", "-c", 'claude -p "$1" --model haiku --setting-sources local --no-session-persistence'
     ' --tools "" --system-prompt "$2" > "$3.tmp" && mv "$3.tmp" "$3"', "sh", testo, ISTRUZIONI, str(titolo)],
    cwd=cartella, env={**os.environ, FIGLIO: "1"}, start_new_session=True,
    stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
