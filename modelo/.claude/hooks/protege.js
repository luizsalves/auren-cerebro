#!/usr/bin/env node
// PreToolUse (Edit|Write|MultiEdit|NotebookEdit):
//  - raw/ é append-only: pode criar arquivo novo, nunca editar um existente.
//  - Durante uma rodada automática de agente (CEREBRO_AGENTE definido), o agente não pode tocar em:
//    identidade/, CLAUDE.md, AGENTS.md, .claude/, agentes/*/{agente,conhecimento,exemplos,avaliacao}.md,
//    nem nas pastas de outros agentes. Só pode: execucoes/ e pendencias.md do próprio agente, raw/ (novo) e wiki/ (se tiver Write).
// Saída 2 bloqueia a ação e devolve a mensagem para o Claude.
const fs = require('fs');
const path = require('path');

let entrada = '';
process.stdin.on('data', (c) => (entrada += c));
process.stdin.on('end', () => {
  let dados;
  try { dados = JSON.parse(entrada); } catch { process.exit(0); }
  const raiz = path.resolve(process.env.CLAUDE_PROJECT_DIR || dados.cwd || process.cwd());
  const ferramenta = dados.tool_name || '';
  const alvo = (dados.tool_input && (dados.tool_input.file_path || dados.tool_input.notebook_path)) || '';
  if (!alvo) process.exit(0);
  const abs = path.resolve(raiz, alvo);
  const rel = path.relative(raiz, abs).split(path.sep).join('/');
  const bloquear = (msg) => { console.error('Bloqueado: ' + msg); process.exit(2); };

  if (rel.startsWith('raw/')) {
    const existe = fs.existsSync(abs);
    if (ferramenta === 'Write' && !existe) process.exit(0); // criar arquivo novo é permitido
    bloquear(`raw/ é só de entrada (append-only). Não edite "${rel}". Crie um arquivo novo em raw/ ou atualize a wiki citando esta fonte.`);
  }

  const agente = process.env.CEREBRO_AGENTE || '';
  if (agente) {
    if (rel.startsWith('..')) bloquear(`agente "${agente}" não escreve fora do cérebro (${rel}).`);
    if (/^(identidade\/|CLAUDE\.md$|AGENTS\.md$|\.claude\/)/.test(rel)) bloquear(`agente "${agente}" não pode editar "${rel}".`);
    const m = rel.match(/^agentes\/([^/]+)\/(.*)$/);
    if (m) {
      const [, dono, resto] = m;
      if (dono !== agente) bloquear(`agente "${agente}" não mexe na pasta de outro agente (${rel}).`);
      if (/^(agente|conhecimento|exemplos|avaliacao|CHANGELOG)\.md$/.test(resto)) bloquear(`"${resto}" só é editado por você. O agente propõe em agentes/${agente}/pendencias.md.`);
      if (resto.startsWith('avaliacoes/')) bloquear(`avaliacoes/ é gravado só pelo /avaliar.`);
      if (resto.startsWith('execucoes/')) {
        const atual = process.env.CEREBRO_EXEC ? path.resolve(raiz, process.env.CEREBRO_EXEC) : '';
        if (atual && abs !== atual) bloquear(`só o arquivo da rodada atual pode ser editado (${path.relative(raiz, atual)}).`);
      }
    }
  }
  process.exit(0);
});
