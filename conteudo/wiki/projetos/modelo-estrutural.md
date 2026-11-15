---
tipo: projeto
status: pausado
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-modelo-estrutural]]
---

# Modelo estrutural (Portal Power BI Embedded v2)

**Portal Power BI Embedded v2**: estrutura inicial, sem código, em duas aplicações — `frontend/` (React, Vite, TypeScript, Atomic Design) e `backend/` (C#, ASP.NET Core Web API, .NET 10, arquitetura em camadas com projetos independentes). Regra: o frontend nunca contém segredos (Client Secret, JWT, banco, SMTP).

Um commit (10/09/2026). Serviu de modelo de organização de pastas para o [[painel-web-swisspark]] (citado em `docs/contexto-projeto-swisspark.md` como "projeto modelo usado por um dev sênior"). Na VPS existe a pasta [[modelo-projeto]].

## Relacionados
[[painel-web-swisspark]] · [[modelo-projeto]] · [[auren-ecossistema]]
