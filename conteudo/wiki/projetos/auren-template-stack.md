---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-auren-template-stack]]
---

# AUREN Template Stack

**AUREN Template Stack**: fundação dos sistemas gerados pela [[auren-factory]] — .NET 10, React/TypeScript, PostgreSQL 17, Identity (login com registro público desligado), migrations, testes com banco real (Testcontainers) e Playwright. Em homologação.

## O que traz
`backend/` (App.Api), `frontend/` (Vite), `database/migrations`, `tests/casos-ouro`, `scripts/check.sh` com os gates (build, lint, unit, integration, golden, e2e, secret-scan), `knowledge/` e `backlog/` para o projeto gerado, `AGENTS.md` por pasta.

## Estado
12 commits (29–30/10/2026), PR 1 integrado. CI valida os modos com e sem Docker socket. Sem deploy: publicação é controlada pela fábrica.

## Relacionados
[[auren-factory]] · [[auren-template-geo]] · cópias geradas: [[auren-factory-validacoes]], [[app-pedido-11]]
