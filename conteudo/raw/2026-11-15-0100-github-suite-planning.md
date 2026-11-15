---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/suite-planning), leitura automática do repositório
---

# Levantamento do repositório suite-planning

Repositório: https://github.com/luizsalves/suite-planning
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-09 Nova tela de login e marca Planning Contábil (#1)
2026-11-09 chore(deploy): script de deploy automático no VPS (timer systemd puxando a main)
2026-11-09 feat(marca): logo do Planning Contábil em todo o painel
2026-11-09 feat(login): nova tela de login do Planning Contábil com identidade Latec
2026-11-09 docs: especificação técnica do módulo contábil
2026-11-09 Adiciona README e o script de sincronização do PC
2026-11-09 Renomeia o projeto para Suite Planning
2026-11-08 Merge: remove publicações comitadas por engano em .tmp/ (448MB)
2026-11-08 Remove publicações comitadas por engano em .tmp/ (448MB)
2026-11-08 Merge pull request #22 from luizsalves/chore/deploy-so-da-main
2026-11-08 Merge pull request #28 from luizsalves/feature/posicoes-saldo-mensal
2026-11-08 Exige data de integracao em todas as consultas de partidas contabeis
2026-11-08 Persiste posicoes mensais de saldo no PostgreSQL sem alterar endpoints
2026-11-07 Merge pull request #27 from luizsalves/feature/avatar-acessorios
2026-11-07 Avatar: cor da camiseta, batom, barba, óculos e brinco; rostos refeitos
2026-11-07 Merge pull request #26 from luizsalves/fix/produtividade-por-empresa
2026-11-07 Produtividade por empresa: corrige erro de filial duplicada e usa o período da gaveta
2026-11-07 Merge pull request #25 from luizsalves/fix/empresas-responsavel
2026-11-07 Empresas: filial sem responsável não vira "Vários"
2026-11-07 Merge pull request #24 from luizsalves/fix/empresas-sem-botao-filiais
2026-11-07 Empresas: sem botão Filiais; empresa pela raiz do CNPJ; ativar/desativar a empresa inteira
2026-11-07 Merge pull request #23 from luizsalves/feature/empresas-por-coligada
2026-11-07 Empresas: uma linha por empresa; analista e gerente valem para todas as filiais
2026-11-07 Deploy automático só publica a main
2026-11-07 Merge pull request #21 from luizsalves/feature/produtividade-abas
primeiro: 2026-09-10 · total(≤80): 96 · branch: main
## arvore
.
.claude
.claude/agents
.deploy
.deploy/auto-deploy.sh
.env.example
README.md
backend
backend/.dockerignore
backend/SuitePlanning.Api
backend/SuitePlanning.Api.Tests
backend/SuitePlanning.Posicoes
backend/SuitePlanning.Posicoes.Tests
backend/SuitePlanning.slnx
deploy
deploy/vps-instalar-deploy.sh
docker-compose.yml
docs
docs/04_PROJETO_AGENTE_CONTABIL.md
docs/AUTENTICACAO.md
docs/DOCKER.md
docs/Guia_Clonagem_Repositorio_Git_Servidor_Linux.md
docs/Guia_Deploy_Automatico_GitHub_Linux_Docker.md
docs/PEDIDO-TI-ENTRA-ID.md
docs/RETOMAR-produtividade-equipe.md
docs/contexto-projeto-swisspark.md
docs/modulo-contabil
docs/posicoes-saldo-mensal.md
docs/processo_conciliacao_contabil_totvs_rm.md
docs/prompt-tati-conhecimento.md
docs/prompt-visao-contador.md
docs/referencia-visao-contador.html
docs/regra-integracao-contabil.md
docs/roadmap-swisspark.html
docs/sql
docs/tati
frontend
frontend/.dockerignore
frontend/.env.example
frontend/.gitignore
frontend/.oxlintrc.json
frontend/Dockerfile
frontend/README.md
frontend/docker-entrypoint.sh
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
tools
tools/sincronizar-pc.ps1
## manifestos
docker-compose.yml
## README (README.md)
# Suite Planning
Suíte de sistemas em módulos. Este repositório tem hoje o **módulo contábil** (BI Planning,
antigo Painel Web SwissPark): fechamento e conciliação contábil mensal sobre o TOTVS RM, balancete,
balanço, DFC, indicadores, produtividade da equipe e a assistente de IA Tati.
Backend .NET 10, frontend React (Vite) e Docker.
Especificação do módulo: [docs/modulo-contabil/especificacao-tecnica.md](docs/modulo-contabil/especificacao-tecnica.md).
Nasceu como cópia do `painel-web-swisspark` (main `740faf9`, em 09/11/2026), com o histórico.
O código passou a se chamar Suite Planning: `backend/PainelWebSwissPark.*`, citado na especificação,
agora é `backend/SuitePlanning.*`. A marca do cliente Swiss Park (logo, cores e textos das telas)
continua até a marca nova ser definida.
## Onde ele fica
| Lugar | Caminho | Como atualiza |
|---|---|---|
| GitHub | `luizsalves/suite-planning` (privado), branch `main` | é a fonte |
| VPS | `/opt/saas/suite-planning` | todo dia à 1h de Brasília e pelo botão **Deploy** do cérebro |
| PC do Luiz | `C:\Projetos\suite-planning` | todo dia à 1h (ou quando o PC ligar) e pelo botão **Deploy** do cérebro |
As cópias da VPS e do PC só baixam a `main`; nunca enviam nada ao GitHub. Se alguém mudar
arquivos nelas, a atualização para e avisa, para não apagar trabalho.
Por enquanto o deploy só atualiza o código. O sistema ainda não roda na VPS: falta escolher o
banco, a porta e as chaves (`secrets/keys.json`).
### PC (uma vez)
No PowerShell, sem administrador:
```powershell
gh repo clone luizsalves/suite-planning C:\Projetos\suite-planning
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Projetos\suite-planning\tools\sincronizar-pc.ps1
```
O script agenda a atualização diária e, se o agente do cérebro estiver instalado no PC, liga a
pasta ao botão **Deploy**.
## Desenvolvimento
- Backend: `cd backend && dotnet test SuitePlanning.slnx` (.NET 10). Posições:
  `dotnet test SuitePlanning.Posicoes.Tests/SuitePlanning.Posicoes.Tests.csproj`.
- Frontend: `cd frontend && npm ci && npm run build && npm test` (Node 20.19 ou mais novo).
- Docker: `docker compose up -d --build` na raiz (projeto `suite-planning`), com `.env` e
  `secrets/keys.json` como em `.env.example` e `docs/DOCKER.md`.
Os documentos em `docs/` vêm do painel SwissPark e descrevem a instalação dele.
## docs

docs:
04_PROJETO_AGENTE_CONTABIL.md
AUTENTICACAO.md
DOCKER.md
Guia_Clonagem_Repositorio_Git_Servidor_Linux.md
Guia_Deploy_Automatico_GitHub_Linux_Docker.md
PEDIDO-TI-ENTRA-ID.md
RETOMAR-produtividade-equipe.md
contexto-projeto-swisspark.md
modulo-contabil
posicoes-saldo-mensal.md
processo_conciliacao_contabil_totvs_rm.md
prompt-tati-conhecimento.md
prompt-visao-contador.md
referencia-visao-contador.html
regra-integracao-contabil.md
```
