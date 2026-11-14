#!/usr/bin/env bash
# Gera /etc/cron.d/cerebro-agentes a partir do campo `horario:` de cada agentes/*/agente.md com status ativo.
# Roda no instalador e a cada 30 min (cron), então basta editar o agente.md para mudar o horário.
# Uso: agendar-agentes.sh [--mostrar]
set -u
cd "$(dirname "$0")/../.." || exit 1
CEREBRO="$(pwd)"
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
ARQ=/etc/cron.d/cerebro-agentes
LINHAS=$(node "$CEREBRO/.claude/scripts/agentes-lib.js" cron)
CLAUDE_BIN=$(command -v claude || echo /root/.local/bin/claude)
NOVO=$(cat <<EOF
# Agentes do segundo cérebro — gerado por agendar-agentes.sh a partir de agentes/*/agente.md (horario:). Não edite à mão.
SHELL=/bin/bash
PATH=$(dirname "$CLAUDE_BIN"):/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOME=$HOME
*/30 * * * *  root  bash $CEREBRO/.claude/scripts/agendar-agentes.sh >/dev/null 2>&1
$LINHAS
EOF
)
if [ "${1:-}" = "--mostrar" ]; then echo "$NOVO"; exit 0; fi
if [ "$(id -u)" -ne 0 ]; then echo "precisa de root para escrever $ARQ (rode com sudo, ou --mostrar para ver)"; exit 1; fi
if [ ! -f "$ARQ" ] || [ "$(cat "$ARQ")" != "$NOVO" ]; then
  printf '%s\n' "$NOVO" > "$ARQ" && chmod 644 "$ARQ" && echo "$ARQ atualizado ($(printf '%s\n' "$LINHAS" | grep -c . ) agente(s) agendado(s))"
fi
