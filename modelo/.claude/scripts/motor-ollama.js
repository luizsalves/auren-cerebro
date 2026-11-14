#!/usr/bin/env node
// Motor alternativo: roda um agente contra o Ollama (ou qualquer servidor com a API /api/chat do Ollama).
// Mesmas regras do rodar-agente.sh, aplicadas aqui dentro: ferramentas limitadas, comandos só da allowlist,
// escrita só nos caminhos permitidos. Sem dependências (Node 18+).
//
// Uso: echo "$PROMPT" | motor-ollama.js --modelo qwen2.5:14b --ferramentas Read,Write,Bash \
//        --pode-executar $'node x.js\ngit log' --max-turnos 30 --escrever "<exec>.md,raw/,agentes/x/pendencias.md" --raiz /root/cerebro [--extra /opt/saas/x]
// Saída: JSON no mesmo formato do `claude -p --output-format json` (result, total_cost_usd, num_turns, duration_ms, is_error).
'use strict';
const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const arg = (n, d = '') => { const i = process.argv.indexOf('--' + n); return i > -1 ? process.argv[i + 1] : d; };
const URL_OLLAMA = (process.env.OLLAMA_URL || 'http://127.0.0.1:11434').replace(/\/$/, '');
const MODELO = arg('modelo', process.env.OLLAMA_MODELO || 'qwen2.5:14b');
const RAIZ = path.resolve(arg('raiz', process.cwd()));
const EXTRA = arg('extra', '') ? path.resolve(arg('extra')) : '';
const FERR = new Set(arg('ferramentas', 'Read,Glob,Grep').split(',').map((s) => s.trim()).filter(Boolean));
const PODE = arg('pode-executar', '').split('\n').map((s) => s.trim()).filter(Boolean);
const ESCREVER = arg('escrever', '').split(',').map((s) => s.trim()).filter(Boolean).map((p) => path.resolve(RAIZ, p));
const MAX_TURNOS = Number(arg('max-turnos', 30)) || 30;
const PROMPT = fs.readFileSync(0, 'utf8');
const inicio = Date.now();

function dentro(abs) {
  const ok = (b) => b && (abs === b || abs.startsWith(b + path.sep));
  return ok(RAIZ) || ok(EXTRA);
}
function resolver(p) {
  const abs = path.resolve(RAIZ, String(p || ''));
  if (!dentro(abs)) throw new Error('caminho fora da raiz do cérebro: ' + p);
  const rel = path.relative(RAIZ, abs);
  if (/^(identidade|\.claude|CLAUDE\.md)/.test(rel) && !ESCREVER.includes(abs)) {
    // leitura permitida, escrita nunca (checado em escrever)
  }
  return abs;
}
function podeEscrever(abs) {
  for (const e of ESCREVER) {
    if (e.endsWith(path.sep) || /\/$/.test(e) || fs.existsSync(e) && fs.statSync(e).isDirectory()) {
      const base = e.replace(/\/$/, '');
      if (abs.startsWith(base + path.sep)) return fs.existsSync(abs) ? 'nao-existente-apenas' : 'criar';
    } else if (abs === e) return 'acrescentar';
  }
  return null;
}
function cortar(s, n = 20000) { s = String(s); return s.length > n ? s.slice(0, n) + `\n…[cortado, ${s.length} caracteres]` : s; }

const FERRAMENTAS = {
  ler_arquivo: {
    ativa: FERR.has('Read'),
    desc: 'Lê um arquivo de texto do cérebro (ou da pasta de código do agente). Caminho relativo à raiz do cérebro.',
    params: { caminho: { type: 'string' } },
    run: ({ caminho }) => cortar(fs.readFileSync(resolver(caminho), 'utf8')),
  },
  listar: {
    ativa: FERR.has('Glob') || FERR.has('Read'),
    desc: 'Lista arquivos e pastas de um diretório (não recursivo).',
    params: { caminho: { type: 'string' } },
    run: ({ caminho }) => fs.readdirSync(resolver(caminho || '.'), { withFileTypes: true }).filter((d) => !d.name.startsWith('.git')).map((d) => (d.isDirectory() ? d.name + '/' : d.name)).join('\n') || '(vazio)',
  },
  buscar: {
    ativa: FERR.has('Grep'),
    desc: 'Busca um texto (sem distinguir maiúsculas) nos arquivos .md de uma pasta, recursivamente. Devolve arquivo:linha.',
    params: { texto: { type: 'string' }, pasta: { type: 'string' } },
    run: ({ texto, pasta }) => {
      const base = resolver(pasta || '.'); const alvo = String(texto).toLowerCase(); const hits = [];
      const anda = (d) => { for (const it of fs.readdirSync(d, { withFileTypes: true })) { if (it.name.startsWith('.') || it.name === 'node_modules') continue; const p = path.join(d, it.name); if (it.isDirectory()) anda(p); else if (/\.(md|txt|json|csv)$/i.test(it.name)) { const ls = fs.readFileSync(p, 'utf8').split('\n'); ls.forEach((l, i) => { if (l.toLowerCase().includes(alvo) && hits.length < 200) hits.push(`${path.relative(RAIZ, p)}:${i + 1}: ${l.trim().slice(0, 200)}`); }); } } };
      anda(base); return hits.join('\n') || '(nada encontrado)';
    },
  },
  escrever_arquivo: {
    ativa: FERR.has('Write') || FERR.has('Edit'),
    desc: 'Escreve texto. Só é permitido: acrescentar ao arquivo de execução e a pendencias.md, ou criar arquivo NOVO em raw/. Nunca sobrescreve.',
    params: { caminho: { type: 'string' }, conteudo: { type: 'string' } },
    run: ({ caminho, conteudo }) => {
      const abs = resolver(caminho); const modo = podeEscrever(abs);
      if (!modo) throw new Error('escrita não permitida em ' + caminho);
      if (modo === 'nao-existente-apenas') throw new Error('arquivo já existe; em raw/ só se cria arquivo novo: ' + caminho);
      fs.mkdirSync(path.dirname(abs), { recursive: true });
      if (modo === 'criar') fs.writeFileSync(abs, String(conteudo), { flag: 'wx' }); else fs.appendFileSync(abs, '\n' + String(conteudo) + '\n');
      return `ok (${modo}): ${path.relative(RAIZ, abs)}`;
    },
  },
  executar: {
    ativa: FERR.has('Bash') && PODE.length > 0,
    desc: 'Executa um comando de shell. Só são aceitos comandos que começam com: ' + PODE.join(' | '),
    params: { comando: { type: 'string' } },
    run: ({ comando }) => {
      const c = String(comando || '').trim();
      if (!PODE.some((p) => c === p || c.startsWith(p + ' '))) throw new Error('comando não permitido: ' + c);
      if (/[;&|`$><]/.test(c.replace(/'[^']*'|"[^"]*"/g, ''))) throw new Error('encadeamento/redirecionamento não permitido');
      try { return cortar(execFileSync('bash', ['-lc', c], { cwd: RAIZ, timeout: 120000, maxBuffer: 4e6, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] })); }
      catch (e) { return cortar(`[código ${e.status}] ${e.stdout || ''}\n${e.stderr || e.message}`); }
    },
  },
};
const tools = Object.entries(FERRAMENTAS).filter(([, f]) => f.ativa).map(([nome, f]) => ({
  type: 'function', function: { name: nome, description: f.desc, parameters: { type: 'object', properties: f.params, required: Object.keys(f.params) } },
}));

async function chat(messages) {
  const r = await fetch(URL_OLLAMA + '/api/chat', {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ model: MODELO, messages, tools, stream: false, options: { temperature: 0.2, num_ctx: 16384 } }),
  });
  if (!r.ok) throw new Error(`Ollama ${r.status}: ${(await r.text()).slice(0, 300)}`);
  return (await r.json()).message || {};
}

(async () => {
  const messages = [
    { role: 'system', content: `Você é um agente de um segundo cérebro em ${RAIZ}. Use as ferramentas para ler os arquivos indicados antes de agir. Responda em português. Caminhos são relativos à raiz do cérebro.` },
    { role: 'user', content: PROMPT },
  ];
  let turnos = 0, final = '', erro = false;
  try {
    for (; turnos < MAX_TURNOS; turnos++) {
      const m = await chat(messages);
      messages.push(m);
      if (m.tool_calls && m.tool_calls.length) {
        for (const tc of m.tool_calls) {
          const nome = tc.function && tc.function.name; const f = FERRAMENTAS[nome];
          let args = tc.function && tc.function.arguments; if (typeof args === 'string') { try { args = JSON.parse(args); } catch { args = {}; } }
          let out;
          try { if (!f || !f.ativa) throw new Error('ferramenta indisponível: ' + nome); out = f.run(args || {}); }
          catch (e) { out = 'ERRO: ' + e.message; }
          process.stderr.write(`[ferramenta] ${nome} ${JSON.stringify(args).slice(0, 200)} → ${String(out).slice(0, 120).replace(/\n/g, ' ')}\n`);
          messages.push({ role: 'tool', tool_name: nome, content: String(out) });
        }
        continue;
      }
      final = m.content || ''; break;
    }
    if (!final) { final = '(sem resposta final: limite de turnos atingido)'; erro = true; }
  } catch (e) { final = 'ERRO do motor Ollama: ' + e.message; erro = true; }
  process.stdout.write(JSON.stringify({ type: 'result', subtype: erro ? 'error' : 'success', is_error: erro, result: final, total_cost_usd: 0, num_turns: turnos + 1, duration_ms: Date.now() - inicio, modelo: MODELO }) + '\n');
  process.exit(erro ? 1 : 0);
})();
