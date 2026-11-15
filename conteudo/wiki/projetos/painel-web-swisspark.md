---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-painel-web-swisspark]]
---

# Painel Web SwissPark

Sistema web de **fechamento e conciliação contábil mensal** feito para o grupo **Swiss Park** (coligadas, filiais e SCPs), comercializado pela Latec como *BI Planning*. Lê a contabilidade do TOTVS RM (SQL Server, só leitura), controla o fechamento conta a conta (preparar → pré-conferir → conferir → fechar, com quem e quando), mostra balancete/balanço/DFC/indicadores e tem a IA "CFO Tati".

## Stack
.NET 10 · React + TypeScript + Vite · PostgreSQL · Docker Compose (nginx + api) · deploy automático da `main` na VPS (`.deploy/auto-deploy.sh`). 263 arquivos C#, 31 SQL, 29 documentos em `docs/` (autenticação, Docker, regra de integração contábil, processo de conciliação no TOTVS RM, prompts da Tati, roadmap).

## Histórico
Começou em 10/09/2026 (ideia inicial: API própria sobre Postgres; depois BFF em C# cruzando APIs do ERP). 97 commits e 32 PRs até 09/11/2026. Em 09/11 virou a base do [[suite-planning]], que passa a ser o repositório principal do módulo.

## Relacionados
[[suite-planning]] · [[swiss-park]] · [[painel-conciliacao]] · [[latec-tecnologia]]
