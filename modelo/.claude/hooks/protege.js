#!/usr/bin/env node
// PreToolUse: raw/ é append-only. Pode criar arquivo novo, nunca editar um existente.
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

  if (rel.startsWith('raw/')) {
    const existe = fs.existsSync(abs);
    if (ferramenta === 'Write' && !existe) process.exit(0); // criar arquivo novo é permitido
    console.error(`Bloqueado: raw/ é só de entrada (append-only). Não edite "${rel}". ` +
      'Crie um arquivo novo em raw/ ou atualize a wiki citando esta fonte.');
    process.exit(2);
  }
  process.exit(0);
});
