#!/usr/bin/env node
// Lint do cérebro (sem IA): links quebrados, wiki sem fonte, páginas paradas, fora do índice.
// Uso: node .claude/scripts/lint.js [dias=30]  → escreve .claude/lint.md
const fs = require('fs');
const path = require('path');

const raiz = path.resolve(__dirname, '..', '..');
const DIAS = Number(process.argv[2]) || 30;
const IGNORAR = new Set(['.git', '.claude', 'node_modules', '_arquivo', 'painel']);

function listar(dir, base = '') {
  let out = [];
  for (const it of fs.readdirSync(dir, { withFileTypes: true })) {
    if (it.name.startsWith('.') || IGNORAR.has(it.name)) continue;
    const rel = base ? base + '/' + it.name : it.name;
    if (it.isDirectory()) out = out.concat(listar(path.join(dir, it.name), rel));
    else if (it.name.endsWith('.md')) out.push(rel);
  }
  return out;
}
const stem = (s) => path.basename(s).replace(/\.md$/i, '').trim().toLowerCase();

const arquivos = listar(raiz);
const stems = new Set(arquivos.map(stem));
const indice = fs.existsSync(path.join(raiz, '_indice.md')) ? fs.readFileSync(path.join(raiz, '_indice.md'), 'utf8') : '';
const noIndice = new Set([...indice.matchAll(/\[\[([^\]|#]+)/g)].map((m) => stem(m[1])));

const quebrados = [], semFonte = [], parados = [], foraIndice = [];
const agora = Date.now();
for (const rel of arquivos) {
  const txt = fs.readFileSync(path.join(raiz, rel), 'utf8');
  for (const m of txt.matchAll(/\[\[([^\]|#]+)(?:[#|][^\]]*)?\]\]/g)) {
    if (!stems.has(stem(m[1]))) quebrados.push(`${rel} → [[${m[1]}]]`);
  }
  if (rel.startsWith('wiki/') && rel !== 'wiki/decisoes.md') {
    if (!/fontes:\s*\S/.test(txt) && !/\[\[\d{4}-\d{2}-\d{2}/.test(txt)) semFonte.push(rel);
    const dias = Math.floor((agora - fs.statSync(path.join(raiz, rel)).mtimeMs) / 86400000);
    if (dias > DIAS) parados.push(`${rel} (${dias} dias)`);
    if (!noIndice.has(stem(rel))) foraIndice.push(rel);
  }
}

const sec = (t, l) => `## ${t} (${l.length})\n` + (l.length ? l.map((x) => `- ${x}`).join('\n') : '- nada') + '\n';
const out = `# Lint — ${new Date().toISOString().slice(0, 16).replace('T', ' ')}\n\n` +
  sec('Links quebrados', quebrados) + '\n' +
  sec('Wiki sem fonte', semFonte) + '\n' +
  sec(`Paradas há +${DIAS} dias`, parados) + '\n' +
  sec('Fora do _indice.md', foraIndice);
fs.mkdirSync(path.join(raiz, '.claude'), { recursive: true });
fs.writeFileSync(path.join(raiz, '.claude', 'lint.md'), out);
console.log(`lint: ${quebrados.length} links quebrados, ${semFonte.length} sem fonte, ${parados.length} parados, ${foraIndice.length} fora do índice`);
