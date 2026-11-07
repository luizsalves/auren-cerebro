---
name: revisao-semanal
description: Faz a revisão semanal do segundo cérebro — o que aconteceu, o que está parado, decisões pendentes e prioridades. Use quando o usuário pedir /revisao-semanal ou "como foi a semana".
---

# Revisão semanal

1. Leia os `diario/` dos últimos 7 dias, `agora.md` e `wiki/decisoes.md`.
2. Rode `git log --since="7 days ago" --name-only --pretty=format:` para ver o que mudou.
3. Rode `node .claude/scripts/lint.js` e leia `.claude/lint.md`.
4. Escreva `diario/AAAA-Www-revisao.md` (ex.: `2026-W45-revisao.md`):
   ```
   # Revisão da semana AAAA-Www
   ## Feito
   ## Decisões
   ## Parado (sem atualização há +30 dias)
   ## Pendências e "esperando"
   ## Sugestão de prioridades para a próxima semana
   ```
5. Não altere `agora.md` sozinho: as sugestões ficam na revisão.
6. Responda em até 6 linhas com o essencial.
