/*
 * uxMisure — misure nella pagina per la skill inspectio-decoris.
 * Uso: valuta l'intero file con lo strumento JavaScript del browser, poi chiama
 *   uxMisure.contrasto()   uxMisure.overflow()   uxMisure.bersagli()
 *   uxMisure.palette()     uxMisure.tipografia()
 * Ogni funzione restituisce un oggetto serializzabile. Non modifica la pagina.
 */
(() => {
  const cv = document.createElement('canvas');
  cv.width = cv.height = 1;
  const cx = cv.getContext('2d', { willReadFrequently: true });

  // Qualunque formato CSS (rgb, hsl, oklch, color()) -> [r, g, b, a] con a in 0..1
  const rgba = (css) => {
    if (!css || css === 'transparent') return [0, 0, 0, 0];
    cx.clearRect(0, 0, 1, 1);
    cx.fillStyle = '#000';
    cx.fillStyle = css;
    cx.fillRect(0, 0, 1, 1);
    const d = cx.getImageData(0, 0, 1, 1).data;
    return [d[0], d[1], d[2], d[3] / 255];
  };
  const hex = ([r, g, b]) => '#' + [r, g, b].map(v => Math.round(v).toString(16).padStart(2, '0')).join('').toUpperCase();
  const over = (fg, bg) => { const a = fg[3]; return [0, 1, 2].map(i => fg[i] * a + bg[i] * (1 - a)).concat(1); };
  const lum = ([r, g, b]) => {
    const f = v => { v /= 255; return v <= 0.04045 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); };
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
  };
  const ratio = (a, b) => { const [l1, l2] = [lum(a), lum(b)].sort((x, y) => y - x); return (l1 + 0.05) / (l2 + 0.05); };

  const visibile = (el) => {
    const s = getComputedStyle(el);
    if (s.display === 'none' || s.visibility === 'hidden' || +s.opacity === 0) return false;
    const r = el.getBoundingClientRect();
    return r.width > 0 && r.height > 0;
  };
  const sel = (el) => {
    const parti = [];
    for (let e = el; e && e.nodeType === 1 && parti.length < 4; e = e.parentElement) {
      if (e.id) { parti.unshift('#' + CSS.escape(e.id)); break; }
      let p = e.tagName.toLowerCase();
      const c = [...e.classList].filter(k => !/^(css|sc|jsx|_)[-_]?[a-z0-9]{4,}$/i.test(k)).slice(0, 2);
      if (c.length) p += '.' + c.map(k => CSS.escape(k)).join('.');
      parti.unshift(p);
    }
    return parti.join(' > ');
  };
  const testoDiretto = (el) => [...el.childNodes].some(n => n.nodeType === 3 && n.textContent.trim().length > 0);
  const elementi = (max = 4000) => [...document.body.querySelectorAll('*')].slice(0, max);

  // Sfondo effettivo: compone i livelli semitrasparenti fino al primo opaco.
  const sfondo = (el) => {
    const livelli = [];
    let incerto = false;
    for (let e = el; e; e = e.parentElement) {
      const s = getComputedStyle(e);
      if (+s.opacity < 1) incerto = true;
      if (s.backgroundImage && s.backgroundImage !== 'none') incerto = true;
      const c = rgba(s.backgroundColor);
      if (c[3] > 0) { livelli.push(c); if (c[3] >= 1) break; }
    }
    let base = [255, 255, 255, 1];
    for (let i = livelli.length - 1; i >= 0; i--) base = livelli[i][3] >= 1 ? livelli[i] : over(livelli[i], base);
    return { colore: base, incerto };
  };

  const contrasto = () => {
    const gruppi = new Map();
    let esaminati = 0;
    for (const el of elementi()) {
      if (!testoDiretto(el) || !visibile(el)) continue;
      esaminati++;
      const s = getComputedStyle(el);
      const bg = sfondo(el);
      const fg = over(rgba(s.color), bg.colore);
      const px = parseFloat(s.fontSize), peso = parseInt(s.fontWeight, 10) || 400;
      const grande = px >= 24 || (px >= 18.66 && peso >= 700);
      const soglia = grande ? 3 : 4.5;
      const r = ratio(fg, bg.colore);
      if (r >= soglia) continue;
      const k = hex(fg) + ' su ' + hex(bg.colore) + (bg.incerto ? ' (incerto)' : '');
      const g = gruppi.get(k) || { coppia: k, rapporto: +r.toFixed(2), soglia, incerto: bg.incerto, occorrenze: 0, esempi: [] };
      g.occorrenze++;
      if (g.esempi.length < 3) g.esempi.push({ selettore: sel(el), testo: el.textContent.trim().slice(0, 40), px, peso });
      gruppi.set(k, g);
    }
    const sottoSoglia = [...gruppi.values()].sort((a, b) => a.rapporto - b.rapporto);
    return { viewport: innerWidth + 'x' + innerHeight, esaminati, sottoSoglia,
      nota: 'Voci "incerto": sfondo con immagine, sfumatura o opacità; verificare a occhio.' };
  };

  const overflow = () => {
    const vw = document.documentElement.clientWidth;
    const escono = [], tagliati = [];
    const scorrevole = (e) => { for (let p = e.parentElement; p; p = p.parentElement) {
      const o = getComputedStyle(p).overflowX; if (o === 'auto' || o === 'scroll' || o === 'hidden') return true; } return false; };
    for (const el of elementi()) {
      if (!visibile(el)) continue;
      const r = el.getBoundingClientRect();
      if ((r.right > vw + 1 || r.left < -1) && !scorrevole(el) && escono.length < 30)
        escono.push({ selettore: sel(el), destra: Math.round(r.right), viewport: vw });
      const s = getComputedStyle(el);
      if (testoDiretto(el) && s.overflow !== 'visible' && s.textOverflow !== 'ellipsis' &&
          el.scrollWidth > el.clientWidth + 1 && tagliati.length < 30)
        tagliati.push({ selettore: sel(el), testo: el.textContent.trim().slice(0, 40) });
    }
    return { viewport: innerWidth + 'x' + innerHeight,
      scorrimentoOrizzontale: document.documentElement.scrollWidth > vw + 1,
      larghezzaDocumento: document.documentElement.scrollWidth, escono, testoTagliato: tagliati };
  };

  const bersagli = () => {
    const q = 'a[href],button,input:not([type=hidden]),select,textarea,summary,[role=button],[role=link],[role=checkbox],[role=radio],[role=switch],[role=tab],[role=menuitem],[tabindex]:not([tabindex="-1"])';
    const sotto24 = [], sotto44 = [];
    for (const el of document.querySelectorAll(q)) {
      if (!visibile(el)) continue;
      const r = el.getBoundingClientRect();
      const inLinea = el.tagName === 'A' && getComputedStyle(el).display === 'inline' && el.parentElement && testoDiretto(el.parentElement);
      if (inLinea) continue; // i link nel testo sono esenti dal requisito WCAG
      const m = Math.min(r.width, r.height);
      const voce = { selettore: sel(el), dimensioni: Math.round(r.width) + 'x' + Math.round(r.height),
        nome: (el.getAttribute('aria-label') || el.textContent || el.getAttribute('title') || '').trim().slice(0, 30) || '(senza nome accessibile)' };
      if (m < 24) sotto24.push(voce); else if (m < 44) sotto44.push(voce);
    }
    return { viewport: innerWidth + 'x' + innerHeight, sotto24: sotto24.slice(0, 40), totaleSotto24: sotto24.length,
      sotto44: sotto44.slice(0, 40), totaleSotto44: sotto44.length,
      nota: '24px è il minimo WCAG 2.2 (2.5.8); 44px è raccomandato per uso touch.' };
  };

  const palette = () => {
    const conta = { testo: new Map(), sfondo: new Map(), bordo: new Map() };
    const add = (m, c) => { if (c[3] === 0) return; const k = hex(c) + (c[3] < 1 ? ' a' + c[3].toFixed(2) : ''); m.set(k, (m.get(k) || 0) + 1); };
    for (const el of elementi()) {
      if (!visibile(el)) continue;
      const s = getComputedStyle(el);
      if (testoDiretto(el)) add(conta.testo, rgba(s.color));
      add(conta.sfondo, rgba(s.backgroundColor));
      if (parseFloat(s.borderTopWidth) > 0) add(conta.bordo, rgba(s.borderTopColor));
    }
    const ord = m => [...m.entries()].sort((a, b) => b[1] - a[1]).map(([colore, n]) => ({ colore, n }));
    return { testo: ord(conta.testo), sfondo: ord(conta.sfondo), bordo: ord(conta.bordo) };
  };

  const tipografia = () => {
    const m = new Map();
    for (const el of elementi()) {
      if (!testoDiretto(el) || !visibile(el)) continue;
      const s = getComputedStyle(el);
      const k = [s.fontFamily.split(',')[0].replace(/["']/g, '').trim(), s.fontSize, s.fontWeight, s.lineHeight].join(' | ');
      const v = m.get(k) || { stile: k, n: 0, esempio: sel(el) };
      v.n++; m.set(k, v);
    }
    const lista = [...m.values()].sort((a, b) => b.n - a.n);
    return { combinazioni: lista.length, dimensioniDistinte: new Set(lista.map(v => v.stile.split(' | ')[1])).size, lista };
  };

  window.uxMisure = { contrasto, overflow, bersagli, palette, tipografia };
  return 'uxMisure pronto: contrasto(), overflow(), bersagli(), palette(), tipografia()';
})();
