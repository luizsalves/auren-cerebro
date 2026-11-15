---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/modelo-estrutural), leitura automática do repositório
---

# Levantamento do repositório modelo-estrutural

Repositório: https://github.com/luizsalves/modelo-estrutural
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-09-10 Initial commit
primeiro: 2026-09-10 · total(≤80): 1 · branch: main
## arvore
.
.editorconfig
ARCHITECTURE.md
README.md
backend
backend/.env.example
backend/.gitignore
backend/Directory.Build.props
backend/Directory.Packages.props
backend/NuGet.Config
backend/PortalPowerBI.Backend.slnx
backend/README.md
backend/global.json
backend/src
frontend
frontend/.env.example
frontend/.gitignore
frontend/.npmrc
frontend/.nvmrc
frontend/.prettierignore
frontend/.prettierrc.json
frontend/README.md
frontend/package.json
frontend/public
frontend/src
frontend/tsconfig.app.json
frontend/tsconfig.json
frontend/tsconfig.node.json
frontend/vite.config.ts
frontend/vitest.config.ts
## manifestos
## README (README.md)
# Portal Power BI Embedded v2
Estrutura inicial sem código, separada em duas aplicações:
```text
portal-powerbi-embedded-v2/
├── frontend/   React Web, Vite e TypeScript
└── backend/    C#, ASP.NET Core Web API e .NET 10
```
O frontend segue organização por Atomic Design. O backend segue uma arquitetura em camadas com projetos C# independentes dentro da solução.
## Segurança
O frontend nunca pode conter Client Secret, segredo JWT, senha de banco ou senha SMTP. Esses valores pertencem exclusivamente ao backend.
## Estado atual
Existem somente pastas e arquivos de configuração. Ainda não existem componentes React, endpoints, classes C# ou regras de negócio.
## docs
ARCHITECTURE.md
## contagem
     52 gitkeep       9 json       6 csproj       4 md       3 gitignore       2 ts       2 props       2 example 

```
