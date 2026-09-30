#!/usr/bin/env python3
"""Scrive, o aggiorna, il blocco di Regole scritte nel CLAUDE.md del progetto e stampa il diff.

Uso: python3 scrivi.py [CARTELLA]   (di default quella corrente)
Il file è CLAUDE.md nella radice git, o .claude/CLAUDE.md se c'è solo quello. Il blocco è
regole.md, tra i suoi due marcatori: il resto del file non si tocca, fine riga compresi.
"""
import difflib
import pathlib
import subprocess
import sys

REGOLE = pathlib.Path(__file__).resolve().parent.parent / "regole.md"
# Marcatori senza nomi di skill: così li riconosce anche il set italiano o inglese.
INIZIO, FINE = "<!-- armamentarium:inizio", "<!-- armamentarium:fine -->"


def radice(cartella):
    try:
        r = subprocess.run(["git", "-C", cartella, "rev-parse", "--show-toplevel"], capture_output=True, text=True)
    except FileNotFoundError:
        return pathlib.Path(cartella).resolve()  # senza git: la cartella stessa
    return pathlib.Path(r.stdout.strip() if r.returncode == 0 else cartella).resolve()


def destinazione(base):
    principale, nascosto = base / "CLAUDE.md", base / ".claude" / "CLAUDE.md"
    return nascosto if nascosto.exists() and not principale.exists() else principale


def main():
    file = destinazione(radice(sys.argv[1] if len(sys.argv) > 1 else "."))
    testo = ""
    if file.exists():
        with open(file, encoding="utf-8", newline="") as fh:  # newline="": i fine riga restano com'erano
            testo = fh.read()
    a_capo = "\r\n" if "\r\n" in testo else "\n"
    blocco = REGOLE.read_text(encoding="utf-8").strip().replace("\n", a_capo) + a_capo
    inizi, fini = testo.count(INIZIO), testo.count(FINE)
    if inizi > 1 or inizi != fini:
        sys.exit(f"{file}: {inizi} inizi e {fini} fini del blocco, ne serve uno per tipo. Sistemalo a mano.")
    if inizi:
        prima, resto = testo.split(INIZIO, 1)
        dopo = resto.split(FINE, 1)[1].lstrip("\r\n")
        nuovo, cosa = prima + blocco + (a_capo + dopo if dopo else ""), "aggiornato"
    elif testo.strip():
        nuovo, cosa = testo.rstrip("\r\n") + a_capo * 2 + blocco, "aggiunto in fondo"
    else:
        nuovo, cosa = blocco, "creato"
    if nuovo == testo:
        print(f"{file}: già aggiornato")
        return
    file.parent.mkdir(parents=True, exist_ok=True)
    with open(file, "w", encoding="utf-8", newline="") as fh:
        fh.write(nuovo)
    print(f"{file}: blocco {cosa}\n")
    sys.stdout.writelines(difflib.unified_diff(testo.splitlines(True), nuovo.splitlines(True), "prima", "dopo"))


if __name__ == "__main__":
    main()
