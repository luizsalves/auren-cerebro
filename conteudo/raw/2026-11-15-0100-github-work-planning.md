---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/work-planning), leitura automática do repositório
---

# Levantamento do repositório work-planning

Repositório: https://github.com/luizsalves/work-planning
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-08 Zammad 7.2.2 como base do Work Planning: código (submódulo), modelo de containers e documentação
2026-11-08 Prepara repositorio para o Work Planning
primeiro: 2026-11-08 · total(≤80): 2 · branch: main
## arvore
.
README.md
deploy
deploy/.env.example
deploy/docker-compose.yml
zammad
## manifestos
## README (README.md)
# Work Planning
Sistema de chamados, baseado no [Zammad](https://zammad.org) 7.2.2 (código aberto, licença AGPL-3.0):
chamado com número, status, prazo, fila, responsável e relatórios; entrada por e-mail, formulário,
WhatsApp e Telegram.
## O que tem aqui
- `zammad/`: código-fonte do Zammad (submódulo de https://github.com/zammad/zammad, branch `stable`).
  Para baixar junto com este repositório: `git clone --recurse-submodules https://github.com/luizsalves/work-planning.git`
- `deploy/docker-compose.yml`: modelo oficial de containers (zammad-docker-compose, 03/11/2026).
- `deploy/.env.example`: variáveis usadas no VPS, sem as senhas.
## Onde roda
- Endereço: http://200.141.19.25:3000 (sem HTTPS por enquanto).
- VPS 200.141.19.25, containers Docker na conta do operador (`auren-factory`), pasta
  `/var/lib/auren-factory/work-planning` (cópia do `docker-compose.yml` + `.env` com as senhas internas, fora do Git).
- Dados em volumes do Docker: `work-planning_postgresql-data` (banco), `work-planning_zammad-storage`
  (anexos), `work-planning_elasticsearch-data` (busca), `work-planning_zammad-backup` (backup diário às 03:00,
  guarda 10 dias).
- Esta pasta no VPS: `/opt/saas/Chamados Workflow/work-planning` (código e documentação).
## Operação (no VPS, como operador)
```
cd /var/lib/auren-factory/work-planning
docker compose ps            # estado dos containers
docker compose logs -f       # registros
docker compose restart       # reiniciar
docker compose down          # parar (mantém os dados)
docker compose up -d         # ligar
```
Atualizar a versão: trocar `VERSION` no `.env`, depois `docker compose pull && docker compose up -d`
(o container `zammad-init` aplica as migrações).
## Histórico
- 08/11/2026: Chatwoot testado e descartado (é caixa de conversas, não tickets). Zammad 7.2.2 escolhido e
  colocado no ar; conta de administrador criada pelo Luiz na tela inicial.
## docs
## contagem
      1 yml       1 md       1 gitmodules       1 gitignore       1 example 

```
