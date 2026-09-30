#!/usr/bin/env python3
"""Genera il set italiano e quello inglese dell'armamentarium dal set latino (plugins/).

Cambiano solo incantesimi, sigle e nomi delle skill: le istruzioni restano in italiano.
Riscrive da zero lingue/it e lingue/en e, in .claude-plugin/marketplace.json, i pacchetti
tutto e all, copiati da omnia (versione compresa).

Lancialo dopo ogni modifica a plugins/:  python3 lingue/genera.py
"""
import json
import re
import shutil
import subprocess
from pathlib import Path

RADICE = Path(__file__).resolve().parent.parent
MARKETPLACE = RADICE / ".claude-plugin" / "marketplace.json"
LINGUE = ("it", "en")
LIMITE_DESCRIZIONE = 1024

# Incantesimo e sigla: latino, italiano, inglese. Una sigla non indica mai due skill diverse.
COMANDI = [
    (("Alea iacta est", "AIE"), ("Il dado è tratto", "DT"), ("The die is cast", "TDC")),
    (("Festina lente", "FL"), ("Chi va piano", "CVP"), ("Make haste slowly", "MHS")),
    (("Inspectio decoris", "ID"), ("Analisi UX", "AUX"), ("UX audit", "UXA")),
    (("Sequere pulchritudinem", "SP"), ("Applica restyle", "AR"), ("Apply restyle", "AR")),
    (("Intus et extra", "IE"), ("Analisi SWOT", "SWOT"), ("SWOT analysis", "SWOT")),
    (("Limam adhibere", "LA"), ("Analisi critica", "AC"), ("Critical review", "CR")),
    (("Celeri lima adhibita", "CLA"), ("Critica veloce", "CV"), ("Quick critique", "QC")),
    (("Advocatus diaboli", "AD"), ("Avvocato del diavolo", "AD"), ("Devil's advocate", "DA")),
    (("Nec plus quam oportet", "NPQO"), ("Solo il necessario", "SN"), ("Keep it simple", "KIS")),
    (("Vitium ostendere", "VO"), ("Prima il test", "PT"), ("Test first", "TF")),
    (("Nemo iudex in causa sua", "NIICS"), ("Occhi nuovi", "ON"), ("Fresh eyes", "FE")),
    (("Lex scripta", "LS"), ("Regole scritte", "RS"), ("House rules", "HR")),
    (("Sine more interposita", "SMI"), ("Niente indugi", "NI"), ("No delay", "ND")),
    (("Status rei", "STR"), ("Barra di stato", "BDS"), ("Status line", "SL")),
    (("Summa rerum", "SR"), ("Grimorio", "GR"), ("Spellbook", "SB")),
    (("Tabula rasa", "TR"), ("Fai pulizia", "FP"), ("Clean slate", "CS")),
]

# Nome della skill, che è anche il comando slash e la cartella: latino, italiano, inglese.
# Un plugin che ha il nome di una sua skill cambia cartella con lei; nomen-mutare e cave-canem restano come sono.
SKILL = [
    ("alea-iacta-est", "il-dado-e-tratto", "the-die-is-cast"),
    ("festina-lente", "chi-va-piano", "make-haste-slowly"),
    ("inspectio-decoris", "analisi-ux", "ux-audit"),
    ("sequere-pulchritudinem", "applica-restyle", "apply-restyle"),
    ("intus-et-extra", "analisi-swot", "swot-analysis"),
    ("limam-adhibere", "analisi-critica", "critical-review"),
    ("nec-plus-quam-oportet", "solo-il-necessario", "keep-it-simple"),
    ("vitium-ostendere", "prima-il-test", "test-first"),
    ("nemo-iudex-in-causa-sua", "occhi-nuovi", "fresh-eyes"),
    ("lex-scripta", "regole-scritte", "house-rules"),
    ("sine-more-interposita", "niente-indugi", "no-delay"),
    ("status-rei", "barra-di-stato", "status-line"),
    ("summa-rerum", "grimorio", "spellbook"),
    ("tabula-rasa", "fai-pulizia", "clean-slate"),
]

# Le altre parole dei comandi. Non toccano gli script Python: i badge della statusline restano latini.
ALTRE = [
    ("stop nec plus", "stop solo il necessario", "stop keep it simple"),
    ("levis", "leggero", "lite"),
]

# La guida ai comandi cambia anche pacchetto, lingua dell'installer e link al README.
GUIDA = "plugins/COMANDI.md"
SOLO_GUIDA = [
    ("Scritta a mano: le guide del set italiano e di quello inglese le ricava lingue/genera.py.",
     "Generata da lingue/genera.py a partire da plugins/COMANDI.md: non modificarla a mano.",
     "Generata da lingue/genera.py a partire da plugins/COMANDI.md: non modificarla a mano."),
    ("# Comandi in latino", "# Comandi in italiano", "# Comandi in inglese"),
    ("Pacchetto `omnia`", "Pacchetto `tutto`", "Pacchetto `all`"),
    ("omnia@armamentarium", "tutto@armamentarium", "all@armamentarium"),
    ("bash -s -- la", "bash -s -- it", "bash -s -- en"),
    ("](../README.md)", "](../../../README.md)", "](../../../README.md)"),
]

PACCHETTI = {
    "it": ("tutto", "Tutto l'armamentarium con i comandi in italiano: tutte le skill di tutti i "
                    "plugin, con i loro hook. Non installarlo insieme a omnia o all."),
    "en": ("all", "The whole armamentarium with English command names (instructions stay in "
                  "Italian): every skill of every plugin, with its hooks. Don't install it "
                  "together with omnia or tutto."),
}


def stesse_maiuscole(fonte, nome):
    """Scrive nome con le maiuscole di fonte: tutto maiuscolo, iniziale minuscola o com'è."""
    if fonte.isupper():
        return nome.upper()
    if fonte[0].islower() and not nome[:2].isupper():
        return nome[0].lower() + nome[1:]
    return nome


def regole(indice):
    """Le sostituzioni per la lingua in posizione indice (1 italiano, 2 inglese), nell'ordine."""
    for riga in SKILL:
        yield re.compile(rf"(?<![\w-]){re.escape(riga[0])}(?![\w-])"), lambda m, t=riga[indice]: t, True
    for riga in COMANDI:
        (nome, sigla), (nuovo, nuova) = riga[0], riga[indice]
        yield (re.compile(rf"(?<!\w){re.escape(nome)}(?!\w)", re.I),
               lambda m, t=nuovo: stesse_maiuscole(m.group(), t), True)
        yield re.compile(rf"(?<![\w-])-{sigla}(?![\w-])"), lambda m, t=nuova: "-" + t, True
    for riga in ALTRE:
        yield re.compile(rf"(?<!\w){re.escape(riga[0])}(?!\w)"), lambda m, t=riga[indice]: t, False


def traduttore(indice):
    tutte = list(regole(indice))

    def traduci(testo, python=False):
        for schema, sostituto, anche_python in tutte:
            if anche_python or not python:
                testo = schema.sub(sostituto, testo)
        return testo
    return traduci


def descrizione(testo):
    """La description del frontmatter di uno SKILL.md, su una riga."""
    frontmatter = testo.split("---")[1]
    m = re.search(r"^description:\s*(?:>-?|\|)?\s*(.*?)(?=^[a-z_-]+:|\Z)", frontmatter, re.M | re.S)
    return " ".join(m.group(1).split()) if m else ""


def file_sorgente():
    elenco = subprocess.run(["git", "ls-files", "--cached", "--others", "--exclude-standard", "plugins"],
                            cwd=RADICE, capture_output=True, text=True, check=True).stdout.split()
    # I plugin.json non servono: i pacchetti elencano skill e hook da soli, come omnia.
    return [f for f in elenco if "/.claude-plugin/" not in f and (RADICE / f).is_file()]


def genera(lingua, indice, sorgenti):
    traduci = traduttore(indice)
    base = RADICE / "lingue" / lingua
    shutil.rmtree(base, ignore_errors=True)
    for f in sorgenti:
        origine = RADICE / f
        destinazione = base / traduci(f)
        destinazione.parent.mkdir(parents=True, exist_ok=True)
        testo = traduci(origine.read_text(encoding="utf-8"), python=origine.suffix == ".py")
        if f == GUIDA:
            for riga in SOLO_GUIDA:
                assert riga[0] in testo, f"{GUIDA}: manca «{riga[0]}»"
                testo = testo.replace(riga[0], riga[indice])
        destinazione.write_text(testo, encoding="utf-8")
        shutil.copymode(origine, destinazione)
        if destinazione.name == "SKILL.md" and len(descrizione(testo)) > LIMITE_DESCRIZIONE:
            print(f"⚠ {destinazione.relative_to(RADICE)}: description oltre {LIMITE_DESCRIZIONE} caratteri")
    return traduci


def pacchetto(omnia, lingua, traduci):
    testo = traduci(json.dumps(omnia, ensure_ascii=False))
    testo = testo.replace('"./plugins/', f'"./lingue/{lingua}/plugins/')
    testo = testo.replace("${CLAUDE_PLUGIN_ROOT}/plugins/", f"${{CLAUDE_PLUGIN_ROOT}}/lingue/{lingua}/plugins/")
    voce = json.loads(testo)
    voce["name"], voce["description"] = PACCHETTI[lingua]
    voce["version"] = omnia["version"]
    return voce


def main():
    sorgenti = file_sorgente()
    catalogo = json.loads(MARKETPLACE.read_text(encoding="utf-8"))
    nomi = {nome for nome, _ in PACCHETTI.values()}
    plugins = [p for p in catalogo["plugins"] if p["name"] not in nomi]
    posto = next(i for i, p in enumerate(plugins) if p["name"] == "omnia") + 1
    for indice, lingua in enumerate(LINGUE, start=1):
        traduci = genera(lingua, indice, sorgenti)
        plugins.insert(posto + indice - 1, pacchetto(plugins[posto - 1], lingua, traduci))
        print(f"lingue/{lingua}: {len(sorgenti)} file, pacchetto {PACCHETTI[lingua][0]}")
    catalogo["plugins"] = plugins
    MARKETPLACE.write_text(json.dumps(catalogo, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
