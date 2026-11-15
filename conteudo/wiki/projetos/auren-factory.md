---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-auren-factory]]
---

# AUREN Factory

**AUREN Factory**: fábrica de software do AUREN Intelligence Ecosystem. Recebe um pedido, planeja, constrói, testa e entrega sistemas com agentes de IA controlados (Claude Code e Codex, isolados em Docker), com aprovação humana, orçamento e evidências. CLI Python (`auren`), PostgreSQL, Verifier independente.

## Como funciona
Pedido → spec aprovada por hash → tarefas → agente implementa em container isolado → Verifier roda os gates (build, lint, unit, integração, golden, e2e, secret-scan) → PR → revisão → preview → promoção/rollback. Orçamento com tetos (30/3/3) e aprovação do dono pelo Telegram. Claude e Codex se revezam quando um atinge limite de uso.

## Estado (nov/2026)
60 commits desde 29/10/2026, 17 PRs. F0, F1, F2 e F3 validados na VPS com evidências em `docs/validacoes/`. Operação contínua (release instalada, supervisão por cron, backup diário, restore mensal) implementada e testada, **ainda não ativada**. Em 08/11 entrou a stack de dados (PostGIS + S3) ao lado da stack .NET. Backup externo em `D:\Projetos\auren-factory`.

## Documentos
`docs/ESPECIFICACAO.md` (v1.2, arquitetura congelada; mudanças só por ADR em `docs/decisoes/`), `ARQUITETURA.md`, `OPERACAO.md`, `STATUS.md`, `RETOMADA-20261101.md`.

## Relacionados
Gera projetos a partir de [[auren-template-stack]] e [[auren-template-geo]] · validações em [[auren-factory-validacoes]] · construiu [[app-pedido-11]] · pedido pausado do [[geo-planning]] · parte do [[auren-ecossistema]]
