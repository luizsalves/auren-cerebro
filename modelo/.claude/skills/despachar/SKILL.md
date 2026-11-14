---
name: despachar
description: Roda o orquestrador agora — lê raw/ novo e pendências e despacha os agentes que precisam rodar. Use quando o usuário pedir /despachar ou "vê se algum agente precisa rodar".
---

# Despachar

1. `bash .claude/scripts/rodar-agente.sh orquestrador "despacho pedido pelo usuário agora" --gatilho=manual`.
2. Leia o arquivo de execução que o script imprime e responda em até 6 linhas: o que foi lido, quem foi despachado e por quê, e o resultado de cada despacho (estão em `execucoes/` de cada agente; o estado está em `node .claude/scripts/agentes-lib.js tabela`).
