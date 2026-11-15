---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/painel-web-swisspark), leitura automática do repositório
---

# Levantamento do repositório painel-web-swisspark

Repositório: https://github.com/luizsalves/painel-web-swisspark
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-09 Merge pull request #32 from luizsalves/feature/fechamento-observacoes-e-conta
2026-11-09 Merge pull request #31 from luizsalves/feature/saldo-anterior-sem-movimento
2026-11-09 Fechamento: observações com anexos no banco, aviso ao abrir a conta e conta na faixa de filtros
2026-11-09 Fechamento: conta sem lançamento no mês leva o saldo anterior
2026-11-08 Merge pull request #30 from luizsalves/feature/empresas-flags-saldo
2026-11-08 Merge pull request #29 from luizsalves/feature/resumo-dia-anterior
2026-11-08 Produtividade por empresa: 3 filtros de saldo vindos da tabela de posições
2026-11-08 Relatório de produtividade: só o resumo do dia anterior, às 07:00
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
primeiro: 2026-09-10 · total(≤80): 97 · branch: main
## arvore
.
.claude
.claude/agents
.deploy
.deploy/auto-deploy.sh
.env.example
backend
backend/.dockerignore
backend/PainelWebSwissPark.Api
backend/PainelWebSwissPark.Api.Tests
backend/PainelWebSwissPark.Posicoes
backend/PainelWebSwissPark.Posicoes.Tests
backend/PainelWebSwissPark.slnx
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
## manifestos
docker-compose.yml
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
posicoes-saldo-mensal.md
processo_conciliacao_contabil_totvs_rm.md
prompt-tati-conhecimento.md
prompt-visao-contador.md
referencia-visao-contador.html
regra-integracao-contabil.md
roadmap-swisspark.html
sql
tati
## contagem
    263 cs      88 ts      81 tsx      31 sql      29 md      12 css       9 json       4 png 

```
