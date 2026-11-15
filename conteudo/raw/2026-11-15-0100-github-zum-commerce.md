---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/zum-commerce), leitura automática do repositório
---

# Levantamento do repositório zum-commerce

Repositório: https://github.com/luizsalves/zum-commerce
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-08 Concilia versões locais e ajustes da VPS
2026-11-08 Envia fotos de produtos direto para a Shopify
2026-11-08 Preserva ajustes existentes da VPS
2026-10-23 Merge pull request #1 from luizsalves/fix/publicar-produto-no-canal
2026-10-23 Escolha dos canais de vendas no painel da plataforma
2026-10-23 Estrutura inicial do front do Zum Commerce
primeiro: 2026-10-23 · total(≤80): 6 · branch: main
## arvore
.
AGENTS.md
ARCHITECTURE.md
CLAUDE.md
ESCOPO_DO_PROJETO.md
README.md
firebase.json
firestore.indexes.json
firestore.rules
frontend
frontend/.env.example
frontend/.prettierignore
frontend/.prettierrc
frontend/eslint.config.js
frontend/index.html
frontend/package-lock.json
frontend/package.json
frontend/src
frontend/tsconfig.json
frontend/vite.config.ts
frontend/vitest.config.ts
iniciar-backend.bat
iniciar-frontend.bat
storage.rules
## manifestos
## CLAUDE.md
# CLAUDE.md

As instruções deste projeto estão em AGENTS.md (vale para qualquer IA de código).

@AGENTS.md
## README (README.md)
# Zum Commerce: front-end
Vitrine e painel da plataforma SaaS da Zum Web Studio para lojas Shopify. A API em C# fica no repositório separado **`zum-commerce-api`**.
| Aplicação | Caminho | Stack |
|---|---|---|
| Front-end (este repositório) | `zum-commerce/frontend` | React 19, TypeScript, Vite, Tailwind 4, Firebase (Auth, Firestore), Shopify Storefront API |
| Back-end | `zum-commerce-api/backend` | ASP.NET Core (.NET 10), Firestore, Shopify Admin API |
## Rodar local
Os dois repositórios ficam lado a lado:
```
C:\Projetos\Zum\
 ├─ zum-commerce\        ← este repositório (front)
 └─ zum-commerce-api\    ← API em C#
```
1. Configure o front: copie `frontend/.env.example` para `frontend/.env.local` e preencha com os dados do app Web do Firebase.
2. Configure a API conforme o README do `zum-commerce-api`.
3. Dê dois cliques em **`iniciar-backend.bat`** (API em http://localhost:8080) e em **`iniciar-frontend.bat`** (site em http://localhost:5173).
| Endereço | O quê |
|---|---|
| http://localhost:5173 | Vitrine da loja definida em `VITE_DEFAULT_TENANT` (ou `?loja=id`) |
| http://localhost:5173/admin | Painel (produtos, clientes, taxas, plataforma) |
Em desenvolvimento, o Vite redireciona `/api` para a API local, então não é preciso configurar CORS.
## Scripts (`frontend/`)
| Comando | O quê |
|---|---|
| `npm run dev` | Servidor de desenvolvimento |
| `npm run build` | Checagem de tipos + build de produção em `frontend/dist` |
| `npm run typecheck` | Só a checagem de tipos |
| `npm run lint` | ESLint |
| `npm run format` | Prettier |
| `npm test` | Testes (Vitest) |
## Deploy
```bash
cd frontend && npm run build && cd ..
firebase deploy --only hosting,firestore:rules
```
O `firebase.json` redireciona `/api/**` para o serviço `zum-commerce-api` no Cloud Run (`southamerica-east1`). Assim, front e API ficam no mesmo domínio.
As regras do Firestore (`firestore.rules`) ficam neste repositório porque são publicadas junto com o site. O Storage não é usado: as fotos de produto vão pela API direto para a Shopify.
Mais detalhes: [ARCHITECTURE.md](ARCHITECTURE.md) e [ESCOPO_DO_PROJETO.md](ESCOPO_DO_PROJETO.md). Instruções para IAs de código: [AGENTS.md](AGENTS.md).
Repositórios: [luizsalves/zum-commerce](https://github.com/luizsalves/zum-commerce) (este) e [luizsalves/zum-commerce-api](https://github.com/luizsalves/zum-commerce-api).
## docs
AGENTS.md
ARCHITECTURE.md
CLAUDE.md
ESCOPO_DO_PROJETO.md
## contagem
     38 tsx      21 ts       5 md       5 json       2 rules       2 bat       1 prettierrc       1 prettierignore 

```
