---
tipo: projeto
status: pausado
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-crm-whatsapp]], [[2026-11-15-0100-github-crm-whatsapp-codex]]
---

# WhatsCRM (WhatsApp + CRM)

**WhatsCRM**: SaaS multiempresa para atendimento via WhatsApp, CRM (funil), agenda e pós-venda, com um núcleo compartilhado entre verticais (vendas, clínicas, serviços, estética). Dois repositórios de setembro de 2026:

| Repositório | O que tem |
|---|---|
| `CRM-WhatsApp` (branch `claude/...`) | fundação (auth multiempresa, .NET 10, React, Docker) + integração WhatsApp: contatos, conexão da conta, webhook e conversas em tempo real (SignalR). Compose `whatsclaude`, porta 8090 |
| `CRM-WhatsApp-Codex` | só a fundação da SPEC-001 (auth e multiempresa) + `docs/STATUS-E-ROADMAP.md` com as SPEC-001 a 012 |

## Stack
C# .NET 10 / ASP.NET Core / EF Core / PostgreSQL / JWT / SignalR · React + TypeScript + Vite + PWA · Docker Compose + Nginx · desenvolvimento guiado por specs (`docs/specs/`). Regras críticas em `AGENTS.md`: isolamento multiempresa, status comercial separado da etapa do Kanban, minimização de dados de saúde.

## Estado
Sem commits desde 08/09/2026. Pasta na VPS: `/opt/saas/WhatsApp`.

## Relacionados
[[zum-web-studio]]
