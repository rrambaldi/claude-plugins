# claude-plugins

Armamentarium: plugin personali per Claude Code. Analisi critiche e SWOT, audit UX, il minimo
codice che funziona, bug corretti partendo dal test, il diff rivisto da un subagente, controlli
prima del commit, piani lunghi che vanno avanti senza di te, una statusline e qualche abitudine
di igiene.

## Comandi

Le stesse skill in tre set, uno per lingua dei comandi: se ne installa uno solo. Ogni guida dice
come si installa quel set, come si usano i comandi e cosa fanno.

- [Latino](plugins/COMANDI.md), pacchetto `omnia`: il set di default
- [Italiano](lingue/it/plugins/COMANDI.md), pacchetto `tutto`
- [English](lingue/en/plugins/COMANDI.md), pacchetto `all`

Cambiano solo incantesimi, sigle e comandi slash. Le istruzioni delle skill restano in italiano,
e Claude risponde nella tua lingua.

## Installa

Da una shell, anche dal terminale di VS Code:

```
curl -fsSL https://raw.githubusercontent.com/rrambaldi/claude-plugins/main/install.sh | bash
```

Dentro Claude Code puoi lanciarlo così com'è mettendo `!` davanti. Ti chiede la lingua dei
comandi: latino (invio), italiano o inglese. Per sceglierla subito: `… | bash -s -- it` (o `la`,
`en`).

Cosa fa:

- toglie ponytail e modalita-fastidio: plugin, skill, comandi e hook in `settings.json` (con copia
  `.bak`), a livello utente, progetto e locale;
- aggiunge il marketplace e installa a livello utente il pacchetto della lingua scelta, con tutte
  le skill e i loro hook: `omnia` (latino), `tutto` (italiano) o `all` (inglese). Toglie gli altri
  pacchetti, che raddoppierebbero le skill. Se l'organizzazione ne dà già uno da claude.ai
  (Required o Installed by default), Claude Code lo sincronizza da solo: lo script usa quello,
  non installa niente e toglie le copie locali;
- mette le skill del pacchetto su `on` in `skillOverrides` (settings utente) e toglie le eccezioni
  che le spengono nei settings del progetto;
- accende `autoUpdate` sul marketplace (settings utente): a ogni avvio Claude Code scarica le
  versioni nuove, se in `marketplace.json` è cambiata `version`;
- alla fine elenca i file rimasti di ponytail o fastidio e chiede se toglierli; quelli che li
  citano soltanto, come una statusline, li segnala e basta.

Per toglierli senza domande: `… | bash -s -- -y`. Con `-y` non chiede neanche la lingua: se non la
scrivi, è il latino.

Si può rilanciare: la volta dopo aggiorna. I livelli progetto e locale valgono per la cartella da
cui lo lanci. Poi riavvia Claude Code.

In un'organizzazione che ha appena aggiunto un pacchetto, apri Claude Code una volta prima di
lanciarlo: il sync avviene all'avvio, e senza lo script non lo vede.

### Senza script

Da dentro Claude Code:

```
/plugin marketplace add rrambaldi/claude-plugins
/plugin install omnia@armamentarium
```

Al posto di `omnia`: `tutto` per i comandi in italiano, `all` per quelli in inglese. Uno solo.

Su claude.ai (chat e Claude Code sul web) gli script non girano: skill e plugin si gestiscono da
Customize → Skills e Customize → Plugins. Se installi il marketplace sia lì sia in locale, ogni
skill compare due volte.

<details>
<summary>Un plugin alla volta (solo in latino)</summary>

```
/plugin install limam-adhibere@armamentarium
/plugin install inspectio-decoris@armamentarium
/plugin install sine-more-interposita@armamentarium
/plugin install nec-plus-quam-oportet@armamentarium
/plugin install festina-lente@armamentarium
/plugin install nomen-mutare@armamentarium
/plugin install cave-canem@armamentarium
/plugin install tabula-rasa@armamentarium
/plugin install status-rei@armamentarium
/plugin install summa-rerum@armamentarium
```

Non installarli insieme a un pacchetto (`omnia`, `tutto` o `all`), o ogni skill compare due volte.

</details>

## Aggiungere un plugin

Il set latino in `plugins/` è l'unico che si scrive a mano. `python3 lingue/genera.py` ne ricava
`lingue/it` e `lingue/en`, cambiando nomi e sigle, e i pacchetti `tutto` e `all` in
`marketplace.json`, copiati da `omnia` con la sua versione. Scrive anche, dentro `plugins/`, le copie
di `limam-adhibere` con i comandi in sanscrito, quenya, klingon e gallese: si cambiano dal corpo di
`limam-adhibere` o da `lingue/arcane/`, non a mano.

1. Crea `plugins/<nome>/.claude-plugin/plugin.json` e `plugins/<nome>/skills/<nome>/SKILL.md`.
2. Aggiungi la voce in `.claude-plugin/marketplace.json`, e aggiungi le sue skill (e gli hook, se
   ne ha) alla voce `omnia` dello stesso file.
3. Quando modifichi una skill, incrementa `version` in `plugin.json`, nella sua voce di
   `marketplace.json` e nella voce `omnia`.
4. Aggiorna `plugins/summa-rerum/skills/summa-rerum/help.md`, l'help che *Summa rerum* (`-SR`)
   stampa così com'è, e `plugins/COMANDI.md`, la guida ai comandi linkata qui sopra.
5. Quando una skill o un testo suggerisce un comando, scrivi l'incantesimo latino con la sigla:
   *Sequere pulchritudinem* (`-SP`), mai `-SP` da solo. In fondo è una magia.
6. Un comando o una skill nuovi: aggiungi nomi e sigle in italiano e inglese in `COMANDI` e
   `SKILL` di `lingue/genera.py`. Una sigla non deve indicare due skill diverse, in nessuna
   lingua.
7. Alla fine lancia `python3 lingue/genera.py`, che rigenera il set italiano, quello inglese, le
   loro guide ai comandi e i pacchetti `tutto` e `all`. `lingue/it` e `lingue/en` non si toccano
   a mano.
