#!/usr/bin/env bash
# Stop: protege raw/ e faz commit do que mudou (histórico + backup).
cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}" || exit 0
bash .claude/scripts/guarda-raw.sh >/dev/null 2>&1
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  git add -A >/dev/null 2>&1
  git commit -q -m "sessão $(date '+%Y-%m-%d %H:%M')" >/dev/null 2>&1
fi
exit 0
