#!/usr/bin/env node
/*
 * Ripiego senza browser MCP: apre ogni pagina in un Chromium headless a ogni viewport, salva lo
 * screenshot a pagina intera e lancia le misure di misure.js. Serve Playwright (vedi
 * references/prove-browser.md §8). Uso:
 *   NODE_PATH=<node_modules con playwright> node headless.cjs CARTELLA 390x844,1440x900 URL [URL...]
 * Stampa una riga JSON per pagina e viewport: misure, errori di console, risposte 4xx/5xx.
 * Palette e tipografia solo alla prima viewport: non cambiano con la larghezza.
 */
const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const [cartella, viewport, ...urls] = process.argv.slice(2);
if (!cartella || !viewport || !urls.length) {
  console.error('uso: node headless.cjs CARTELLA 390x844,1440x900 URL [URL...]');
  process.exit(2);
}
const MISURE = fs.readFileSync(path.join(__dirname, 'misure.js'), 'utf8');
const ATTESA_RETE_MS = 10000;

const nomeFile = (url, larghezza) =>
  `${new URL(url).pathname.replace(/[^\w]+/g, '-').replace(/^-|-$/g, '') || 'home'}-${larghezza}.png`;

(async () => {
  fs.mkdirSync(cartella, { recursive: true });
  const browser = await chromium.launch();
  try {
    for (const url of urls) {
      for (const [i, vista] of viewport.split(',').entries()) {
        const [width, height] = vista.split('x').map(Number);
        const pagina = await browser.newPage({ viewport: { width, height } });
        const console_ = [];
        const rete = [];
        pagina.on('console', m => ['error', 'warning'].includes(m.type()) && console_.push(`${m.type()}: ${m.text()}`));
        pagina.on('pageerror', e => console_.push(`pageerror: ${e.message}`));
        pagina.on('response', r => r.status() >= 400 && rete.push(`${r.status()} ${r.url()}`));
        await pagina.goto(url, { waitUntil: 'load' });
        // Le app che tengono aperta una connessione non arrivano mai a networkidle: si va avanti lo stesso.
        await pagina.waitForLoadState('networkidle', { timeout: ATTESA_RETE_MS }).catch(() => {});
        await pagina.evaluate(() => document.fonts.ready);
        const screenshot = nomeFile(url, width);
        await pagina.screenshot({ path: path.join(cartella, screenshot), fullPage: true });
        await pagina.evaluate(MISURE);
        const misure = await pagina.evaluate(tutte => ({
          contrasto: uxMisure.contrasto(),
          overflow: uxMisure.overflow(),
          bersagli: uxMisure.bersagli(),
          ...(tutte && { palette: uxMisure.palette(), tipografia: uxMisure.tipografia() }),
        }), i === 0);
        console.log(JSON.stringify({ url, viewport: vista, screenshot, console: console_, rete, ...misure }));
        await pagina.close();
      }
    }
  } finally {
    await browser.close();
  }
})().catch(e => {
  console.error(e.message);
  process.exit(1);
});
