#!/usr/bin/env bash
# SessionStart: injeta o foco atual e o último diário como contexto.
cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}" || exit 0

echo "Hoje: $(date +%Y-%m-%d) ($(date +%A))"

ultimo=$(ls -1 diario/[0-9]*.md 2>/dev/null | sort | tail -n 1)
if [ -n "$ultimo" ]; then
  echo
  echo "=== Último diário: $ultimo ==="
  head -n 40 "$ultimo"
fi

novos=$(find raw -name '*.md' -newer .claude/ultima-compilacao 2>/dev/null | wc -l)
[ -f .claude/ultima-compilacao ] || novos=$(find raw -name '*.md' 2>/dev/null | wc -l)
if [ "$novos" -gt 0 ]; then
  echo
  echo "Há $novos arquivo(s) em raw/ ainda não compilados (rode /compilar quando fizer sentido)."
fi

if [ -f .claude/lint.md ]; then
  echo
  echo "=== Último lint ==="
  head -n 15 .claude/lint.md
fi
exit 0
