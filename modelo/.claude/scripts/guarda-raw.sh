#!/usr/bin/env bash
# Se algum arquivo já versionado em raw/ foi alterado ou apagado, restaura do git.
cd "$(dirname "$0")/../.." || exit 0
git rev-parse --verify HEAD >/dev/null 2>&1 || exit 0
alterados=$(git diff --name-only --diff-filter=MD HEAD -- raw/ 2>/dev/null)
if [ -n "$alterados" ]; then
  echo "$alterados" | while read -r f; do
    git checkout HEAD -- "$f" 2>/dev/null && echo "restaurado: $f"
  done
fi
exit 0
