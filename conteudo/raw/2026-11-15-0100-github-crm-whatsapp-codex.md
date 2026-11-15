---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/CRM-WhatsApp-Codex), leitura automática do repositório
---

# Levantamento do repositório CRM-WhatsApp-Codex

Repositório: https://github.com/luizsalves/CRM-WhatsApp-Codex
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-09-07 docs: add project status and spec roadmap
2026-09-07 feat: initialize WhatsCRM foundation
primeiro: 2026-09-07 · total(≤80): 2 · branch: main
## arvore
.
.dockerignore
.editorconfig
.env.example
AGENTS.md
ARCHITECTURE.md
NuGet.Config
README.md
WhatsCrm.slnx
backend
backend/WhatsCrm.Api
backend/WhatsCrm.Api.Tests
docker-compose.yml
docs
docs/STATUS-E-ROADMAP.md
docs/specs
dotnet-tools.json
frontend
frontend/Dockerfile
frontend/eslint.config.js
frontend/index.html
frontend/nginx.conf
frontend/package-lock.json
frontend/package.json
frontend/public
frontend/src
frontend/tsconfig.app.json
frontend/tsconfig.json
frontend/tsconfig.node.json
frontend/vite.config.ts
global.json
## manifestos
docker-compose.yml
## README (README.md)
# WhatsCRM
Fundação de um SaaS multiempresa para relacionamento, atendimento via WhatsApp, CRM, agenda e pós-venda. O produto é construído de forma incremental, guiado por especificações.
## Estado atual
A entrega atual implementa somente a fundação da [`SPEC-001 — Autenticação e Multiempresa`](docs/specs/SPEC-001-auth-multitenant.md):
- cadastro seguro da primeira empresa e do primeiro administrador;
- login com JWT e contexto de empresa obtido exclusivamente do token;
- roles iniciais e rota de identidade autenticada;
- filtros e guardas de isolamento multiempresa no EF Core;
- PostgreSQL com migration inicial;
- frontend React responsivo com login, primeiro acesso, layout e rotas protegidas;
- Docker Compose com PostgreSQL, API e Nginx;
- testes automatizados da política de senha e do isolamento entre empresas.
WhatsApp, contatos, CRM, agenda, pós-venda e os demais módulos ainda não fazem parte desta entrega. Cada módulo terá sua própria spec.
Consulte o documento consolidado [`docs/STATUS-E-ROADMAP.md`](docs/STATUS-E-ROADMAP.md) para ver tudo o que já foi criado, as limitações atuais, as pendências e o roadmap completo das SPEC-001 a SPEC-012.
## Stack
- .NET 10, ASP.NET Core, EF Core e Npgsql;
- PostgreSQL 17;
- React, TypeScript, Vite, React Router e Axios;
- Docker Compose e Nginx;
- xUnit.
## Subir com Docker
Pré-requisitos: Docker Desktop com Docker Compose.
```powershell
Copy-Item .env.example .env
```
Edite `.env` e substitua os dois valores por secrets fortes. Em seguida:
```powershell
docker compose up -d --build
```
Endereços:
- aplicação: <http://localhost:8080>
- primeiro acesso: <http://localhost:8080/primeiro-acesso>
- Swagger: <http://localhost:8081/swagger>
- health check: <http://localhost:8081/health>
O volume `postgres_data` mantém os dados. Não remova o volume em ambientes com dados úteis.
## Desenvolvimento local
### Backend
Pré-requisitos: .NET SDK 10 e uma instância PostgreSQL.
```powershell
$env:ConnectionStrings__Postgres='Host=localhost;Port=5432;Database=whatscrm;Username=whatscrm;Password=SUA_SENHA'
$env:Jwt__Secret='UMA_CHAVE_ALEATORIA_COM_32_OU_MAIS_CARACTERES'
dotnet tool restore
dotnet tool run dotnet-ef database update --project backend/WhatsCrm.Api --startup-project backend/WhatsCrm.Api
dotnet run --project backend/WhatsCrm.Api
```
Nenhum secret real deve ser gravado no repositório.
### Frontend
```powershell
Set-Location frontend
npm install
npm run dev
```
Em desenvolvimento, o Vite encaminha `/api` para `http://localhost:5080`.
## Validação
```powershell
dotnet restore WhatsCrm.slnx --configfile NuGet.Config
dotnet build WhatsCrm.slnx --no-restore
dotnet test WhatsCrm.slnx --no-build
Set-Location frontend
npm ci
npm run lint
npm run build
```
Para validar a infraestrutura:
```powershell
docker compose config
```
## Estrutura
```text
backend/
## docs
AGENTS.md
ARCHITECTURE.md

docs:
STATUS-E-ROADMAP.md
specs
## contagem
     31 cs      12 tsx      10 json       6 md       5 ts       2 csproj       1 yml       1 webmanifest 

```
