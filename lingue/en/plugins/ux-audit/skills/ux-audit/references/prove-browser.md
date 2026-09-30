# Prove nel browser

Come raccogliere prove verificabili. Usa lo strumento browser già disponibile nell'ambiente
(Playwright MCP, Claude in Chrome, browser integrato dell'app, playwright da riga di comando). Se
non ce n'è nessuno, il ripiego è la sezione 8, e installa qualcosa solo con il consenso
dell'utente.

## Indice

1. Scelta dell'URL
2. Viewport
3. Registro delle prove
4. Console e rete
5. Misure con `scripts/misure.js`
6. Accessibilità con axe-core
7. Metriche di caricamento
8. Senza browser MCP

## 1. Scelta dell'URL

Preferisci staging o l'ambiente indicato dall'utente. Un server locale va bene se il browser lo
raggiunge: il browser integrato di Claude e quello in cloud spesso **non** vedono il `localhost`
di un'altra macchina. Se l'app richiede login, usa l'account di test fornito; se la sessione
scade durante il percorso, annotalo nel registro, rientra e riprendi dall'ultimo passo.

## 2. Viewport

Usa, quando lo strumento lo permette, una vera impostazione di viewport e non il ridimensionamento
della finestra.

| Viewport | Cosa guardare |
|---|---|
| 390×844 | Ordine su mobile, compito e azione primaria visibili senza scroll nei compiti brevi, bersagli touch ≥ 44px, testi che vanno a capo |
| 768×1024 | Passaggio intermedio: è qui che si rompono sidebar, tabelle e griglie |
| 1440×900 | Composizione desktop di riferimento |
| 1920×1080 | Ruolo dello spazio su schermi larghi, lunghezza delle righe |
| 2560×1080 | Solo per layout a tutta larghezza, divisi in due o a larghezza fissa: un pannello di 480px in mezzo al vuoto a 2560 non si vede a 1440 |

Livello rapido: 390 e 1440. Standard: le prime quattro. Completo: tutte quelle pertinenti.

Per ogni viewport: attendi font, immagini e dati; cattura lo screenshot prima di interagire;
guardalo sia a grandezza reale sia "strizzando gli occhi" (quale elemento domina?).

## 3. Registro delle prove

Una riga per azione. Serve a te per non saltare passi e all'utente per ripetere il rilievo.

```
REGISTRO — /fatture/nuova — persona: impiegata amministrativa, fretta, desktop
10:14:02  digitato "Rossi S.r.l." in Cliente (input[name="cliente"])  → suggerimenti in 300ms
10:14:05  scelto "Rossi S.r.l." dal menu                              → campi indirizzo compilati
10:14:11  clic su "Salva bozza" (button[type=submit])                  → toast "Bozza salvata", URL /fatture/1042
10:14:12  console: 0 errori, 1 warning (React key)                    → rilievo A2
10:14:15  390×844: "Salva bozza" sotto la piega, 3 scroll             → rilievo A5
```

Per ogni pagina dei flussi scelti servono almeno: un campo compilato con testo realistico,
l'azione primaria eseguita (o fermata prima dell'ultimo clic se irreversibile), un dettaglio o
modale aperto, la verifica dello stato dopo l'azione, una lettura della console, screenshot prima e
dopo. Una riga senza un'azione reale dietro non va scritta.

## 4. Console e rete

Dopo ogni azione principale leggi console e richieste. Errori e 5xx sono Critica; warning e 403/404
su pagine autenticate sono Alta. Se l'app ha rumore noto e innocuo (log di monitoraggio, sonde di
autenticazione che rispondono 401 per scelta), riportalo come tale con il conteggio, senza
trasformarlo in rilievo.

## 5. Misure con `scripts/misure.js`

Il file contiene funzioni da eseguire nella pagina con lo strumento di JavaScript del browser.
Leggilo, incolla il contenuto come espressione da valutare e chiama le funzioni:

- `uxMisure.contrasto()`: per ogni elemento di testo visibile calcola il colore del testo, lo
  sfondo effettivo risalendo gli antenati, il rapporto di contrasto e la soglia (4.5:1, oppure
  3:1 per testo grande: ≥ 24px, o ≥ 18.66px in grassetto). Restituisce solo i casi sotto soglia,
  raggruppati per coppia di colori. Quando lo sfondo è un'immagine o una sfumatura il risultato è
  marcato `incerto`: riportalo come `[?]` e verifica a occhio sullo screenshot.
- `uxMisure.overflow()`: larghezza del documento rispetto alla viewport ed elementi che escono dal
  contenitore o hanno il testo tagliato.
- `uxMisure.bersagli()`: controlli interattivi più piccoli di 24px (minimo WCAG 2.2) o di 44px
  (raccomandato su touch).
- `uxMisure.palette()`: colori di testo, sfondo e bordo effettivamente usati, con frequenza, per
  ricostruire la palette reale; `uxMisure.tipografia()`: combinazioni di dimensione, peso e
  interlinea usate. Servono a mostrare quante varianti esistono rispetto a quante ne servirebbero.

I risultati sono `[M]`. Ripeti `contrasto` anche in modalità scura, se c'è.

## 6. Accessibilità con axe-core

Se il progetto ha già `axe-core` o `@axe-core/playwright` tra le dipendenze, usa quello. Altrimenti
prova a caricarlo nella pagina:

```js
await new Promise((ok, ko) => { const s = document.createElement('script');
  s.src = 'https://cdn.jsdelivr.net/npm/axe-core@4/axe.min.js'; s.onload = ok; s.onerror = ko;
  document.head.appendChild(s); });
const r = await axe.run(document, { resultTypes: ['violations'] });
r.violations.map(v => ({ id: v.id, impatto: v.impact, nodi: v.nodes.length, esempio: v.nodes[0]?.target }));
```

Se la policy di sicurezza della pagina (CSP) o la rete bloccano lo script, dichiaralo e ripiega su
controlli manuali: ordine del tab, focus visibile, etichette dei campi, nomi accessibili dei
bottoni con sola icona, testo alternativo delle immagini. Ricorda che gli strumenti automatici
trovano solo una parte dei problemi: un axe pulito non significa accessibile.

Mappa l'impatto axe sulla severità: critical → Critica, serious → Alta, moderate → Media,
minor → Bassa.

## 7. Metriche di caricamento

Su una pagina rappresentativa, subito dopo il caricamento:

```js
await new Promise(r => setTimeout(r, 3000));
const lcp = performance.getEntriesByType('largest-contentful-paint').at(-1)?.startTime;
const cls = performance.getEntriesByType('layout-shift').filter(e => !e.hadRecentInput)
  .reduce((s, e) => s + e.value, 0);
({ lcp_ms: Math.round(lcp ?? -1), cls: +cls.toFixed(3) });
```

Se le voci non sono disponibili (alcuni browser non le conservano senza un observer attivo dal
caricamento), dichiaralo `[?]`. Soglie pragmatiche: LCP oltre 4 s o CLS oltre 0.25 sono Alta.
Una singola misura su una macchina non è una statistica: riportala come indicazione, con le
condizioni (rete, cache).

## 8. Senza browser MCP

### Ripiego headless

Se non c'è uno strumento browser ma c'è Node (18 o più) e un URL che questa macchina raggiunge,
anche `localhost`, `scripts/headless.cjs` apre le pagine in un Chromium headless. A ogni viewport
salva lo screenshot a pagina intera e lancia le misure di `misure.js`, con errori di console e
risposte 4xx/5xx.

Serve Playwright. Se il progetto lo ha già tra le dipendenze, usa quello. Altrimenti chiedi il
consenso, perché scarica il pacchetto e un Chromium, e installa il pacchetto fuori dal progetto,
nello scratchpad della sessione:

```sh
T=<scratchpad>/playwright
npm install --prefix "$T" playwright
"$T/node_modules/.bin/playwright" install chromium
NODE_PATH="$T/node_modules" node scripts/headless.cjs "$T/prove" 390x844,1440x900 https://staging.example.com/fatture
```

Con il Playwright del progetto: `NODE_PATH=<repo>/node_modules node scripts/headless.cjs …`, e se
manca il browser `npx playwright install chromium` dal repo, sempre con il consenso.

- Lo script stampa una riga JSON per pagina e viewport: le misure sono `[M]`. Guarda gli
  screenshot che salva: valgono `[V]`.
- Per un flusso con interazione (login, un form, una modale) scrivi nella stessa cartella uno
  script Playwright con i passi, sullo stesso modello, e riporta ogni passo nel registro delle prove.
- Se Chromium non parte per librerie di sistema mancanti, dillo: installarle chiede `sudo`, e
  decide l'utente.
- Alla fine togli la cartella `$T`. Chromium resta in `~/.cache/ms-playwright`: chiedi se tenerlo
  per *Apply restyle* (`-AR`) o toglierlo.

### Senza browser

Se non si può neanche il ripiego (niente Node, niente URL raggiungibile, niente consenso):

1. dichiaralo in testa al report e metti il verdetto al massimo a **Incompleto** per le
   dimensioni che richiedono il percorso;
2. analizza il codice: regole responsive, semantica, gestione del focus, stati implementati,
   token, rischi di overflow, `prefers-reduced-motion`;
3. usa gli screenshot forniti dall'utente, con valori `[S]`;
4. consegna all'utente l'elenco delle verifiche manuali più a rischio (viewport e relazioni
   precise da controllare), invece di dichiarare una verifica visiva che non hai fatto.
