---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/painel_conciliacao), leitura automática do repositório
---

# Levantamento do repositório painel_conciliacao

Repositório: https://github.com/luizsalves/painel_conciliacao
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-08-09 Update sidebar branding
2026-08-09 Initial commit
primeiro: 2026-08-09 · total(≤80): 2 · branch: main
## arvore
.
README.md
index.html
package-lock.json
package.json
src
src/App.tsx
src/assets
src/components
src/contexts
src/data
src/layouts
src/main.tsx
src/pages
src/routes
src/services
src/styles
src/types
src/vite-env.d.ts
tsconfig.json
tsconfig.node.json
vite.config.ts
## manifestos
package: swiss-park-conciliacao 0.1.0 
scripts: dev build preview lint
deps: lucide-react react react-dom react-router-dom
dev: @types/react @types/react-dom @vitejs/plugin-react typescript vite
## README (README.md)
# Swiss Park — Sistema de Conciliação Contábil
Frontend funcional em **React + TypeScript + Vite**, contendo, nesta etapa:
1. **Login** (`/login`)
2. **Painel Gerencial / Dashboard** (`/dashboard`)
## Como rodar
```bash
npm install
npm run dev
```
A aplicação abre em `http://localhost:5173`.
Build de produção:
```bash
npm run build
npm run preview
```
## Login (mockado)
- Qualquer e-mail válido (`nome@dominio.com`) + senha com 4+ caracteres → login liberado.
- Usuário mock: **Karime** — Gerente — `karime@swisspark.com.br`.
- Autenticação persiste em `localStorage`. Logout limpa a sessão e volta para `/login`.
- "Esqueceu sua senha?" abre um modal com fluxo mockado de recuperação (e-mail/SMS).
## Estrutura
```
src/
  components/     Componentes reutilizáveis (Button, Input, Select, Modal, Table, KpiCard, etc.)
  components/charts/  Gráficos (barras empilhadas e donut) em SVG puro, sem dependências extras
  contexts/       AuthContext (autenticação mockada)
  data/           Dados mockados (usuário, filtros, métricas do dashboard)
  layouts/        AppLayout (sidebar + área de conteúdo)
  pages/          LoginPage, DashboardPage
  routes/         Definição de rotas e ProtectedRoute
  services/       authService (login/recuperação de senha mockados)
  styles/         CSS global + tokens da identidade Swiss Park
  types/          Interfaces TypeScript do domínio
```
## Identidade visual
Cores, tipografia (Inter) e tokens de espaçamento seguem a identidade Swiss Park definida
no briefing, centralizados em `src/styles/global.css` como variáveis CSS (`--color-*`).
## Próximas etapas (fora do escopo desta entrega)
Empresas, Contas Contábeis, Fechamento, Usuários, Relatórios, Configurações e Auditoria já
aparecem na sidebar, mas ainda não possuem páginas — os itens estão desabilitados
propositalmente até a próxima etapa.
## docs
## contagem
     25 tsx       5 ts       4 json       4 css       1 png       1 md       1 html       1 gitignore 

```
