---
name: agente
description: Abre um agente do cérebro — como está, última rodada, veredito, pendências — e oferece ações (rodar, aceitar/rejeitar pendências, avaliar, pausar). Use quando o usuário pedir /agente <nome>, "abre o agente X" ou "o que o agente X fez".
---

# Agente

Argumento: o nome da pasta em `agentes/`. Sem argumento, rode `/agentes` e pergunte qual.

## 1. Situação (sempre)
1. Leia `agentes/<nome>/agente.md` (frontmatter + Missão + Limites), `conhecimento.md`, `pendencias.md` e as 3 últimas em `execucoes/` (ordem do nome).
2. Rode `node .claude/scripts/agentes-lib.js listar` e pegue o estado deste agente (última rodada, veredito, custo, avaliação).
3. Resuma em até 10 linhas: missão em 1 linha · status/modelo/horário · última rodada (quando, veredito, custo) · o que ficou "Preparado para aprovação" · pendências abertas numeradas · última nota de avaliação.

## 2. Ações (só quando o usuário pedir)
- **rodar** (`/agente x rodar [tarefa]`): `bash .claude/scripts/rodar-agente.sh <nome> "<tarefa>" --gatilho=manual`; depois leia o arquivo de execução que o script imprime e resuma.
- **aceitar pendência N**: copie o texto para `conhecimento.md` na seção certa como `- AAAA-MM-DD — <regra> (fonte: [[run_id]])`; marque `[x]` em `pendencias.md`; uma linha em `CHANGELOG.md`.
- **rejeitar pendência N**: marque `[x]` e acrescente ` — rejeitado: <motivo>`.
- **aprovar o que ficou preparado**: você NÃO executa o efeito externo; mostre o texto preparado e diga como executar (ou qual comando/arquivo em `/opt`). Registre a aprovação no `diario/`.
- **avaliar**: `bash .claude/scripts/avaliar-agente.sh <nome>` e resuma a média e os casos com nota < 7.
- **pausar / ativar**: troque `status:` no frontmatter de `agente.md` e rode `sudo bash .claude/scripts/agendar-agentes.sh` (se não for root, avise que o cron atualiza em até 30 min).
- **editar missão/limites/conhecimento**: edite o arquivo pedido, atualize `atualizado:` e `CHANGELOG.md`.

## Regras
- Nunca edite `execucoes/` nem `avaliacoes/`.
- Efeito externo (mensagem, e-mail, ação em sistema) é sempre do usuário. Você prepara e mostra.
