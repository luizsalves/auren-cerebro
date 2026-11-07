---
name: lint
description: Verifica a saúde do segundo cérebro — links [[ ]] quebrados, páginas da wiki sem fonte, páginas paradas há mais de 30 dias e arquivos fora do índice. Use quando o usuário pedir /lint ou "o cérebro está em ordem?".
---

# Lint

1. Rode `node .claude/scripts/lint.js` (gera `.claude/lint.md`).
2. Leia `.claude/lint.md` e resuma em até 6 linhas.
3. Ofereça corrigir o que for mecânico (índice desatualizado, link com nome errado).
   Só corrija depois que o usuário confirmar.
4. Páginas paradas: não mexa; liste para o usuário decidir (atualizar, pausar ou mover para `_arquivo/`).
