---
name: agentes
description: Lista os agentes do segundo cérebro com papel, status, modelo, horário, última rodada, veredito, pendências e custo. Use quando o usuário pedir /agentes, "como estão os agentes" ou "quais agentes eu tenho".
---

# Agentes

1. Rode `node .claude/scripts/agentes-lib.js tabela` e mostre a tabela como veio.
2. Para cada agente com pendências abertas ou última rodada `falhou`/`reprovado`/`revisar`/`bloqueado-orcamento`, acrescente uma linha: o que está pendente (leia `agentes/<nome>/pendencias.md`, só as `[ ]`).
3. Termine com: "Para abrir um: /agente <nome>. Para criar: /novo-agente <nome>."
4. Não rode nenhum agente aqui; só liste.
