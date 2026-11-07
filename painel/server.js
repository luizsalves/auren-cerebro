#!/usr/bin/env node
// Painel do Cérebro — servidor sem dependências (Node 18+).
// Lê os .md da pasta do cérebro, monta o grafo e serve o painel.
'use strict';

const http = require('http');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// ---------- Configuração (variáveis de ambiente) ----------
const CEREBRO = path.resolve(process.env.CEREBRO_DIR || path.join(__dirname, '..'));
const PORT = Number(process.env.PORT) || 3333;
const HOST = process.env.HOST || '0.0.0.0';
const SENHA = process.env.PAINEL_SENHA || '';
const SEGREDO = process.env.PAINEL_SEGREDO ||
  crypto.createHash('sha256').update('cerebro:' + SENHA + ':' + CEREBRO).digest('hex');
const COMPILACAO = process.env.PROXIMA_COMPILACAO || '23:30';
const DIAS_PARADO = Number(process.env.DIAS_PARADO) || 30;

// Pastas/arquivos que não entram no grafo
const IGNORAR_PASTAS = new Set(['.git', 'node_modules', 'painel', '_arquivo', '.claude', '.obsidian']);
const IGNORAR_ARQUIVOS = new Set(['CLAUDE.md', 'AGENTS.md', 'CLAUDE.local.md', '_indice.md', 'README.md']);

// Pasta -> lobo (o primeiro prefixo que bater vence)
const LOBOS = [
  ['wiki/projetos', 'frontal'],
  ['wiki/notas', 'parietal'],
  ['wiki/clientes', 'temporal'],
  ['wiki/pessoas', 'temporal'],
  ['diario', 'occipital'],
  ['raw', 'cerebelo'],
  ['identidade', 'tronco'],
  ['agora.md', 'frontal'],
  ['wiki', 'parietal'],
];
const LOBO_PADRAO = 'parietal';

// ---------- Leitura do cérebro ----------
function listarMd(dir, base = '') {
  let out = [];
  let itens;
  try { itens = fs.readdirSync(dir, { withFileTypes: true }); } catch { return out; }
  for (const it of itens) {
    if (it.name.startsWith('.')) continue;
    const rel = base ? base + '/' + it.name : it.name;
    if (it.isDirectory()) {
      if (IGNORAR_PASTAS.has(it.name)) continue;
      out = out.concat(listarMd(path.join(dir, it.name), rel));
    } else if (it.isFile() && it.name.toLowerCase().endsWith('.md')) {
      if (!base && IGNORAR_ARQUIVOS.has(it.name)) continue;
      out.push(rel);
    }
  }
  return out;
}

function loboDe(rel) {
  for (const [pref, lobo] of LOBOS) {
    if (rel === pref || rel.startsWith(pref + '/')) return lobo;
  }
  return LOBO_PADRAO;
}

function stemDe(nome) {
  return path.basename(nome).replace(/\.md$/i, '').trim().toLowerCase();
}

function separarFrontmatter(txt) {
  const fm = {};
  let corpo = txt;
  const m = txt.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/);
  if (m) {
    corpo = txt.slice(m[0].length);
    for (const linha of m[1].split(/\r?\n/)) {
      const kv = linha.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
      if (kv) fm[kv[1]] = kv[2].replace(/^["']|["']$/g, '');
    }
  }
  return { fm, corpo };
}

function extrairLinks(corpo) {
  const alvos = new Set();
  const wiki = /\[\[([^\]|#]+)(?:[#|][^\]]*)?\]\]/g;
  let m;
  while ((m = wiki.exec(corpo))) alvos.add(stemDe(m[1]));
  const md = /\]\(([^)\s]+\.md)(?:#[^)]*)?\)/gi;
  while ((m = md.exec(corpo))) if (!/^https?:/i.test(m[1])) alvos.add(stemDe(decodeURIComponent(m[1])));
  return alvos;
}

let cache = { assinatura: '', grafo: null, mtimes: new Map() };

function lerCerebro() {
  const arquivos = listarMd(CEREBRO);
  const mtimes = new Map();
  for (const rel of arquivos) {
    try { mtimes.set(rel, fs.statSync(path.join(CEREBRO, rel)).mtimeMs); } catch {}
  }
  const assinatura = [...mtimes].map(([k, v]) => k + ':' + v).sort().join('|');
  if (assinatura === cache.assinatura && cache.grafo) return { grafo: cache.grafo, mudados: [] };

  const mudados = [];
  for (const [k, v] of mtimes) if (cache.mtimes.get(k) !== v) mudados.push(k);
  for (const k of cache.mtimes.keys()) if (!mtimes.has(k)) mudados.push(k);

  const nos = [];
  const porStem = new Map();
  const linksDe = new Map();
  const agora = Date.now();
  for (const rel of mtimes.keys()) {
    let txt = '';
    try { txt = fs.readFileSync(path.join(CEREBRO, rel), 'utf8'); } catch { continue; }
    const { fm, corpo } = separarFrontmatter(txt);
    const titulo = (fm.title || fm.titulo || (corpo.match(/^#\s+(.+)$/m) || [])[1] || path.basename(rel, '.md')).trim();
    const stem = stemDe(rel);
    const mtime = mtimes.get(rel);
    nos.push({
      id: rel,
      label: path.basename(rel, '.md'),
      titulo,
      lobo: loboDe(rel),
      mtime,
      dias: Math.floor((agora - mtime) / 86400000),
      wiki: rel.startsWith('wiki/'),
    });
    if (!porStem.has(stem)) porStem.set(stem, rel);
    linksDe.set(rel, extrairLinks(corpo));
  }

  const chaves = new Set();
  const arestas = [];
  for (const [de, alvos] of linksDe) {
    for (const s of alvos) {
      const para = porStem.get(s);
      if (!para || para === de) continue;
      const k = de < para ? de + '\u0000' + para : para + '\u0000' + de;
      if (chaves.has(k)) continue;
      chaves.add(k);
      arestas.push([de, para]);
    }
  }
  const grau = new Map(nos.map((n) => [n.id, 0]));
  for (const [a, b] of arestas) { grau.set(a, grau.get(a) + 1); grau.set(b, grau.get(b) + 1); }
  for (const n of nos) n.grau = grau.get(n.id);

  const parados = nos.filter((n) => n.wiki && n.dias > DIAS_PARADO).length;
  const grafo = { nos, arestas, parados, diasParado: DIAS_PARADO, compilacao: COMPILACAO, raiz: CEREBRO, geradoEm: agora };
  cache = { assinatura, grafo, mtimes };
  return { grafo, mudados };
}

function caminhoSeguro(rel) {
  if (typeof rel !== 'string' || !rel.toLowerCase().endsWith('.md')) return null;
  const abs = path.resolve(CEREBRO, rel);
  if (!abs.startsWith(CEREBRO + path.sep)) return null;
  const partes = path.relative(CEREBRO, abs).split(path.sep);
  if (partes.some((p) => IGNORAR_PASTAS.has(p))) return null;
  return abs;
}

// ---------- Autenticação ----------
function assinar(valor) {
  return crypto.createHmac('sha256', SEGREDO).update(valor).digest('hex');
}
function tokenNovo() {
  const exp = String(Date.now() + 30 * 86400000);
  return exp + '.' + assinar(exp);
}
function autenticado(req) {
  if (!SENHA) return true;
  const c = (req.headers.cookie || '').split(/;\s*/).find((x) => x.startsWith('cerebro='));
  if (!c) return false;
  const [exp, sig] = c.slice(8).split('.');
  if (!exp || !sig || Number(exp) < Date.now()) return false;
  const esperado = assinar(exp);
  return sig.length === esperado.length && crypto.timingSafeEqual(Buffer.from(sig), Buffer.from(esperado));
}
function senhaConfere(s) {
  const a = crypto.createHash('sha256').update(String(s)).digest();
  const b = crypto.createHash('sha256').update(SENHA).digest();
  return crypto.timingSafeEqual(a, b);
}

// ---------- HTTP ----------
const PUBLICO = path.join(__dirname, 'public');
const clientes = new Set();

function enviar(res, status, corpo, tipo = 'application/json; charset=utf-8', extra = {}) {
  res.writeHead(status, { 'Content-Type': tipo, 'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff', ...extra });
  res.end(typeof corpo === 'string' || Buffer.isBuffer(corpo) ? corpo : JSON.stringify(corpo));
}

function lerCorpo(req, limite = 200000) {
  return new Promise((ok, erro) => {
    let dados = '';
    req.on('data', (c) => { dados += c; if (dados.length > limite) { erro(new Error('grande demais')); req.destroy(); } });
    req.on('end', () => ok(dados));
    req.on('error', erro);
  });
}

function hojeArquivo() {
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}-${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
}

const servidor = http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://x');
  try {
    if (url.pathname === '/login' && req.method === 'POST') {
      const corpo = new URLSearchParams(await lerCorpo(req));
      if (SENHA && senhaConfere(corpo.get('senha') || '')) {
        return enviar(res, 303, '', 'text/plain', {
          Location: '/',
          'Set-Cookie': `cerebro=${tokenNovo()}; HttpOnly; SameSite=Lax; Path=/; Max-Age=${30 * 86400}`,
        });
      }
      await new Promise((r) => setTimeout(r, 600));
      return enviar(res, 303, '', 'text/plain', { Location: '/?erro=1' });
    }
    if (url.pathname === '/sair') {
      return enviar(res, 303, '', 'text/plain', { Location: '/', 'Set-Cookie': 'cerebro=; Path=/; Max-Age=0' });
    }

    if (!autenticado(req)) {
      if (url.pathname.startsWith('/api/')) return enviar(res, 401, { erro: 'login' });
      return enviar(res, 200, fs.readFileSync(path.join(PUBLICO, 'login.html')), 'text/html; charset=utf-8');
    }

    if (url.pathname === '/' || url.pathname === '/index.html') {
      return enviar(res, 200, fs.readFileSync(path.join(PUBLICO, 'index.html')), 'text/html; charset=utf-8');
    }

    if (url.pathname === '/api/grafo') return enviar(res, 200, lerCerebro().grafo);

    if (url.pathname === '/api/nota') {
      const abs = caminhoSeguro(url.searchParams.get('id'));
      if (!abs || !fs.existsSync(abs)) return enviar(res, 404, { erro: 'não encontrada' });
      const txt = fs.readFileSync(abs, 'utf8');
      const { fm, corpo } = separarFrontmatter(txt);
      return enviar(res, 200, { id: path.relative(CEREBRO, abs).split(path.sep).join('/'), fm, md: corpo });
    }

    if (url.pathname === '/api/capturar' && req.method === 'POST') {
      const { texto } = JSON.parse((await lerCorpo(req)) || '{}');
      const limpo = String(texto || '').trim();
      if (!limpo) return enviar(res, 400, { erro: 'texto vazio' });
      fs.mkdirSync(path.join(CEREBRO, 'raw'), { recursive: true });
      let rel = `raw/${hojeArquivo()}-captura.md`;
      let n = 1;
      while (fs.existsSync(path.join(CEREBRO, rel))) rel = `raw/${hojeArquivo()}-captura-${++n}.md`;
      const conteudo = `---\ntipo: captura\ncriado: ${new Date().toISOString()}\nfonte: painel\n---\n\n${limpo}\n`;
      fs.writeFileSync(path.join(CEREBRO, rel), conteudo, { flag: 'wx' });
      verificar();
      return enviar(res, 200, { ok: true, id: rel });
    }

    if (url.pathname === '/api/eventos') {
      res.writeHead(200, { 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-store', Connection: 'keep-alive', 'X-Accel-Buffering': 'no' });
      res.write('retry: 3000\n\n');
      clientes.add(res);
      req.on('close', () => clientes.delete(res));
      return;
    }

    return enviar(res, 404, { erro: 'não encontrado' });
  } catch (e) {
    console.error(e);
    return enviar(res, 500, { erro: 'falha interna' });
  }
});

// ---------- Ao vivo: verifica mudanças a cada 2s ----------
function verificar() {
  let r;
  try { r = lerCerebro(); } catch (e) { console.error(e); return; }
  if (!r.mudados.length) return;
  const msg = `event: mudou\ndata: ${JSON.stringify(r.mudados.slice(0, 200))}\n\n`;
  for (const c of clientes) c.write(msg);
}
setInterval(verificar, 2000).unref();
setInterval(() => { for (const c of clientes) c.write(': ping\n\n'); }, 25000).unref();

lerCerebro();
servidor.listen(PORT, HOST, () => {
  console.log(`Painel do Cérebro em http://${HOST}:${PORT}  (cérebro: ${CEREBRO})`);
  if (!SENHA) console.warn('ATENÇÃO: PAINEL_SENHA não definida — painel sem senha.');
});
