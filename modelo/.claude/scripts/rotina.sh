#!/usr/bin/env bash
# Rotinas agendadas (cron). Uso: rotina.sh compilar | revisao | lint
set -u
cd "$(dirname "$0")/../.." || exit 1
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
LOG=".claude/rotina.log"
TAREFA="${1:-compilar}"

exec 9>"/tmp/cerebro-rotina.lock"
flock -n 9 || { echo "$(date -Is) $TAREFA: outra rotina rodando, pulei" >> "$LOG"; exit 0; }

FERRAMENTAS='Read,Write,Edit,Glob,Grep,Bash(git log:*),Bash(git status:*),Bash(find:*),Bash(ls:*),Bash(date:*),Bash(node .claude/scripts/lint.js:*)'

rodar() {
  local modelo="$1"; shift
  if ! command -v claude >/dev/null 2>&1; then echo "$(date -Is) claude não encontrado" >> "$LOG"; return 1; fi
  claude -p "$*" --model "$modelo" --allowedTools "$FERRAMENTAS" --permission-mode acceptEdits >> "$LOG" 2>&1
}

echo "$(date -Is) início $TAREFA" >> "$LOG"
case "$TAREFA" in
  compilar) rodar haiku "Execute a skill compilar deste cérebro. Seja breve." ;;
  revisao)  rodar sonnet "Execute a skill revisao-semanal deste cérebro. Seja breve." ;;
  lint)     node .claude/scripts/lint.js >> "$LOG" 2>&1 ;;
  *) echo "uso: rotina.sh compilar|revisao|lint"; exit 1 ;;
esac

bash .claude/scripts/guarda-raw.sh >> "$LOG" 2>&1
if [ -n "$(git status --porcelain)" ]; then
  git add -A && git commit -q -m "rotina $TAREFA $(date '+%Y-%m-%d %H:%M')"
fi
echo "$(date -Is) fim $TAREFA" >> "$LOG"
