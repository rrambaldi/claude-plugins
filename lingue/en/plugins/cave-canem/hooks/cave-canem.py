#!/usr/bin/env python3
"""Hook PreToolUse di cave canem: prima di un git commit lanciato da Claude guarda cosa ci finirebbe.

Ferma il commit (exit 2: il motivo arriva a Claude) se trova:
- segreti: chiavi e token nelle righe aggiunte, o file che di solito li contengono (.env, chiavi
  private). Stampa file, riga e tipo, mai il valore, per non metterlo nella conversazione;
- file fuori dal perimetro: cambiati prima che la sessione cominciasse, quindi non di questo task.

CAVE_CANEM=perimetro davanti a git commit salta il secondo controllo. CAVE_CANEM=segreti non salta
il primo: passa la decisione all'utente, che vede l'elenco e conferma o no.
"""
import ast
import fnmatch
import json
import os
import re
import shlex
import subprocess
import sys
from datetime import datetime

PERIMETRO, SEGRETI = "perimetro", "segreti"
VARIABILE = "CAVE_CANEM"
DA_FILE = "--pathspec-from-file"
LIMITE_BYTE = 1_000_000
MOSTRATI = 10

PUNTEGGIATURA = ";&|()<>\n"
HEREDOC = re.compile(r"<<-?\s*(['\"]?)(\w+)\1[^\n]*\n.*?\n\s*\2(?=\s|\)|$)", re.S)
COMMIT_GREZZO = re.compile(r"\bgit\b[^;&|\n]*\bcommit\b")
SHELL = {"bash", "sh", "zsh"}
INVOLUCRI = {"sudo", "env", "command", "nice", "time", "nohup", "xargs"}
OPZIONI_GIT_CON_VALORE = {"-C", "-c", "--git-dir", "--work-tree", "--namespace"}
# Opzioni di git commit con il valore nel token dopo; in un gruppo corto (-am) conta l'ultima lettera.
CON_VALORE = {"--message", "--file", "--reuse-message", "--reedit-message", "--author", "--date",
              "--fixup", "--squash", "--template", "--cleanup", "--trailer"}
CORTE_CON_VALORE = set("mFCct")
TUTTO_IL_REPO = {"-A", "--all", "-u", "--update"}

CHIAVI = [
    ("chiave privata", re.compile(r"-----BEGIN (?:[A-Z0-9]+ )*PRIVATE KEY(?: BLOCK)?-----")),
    ("chiave AWS", re.compile(r"\b(?:AKIA|ASIA)[0-9A-Z]{16}\b")),
    ("token GitHub", re.compile(r"\b(?:gh[pousr]_[A-Za-z0-9]{36}|github_pat_\w{22,})")),
    ("token GitLab", re.compile(r"\bglpat-[\w-]{20,}")),
    ("chiave Anthropic", re.compile(r"\bsk-ant-[\w-]{20,}")),
    ("chiave OpenAI", re.compile(r"\bsk-(?:(?:proj|svcacct|admin)-[\w-]{40,}|[A-Za-z0-9]{48}\b)")),
    ("token Slack", re.compile(r"\bxox[abprs]-[A-Za-z0-9-]{10,}")),
    ("chiave Google", re.compile(r"\bAIza[\w-]{35}\b")),
    ("chiave Stripe", re.compile(r"\b[sr]k_live_[A-Za-z0-9]{24,}")),
]
IN_CHIARO = "password o token scritto in chiaro"
NOME_SEGRETO = r"(?:password|passwd|secret|api_?key|access_?token|auth_?token|client_?secret)"
# Nel codice conta solo il valore tra virgolette: senza, è un'espressione (request.form["password"]).
VALORI = [
    (IN_CHIARO, re.compile(
        rf"(?i){NOME_SEGRETO}\w*[\"']?\s*(?::\s*[\w.\[\], |]+?\s*)?[:=]\s*[\"']([^\"'\s]{{8,}})[\"']")),
    ("password in un URL", re.compile(r"\b[a-z][a-z0-9+.-]*://[^/\s:@\"']+:([^/\s:@\"']{3,})@")),
]
VALORE_CONFIG = re.compile(rf"(?i)^\s*[\w.-]*(?:{NOME_SEGRETO}|token)[\w.-]*\s*[:=]\s*([^\s\"'#]{{8,}})\s*$")
CONFIG = (".env", ".properties", ".yml", ".yaml", ".ini", ".cfg", ".conf", ".toml")
SEGNAPOSTO = re.compile(r"^[$%{<]|\$\{|\{\{|(?i:changeme|example|placeholder|dummy|redacted|xxx|\*\*\*|your[_-])"
                        r"|(?i:^(?:pass(?:word)?|secret)$)")
FILE_SEGRETO = re.compile(r"(?:^|/)(?:\.envrc|\.env(?!\.(?:example|sample|template|dist)$)(?:\.[\w.-]+)?"
                          r"|id_(?:rsa|dsa|ecdsa|ed25519)|[^/]+\.(?:pem|p12|pfx|jks|keystore))$")


def git(repo, *argomenti):
    """L'output di git, o None se git fallisce: allora fallirà anche il commit, e lo dirà lui."""
    r = subprocess.run(["git", "-C", repo, "-c", "core.quotepath=off", *argomenti],
                       capture_output=True, text=True, errors="replace")
    return r.stdout if r.returncode == 0 else None


def elenco(repo, *argomenti):
    return set((git(repo, *argomenti) or "").splitlines())


def cartella(base, percorso):
    return os.path.realpath(os.path.join(base, os.path.expanduser(percorso)))


def comandi(testo):
    """I comandi semplici del testo, come liste di parole: senza heredoc, separatori e redirezioni."""
    lex = shlex.shlex(HEREDOC.sub("", testo), posix=True, punctuation_chars=PUNTEGGIATURA)
    lex.whitespace = " \t\r"
    lex.whitespace_split = True
    tutti, parole, salta = [], [], False
    for t in lex:
        if salta:
            salta = False
        elif t and set(t) <= set(PUNTEGGIATURA):
            if set(t) & set("<>"):
                salta = True  # il bersaglio della redirezione; il descrittore prima (2>) va via anche lui
                if parole and parole[-1].isdigit():
                    parole.pop()
            elif parole:
                tutti.append(parole)
                parole = []
        else:
            parole.append(t)
    if parole:
        tutti.append(parole)
    for parole in tutti:
        if parole[0] in SHELL and "-c" in parole[:-1]:
            yield from comandi(parole[parole.index("-c") + 1])
        else:
            yield parole


def comando_git(parole, base):
    """(sottocomando, argomenti, cartella, variabili, via xargs) se parole è un comando git."""
    variabili, xargs = {}, False
    while parole and (re.match(r"^\w+=", parole[0]) or parole[0] in INVOLUCRI):
        if re.match(r"^\w+=", parole[0]):
            nome, valore = parole[0].split("=", 1)
            variabili[nome] = valore
        if parole[0] == "xargs":
            xargs = True
            parole = parole[parole.index("git"):] if "git" in parole else []
        else:
            parole = parole[1:]
    if not parole or parole[0] != "git":
        return None
    i = 1
    while i < len(parole) and parole[i].startswith("-"):
        if parole[i] == "-C" and i + 1 < len(parole):
            base = cartella(base, parole[i + 1])
        i += 2 if parole[i] in OPZIONI_GIT_CON_VALORE else 1
    return (parole[i], parole[i + 1:], base, variabili, xargs) if i < len(parole) else None


def indicati(percorsi, base, radice, candidati):
    """I candidati che i percorsi indicano, glob compresi, come fa git; e se il conto è sicuro."""
    file, sicuro = set(), True
    for p in percorsi:
        if p.startswith(":") or re.search(r"[$`]", p):
            sicuro = False  # pathspec magico o sostituzione della shell: non si sa cosa diventa
            continue
        rel = os.path.relpath(cartella(base, p), radice)
        if re.search(r"[*?\[]", rel):
            file |= {f for f in candidati if fnmatch.fnmatchcase(f, rel)}
        else:
            file |= {f for f in candidati if rel == "." or f == rel or f.startswith(rel + "/")}
    return file, sicuro


def argomenti_commit(argomenti):
    """(percorsi, -a): i pathspec di git commit, e se committa tutti i file tracciati modificati."""
    percorsi, tutto, i = [], False, 0
    while i < len(argomenti):
        a = argomenti[i]
        if a == "--":
            percorsi += argomenti[i + 1:]
            break
        if a.startswith("--"):
            tutto = tutto or a == "--all"
            i += a in CON_VALORE
        elif a.startswith("-") and len(a) > 1:
            for n, lettera in enumerate(a[1:], 1):
                tutto = tutto or lettera == "a"
                if lettera in CORTE_CON_VALORE:
                    i += n == len(a) - 1  # valore nel token dopo; se no è attaccato (-mfix)
                    break
        else:
            percorsi.append(a)
        i += 1
    return percorsi, tutto


def righe_aggiunte(diff):
    file, numero, testata = None, 0, False
    for riga in diff.splitlines():
        if riga.startswith("diff --git "):
            file, testata = None, True
        elif testata and riga.startswith("+++ "):
            nome = riga[4:].rstrip("\t")  # git chiude con un tab il nome che contiene spazi
            if nome.startswith('"'):
                nome = ast.literal_eval(nome)  # git scrive tra virgolette i nomi con " o \
            file = nome[2:] if nome.startswith("b/") else None
        elif riga.startswith("@@"):
            testata = False
            numero = int(re.search(r"\+(\d+)", riga).group(1))
        elif not testata and riga.startswith("+") and file:
            yield file, numero, riga[1:]
            numero += 1


def righe_file(radice, f):
    try:
        with open(os.path.join(radice, f), "rb") as fh:
            dati = fh.read(LIMITE_BYTE + 1)
    except OSError:
        return  # sparito o illeggibile: non finirà nel commit così com'è
    # ParceEtRecte: i file oltre 1 MB e quelli binari non vengono letti.
    if len(dati) > LIMITE_BYTE or b"\0" in dati[:8192]:
        return
    for numero, riga in enumerate(dati.decode("utf-8", "replace").splitlines(), 1):
        yield f, numero, riga


def trova_segreti(righe):
    trovati = {}
    for f, numero, riga in righe:
        for tipo, schema in CHIAVI:
            if schema.search(riga):
                trovati.setdefault((f, tipo), numero)
        for tipo, schema in VALORI + ([(IN_CHIARO, VALORE_CONFIG)] if f.endswith(CONFIG) else []):
            m = schema.search(riga)
            if m and not SEGNAPOSTO.search(m.group(1)):
                trovati.setdefault((f, tipo), numero)
    return [f"{f}:{numero} {tipo}" for (f, tipo), numero in trovati.items()]


def inizio_sessione(transcript):
    """Quando è cominciata la sessione, dal primo timestamp del transcript; None se non si sa."""
    try:
        with open(transcript, encoding="utf-8") as fh:
            for _, riga in zip(range(50), fh):
                if ts := json.loads(riga).get("timestamp"):
                    return datetime.fromisoformat(ts.replace("Z", "+00:00")).timestamp()
    except (OSError, ValueError, AttributeError):
        return None  # senza transcript il perimetro non si giudica: quel controllo salta
    return None


def fuori_perimetro(radice, file, inizio):
    vecchi = []
    for f in sorted(file):
        try:
            s = os.stat(os.path.join(radice, f))
        except OSError:
            continue  # cancellato: la data non c'è, e il perimetro non si giudica
        # ctime cambia anche con mv e git mv, che la data di modifica la conservano.
        if max(s.st_mtime, s.st_ctime) < inizio:
            vecchi.append(f)
    return vecchi


def puntato(voci):
    righe = [f"- {v}" for v in voci[:MOSTRATI]]
    if len(voci) > MOSTRATI:
        righe.append(f"- e altri {len(voci) - MOSTRATI}")
    return "\n".join(righe)


def leggi(testo, cwd):
    """(git add, git commit, conto sicuro) del testo, nell'ordine in cui i cd li incontrano."""
    aggiunte, commit, base = [], [], cwd
    try:
        for parole in comandi(testo):
            if parole[0] == "cd":
                base = cartella(base, parole[1] if len(parole) > 1 else "~")
            elif g := comando_git(parole, base):
                {"add": aggiunte, "commit": commit}.get(g[0], []).append(g)
    except ValueError:
        # virgolette che shlex non chiude ($'...'): se sembra un commit, conta tutto
        return [], [("commit", [], cwd, {}, False)] if COMMIT_GREZZO.search(testo) else [], False
    return aggiunte, commit, True


def main():
    dati = json.load(sys.stdin)
    testo = dati.get("tool_input", {}).get("command", "")
    if "commit" not in testo:
        return
    aggiunte, commit, sicuro = leggi(testo, os.path.realpath(dati.get("cwd") or os.getcwd()))
    if not commit:
        return
    # ParceEtRecte: un repo per comando, quello del primo commit.
    radice = (git(commit[0][2], "rev-parse", "--show-toplevel") or "").strip()
    if not radice:
        return  # non è un repo git: il commit fallirà da solo
    radice = os.path.realpath(radice)
    salta = {v for c in commit for v in c[3].get(VARIABILE, "").split(",")}

    nello_stage = elenco(radice, "diff", "--cached", "--name-only", "--diff-filter=d")
    modificati = elenco(radice, "diff", "--name-only", "--diff-filter=d")
    non_tracciati = elenco(radice, "ls-files", "--others", "--exclude-standard")
    nel_commit = set(nello_stage)
    for _, argomenti, base, _, xargs in aggiunte:
        opzioni = {a for a in argomenti if a.startswith("-")}
        percorsi = [a for a in argomenti if not a.startswith("-")]
        if not percorsi and opzioni & TUTTO_IL_REPO:
            percorsi, base = ["."], radice
        candidati = modificati if opzioni & {"-u", "--update"} else modificati | non_tracciati
        if opzioni & {"-f", "--force"}:
            forzati = elenco(radice, "ls-files", "--others", "--ignored", "--exclude-standard")
            candidati, non_tracciati = candidati | forzati, non_tracciati | forzati
        file, ok = indicati(percorsi, base, radice, candidati)
        nel_commit |= file
        sicuro = sicuro and ok and not xargs and not any(a.startswith(DA_FILE) for a in argomenti)
    for _, argomenti, base, _, _ in commit:
        percorsi, tutto = argomenti_commit(argomenti)
        file, ok = indicati(percorsi, base, radice, modificati)
        nel_commit |= modificati if tutto else file
        sicuro = sicuro and ok and not any(a.startswith(DA_FILE) for a in argomenti)
    if not sicuro:
        # Il comando aggiunge file in un modo che non si legge: conta tutto ciò che potrebbe entrare.
        nel_commit |= modificati | non_tracciati

    opzioni_diff = ("--no-color", "--no-ext-diff", "--src-prefix=a/", "--dst-prefix=b/", "-U0")
    diff = git(radice, "diff", "--cached", *opzioni_diff) or ""
    if tracciati := sorted(nel_commit & modificati):
        diff += git(radice, "diff", *opzioni_diff, "--", *tracciati) or ""
    righe = list(righe_aggiunte(diff))
    for f in sorted(nel_commit & non_tracciati):
        righe += righe_file(radice, f)
    segreti = [f"{f} file che di solito contiene segreti" for f in sorted(nel_commit) if FILE_SEGRETO.search(f)]
    segreti += trova_segreti(righe)

    blocchi = []
    avviso_segreti = "Cave canem: nel commit potrebbero finire dei segreti.\n" + puntato(segreti)
    if segreti and SEGRETI not in salta:
        blocchi.append(
            avviso_segreti + "\nNon committarli: sposta il valore in una variabile d'ambiente o nella "
            "config che il progetto usa già, e metti il file in .gitignore se serve. Se è un falso "
            f"allarme, rilancia con {VARIABILE}={SEGRETI} davanti a git commit: l'utente vedrà "
            "l'elenco e deciderà.")
    inizio = inizio_sessione(dati.get("transcript_path", ""))
    if PERIMETRO not in salta and inizio and (vecchi := fuori_perimetro(radice, nel_commit, inizio)):
        blocchi.append(
            "Cave canem: nel commit finirebbero file cambiati prima di questa sessione, quindi non "
            "di questo task.\n" + puntato(vecchi) + "\n"
            "Toglili dal commit (git restore --staged FILE, o non aggiungerli). Se l'utente ha "
            f"chiesto di committare anche il lavoro di prima, rilancia con {VARIABILE}={PERIMETRO} "
            "davanti a git commit.")
    if blocchi:
        print("\n\n".join(blocchi), file=sys.stderr)
        sys.exit(2)
    if segreti:
        # Claude dice che è un falso allarme: decide l'utente, dalla richiesta di permesso.
        print(json.dumps({"hookSpecificOutput": {
            "hookEventName": "PreToolUse", "permissionDecision": "ask",
            "permissionDecisionReason": avviso_segreti + "\nClaude dice che è un falso allarme. "
                                        "Committare lo stesso?"}}, ensure_ascii=False))


if __name__ == "__main__":
    main()
