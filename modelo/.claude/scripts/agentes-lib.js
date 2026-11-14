#!/usr/bin/env node
// Utilitários dos agentes (sem dependências). Uso:
//   agentes-lib.js config <agentes/x/agente.md>      → JSON do frontmatter (com padrões)
//   agentes-lib.js listar                            → JSON de todos os agentes + estado
//   agentes-lib.js tabela                            → tabela em texto (para /agentes)
//   agentes-lib.js estado-set <nome> '<json>'        → grava/mescla o estado do agente
//   agentes-lib.js custo-add <usd>                   → soma ao custo de hoje
//   agentes-lib.js custo-hoje                        → custo acumulado de hoje (USD)
//   agentes-lib.js cron                              → linhas de cron dos agentes ativos com horario
//   agentes-lib.js resultado <arquivo-json>          → extrai {result,custo,turnos,duracao,erro} do JSON do claude -p
'use strict';
const fs = require('fs');
const path = require('path');

const CEREBRO = path.resolve(__dirname, '..', '..');
const ESTADO = path.join(CEREBRO, '.claude', 'agentes', 'estado.json');
const PADROES = {
  nome: '', papel: 'especialista', status: 'rascunho', modelo: 'sonnet', horario: '', codigo: '',
  ferramentas: ['Read', 'Glob', 'Grep', 'Write', 'Edit', 'Bash'], pode_executar: [],
  efeitos_externos: 'nenhum', arbitro: true, max_tentativas: 2, max_turnos: 30, orcamento_rodada_usd: 0.5,
};

function semComentario(v) {
  v = v.trim();
  if (v.startsWith('"')) { const m = v.match(/^"((?:[^"\\]|\\.)*)"/); return m ? m[1] : v; }
  if (v.startsWith("'")) { const m = v.match(/^'([^']*)'/); return m ? m[1] : v; }
  return v.replace(/\s+#.*$/, '').trim();
}
function valor(v) {
  v = semComentario(v);
  if (v === '') return '';
  if (v === 'true') return true;
  if (v === 'false') return false;
  if (/^-?\d+(\.\d+)?$/.test(v)) return Number(v);
  if (v.startsWith('[')) {
    const dentro = v.replace(/^\[|\]$/g, '').trim();
    if (!dentro) return [];
    // separa por vírgula fora de aspas
    const itens = []; let atual = '', aspas = null;
    for (const ch of dentro) {
      if (aspas) { if (ch === aspas) aspas = null; else atual += ch; continue; }
      if (ch === '"' || ch === "'") { aspas = ch; continue; }
      if (ch === ',') { itens.push(atual.trim()); atual = ''; continue; }
      atual += ch;
    }
    if (atual.trim()) itens.push(atual.trim());
    return itens;
  }
  return v;
}

function config(arq) {
  const txt = fs.readFileSync(arq, 'utf8');
  const m = txt.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  const fm = {};
  if (m) {
    const linhas = m[1].split(/\r?\n/);
    let chaveLista = null;
    for (const l of linhas) {
      if (/^\s*-\s+/.test(l) && chaveLista) { fm[chaveLista].push(valor(l.replace(/^\s*-\s+/, ''))); continue; }
      const kv = l.match(/^([A-Za-z0-9_]+):\s*(.*)$/);
      if (!kv) continue;
      const [, k, v] = kv;
      if (v.trim() === '' || v.trim().startsWith('#')) { fm[k] = []; chaveLista = k; continue; }
      fm[k] = valor(v); chaveLista = null;
    }
  }
  const dir = path.dirname(arq);
  const cfg = { ...PADROES, ...fm };
  if (!Array.isArray(cfg.ferramentas)) cfg.ferramentas = String(cfg.ferramentas).split(',').map((s) => s.trim()).filter(Boolean);
  if (!Array.isArray(cfg.pode_executar)) cfg.pode_executar = cfg.pode_executar ? [String(cfg.pode_executar)] : [];
  if (!cfg.nome) cfg.nome = path.basename(dir);
  cfg.dir = path.relative(CEREBRO, dir).split(path.sep).join('/');
  // seções do corpo (para o painel e o /agente)
  const corpo = m ? txt.slice(m[0].length) : txt;
  const missao = (corpo.match(/##\s*Miss[aã]o\s*\n([\s\S]*?)(?=\n##\s|$)/) || [])[1];
  cfg.missao = (missao || '').replace(/<!--[\s\S]*?-->/g, '').trim().split('\n')[0] || '';
  return cfg;
}

function lerEstado() {
  try { return JSON.parse(fs.readFileSync(ESTADO, 'utf8')); } catch { return { agentes: {}, custos: {} }; }
}
function gravarEstado(e) {
  fs.mkdirSync(path.dirname(ESTADO), { recursive: true });
  fs.writeFileSync(ESTADO, JSON.stringify(e, null, 2) + '\n');
}
function hoje() { const d = new Date(); const p = (n) => String(n).padStart(2, '0'); return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`; }

function listar() {
  const base = path.join(CEREBRO, 'agentes');
  let pastas = [];
  try { pastas = fs.readdirSync(base, { withFileTypes: true }).filter((d) => d.isDirectory() && !d.name.startsWith('_') && !d.name.startsWith('.')).map((d) => d.name); } catch {}
  const estado = lerEstado();
  const out = [];
  for (const nome of pastas.sort()) {
    const arq = path.join(base, nome, 'agente.md');
    if (!fs.existsSync(arq)) continue;
    let cfg; try { cfg = config(arq); } catch (e) { cfg = { ...PADROES, nome, erro: e.message }; }
    let pend = 0;
    try { pend = (fs.readFileSync(path.join(base, nome, 'pendencias.md'), 'utf8').match(/^- \[ \] \S/gm) || []).length; } catch {}
    out.push({ ...cfg, pendencias_abertas: pend, estado: estado.agentes[nome] || null });
  }
  return out;
}

function tabela() {
  const lista = listar();
  if (!lista.length) return 'Nenhum agente em agentes/. Crie um com /novo-agente <nome>.';
  const linhas = [['agente', 'papel', 'status', 'modelo', 'horário', 'última rodada', 'resultado', 'pend.', 'custo']];
  for (const a of lista) {
    const e = a.estado || {};
    linhas.push([a.nome, a.papel, a.status, a.modelo, a.horario || '—', e.fim ? new Date(e.fim).toLocaleString('pt-BR', { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' }) : 'nunca', e.status ? (e.veredito && e.veredito !== e.status ? `${e.status} (${e.veredito})` : e.status) : '—', String(a.pendencias_abertas), e.custo_usd != null ? `$${Number(e.custo_usd).toFixed(2)}` : '—']);
  }
  const larg = linhas[0].map((_, i) => Math.max(...linhas.map((l) => String(l[i]).length)));
  const custos = lerEstado().custos || {};
  const rod = linhas.map((l) => l.map((c, i) => String(c).padEnd(larg[i])).join('  ')).join('\n');
  return rod + `\n\nCusto hoje: $${Number(custos[hoje()] || 0).toFixed(2)}`;
}

function cron() {
  const linhas = [];
  for (const a of listar()) {
    if (a.status !== 'ativo' || !a.horario) continue;
    if (!/^(\S+\s+){4}\S+$/.test(a.horario.trim())) { linhas.push(`# ${a.nome}: horario inválido "${a.horario}"`); continue; }
    linhas.push(`${a.horario.trim()}  root  bash ${CEREBRO}/.claude/scripts/rodar-agente.sh ${a.nome} >> ${CEREBRO}/.claude/agentes/cron.log 2>&1`);
  }
  return linhas.join('\n');
}

function resultado(arq) {
  let j = null;
  try { j = JSON.parse(fs.readFileSync(arq, 'utf8')); } catch {}
  if (Array.isArray(j)) j = j.find((x) => x && x.type === 'result') || j[j.length - 1];
  if (!j || typeof j !== 'object') {
    let txt = ''; try { txt = fs.readFileSync(arq, 'utf8'); } catch {}
    return { result: txt.trim(), custo: 0, turnos: 0, duracao: 0, erro: !txt.trim() };
  }
  return {
    result: typeof j.result === 'string' ? j.result : JSON.stringify(j.result || ''),
    custo: Number(j.total_cost_usd || j.cost_usd || 0),
    turnos: Number(j.num_turns || 0),
    duracao: Number(j.duration_ms || 0),
    erro: !!j.is_error || (j.subtype && j.subtype !== 'success' && j.subtype !== undefined && !/success/.test(j.subtype)),
    subtipo: j.subtype || '',
  };
}

const [cmd, ...args] = process.argv.slice(2);
switch (cmd) {
  case 'config': console.log(JSON.stringify(config(args[0]))); break;
  case 'listar': console.log(JSON.stringify(listar(), null, 2)); break;
  case 'tabela': console.log(tabela()); break;
  case 'estado-set': {
    const e = lerEstado(); e.agentes = e.agentes || {}; e.custos = e.custos || {};
    e.agentes[args[0]] = { ...(e.agentes[args[0]] || {}), ...JSON.parse(args[1] || '{}') };
    gravarEstado(e); break;
  }
  case 'custo-add': {
    const e = lerEstado(); e.custos = e.custos || {};
    e.custos[hoje()] = Number(((e.custos[hoje()] || 0) + Number(args[0] || 0)).toFixed(4));
    // mantém 60 dias
    for (const k of Object.keys(e.custos)) if (k < new Date(Date.now() - 60 * 86400000).toISOString().slice(0, 10)) delete e.custos[k];
    gravarEstado(e); console.log(e.custos[hoje()]); break;
  }
  case 'custo-hoje': console.log(Number((lerEstado().custos || {})[hoje()] || 0)); break;
  case 'cron': console.log(cron()); break;
  case 'resultado': console.log(JSON.stringify(resultado(args[0]))); break;
  default: console.error('uso: agentes-lib.js config|listar|tabela|estado-set|custo-add|custo-hoje|cron|resultado'); process.exit(1);
}
