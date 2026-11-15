---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/auren-factory), leitura automática do repositório
---

# Levantamento do repositório auren-factory

Repositório: https://github.com/luizsalves/auren-factory
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-07 Merge pull request #17 from luizsalves/feat/geo-stack
2026-11-08 fix: small SeaweedFS volumes for the Verifier's tmpfs
2026-11-08 test: stub the stack-bound template snapshot and probe S3 with an object
2026-11-08 feat: data stack with PostGIS and S3 next to the .NET stack
2026-11-07 Merge pull request #16 from luizsalves/feat/f4-engine-fallback
2026-11-04 fix: open Codex's private folders before removing a run's login copy
2026-11-04 test: check the billing guard before any engine is chosen
2026-11-04 feat: Claude and Codex take over from each other at usage limits
2026-11-03 Merge pull request #15 from luizsalves/feat/f4-budget-telegram
2026-11-03 feat: owner-approved budget raise, 30/3/3 ceilings and clearer Telegram
2026-11-02 Merge pull request #14 from luizsalves/feat/f4-telegram
2026-11-02 feat: owner's Telegram chat for status, approvals and answers
2026-11-02 Merge pull request #13 from luizsalves/feat/f4-max-power
2026-11-02 test: build the max-effort runner with the restricted network it requires
2026-11-02 feat: run agents on the most capable model at maximum effort
2026-11-02 Merge pull request #12 from luizsalves/feat/f4-golden-cases
2026-11-02 fix: let the Planner deliver golden cases through the approved plan
2026-11-01 Merge pull request #10 from luizsalves/feat/f3-final-validation
2026-11-01 feat: add final validation, deploy checkpoint, promotion and rollback
2026-11-01 Merge pull request #9 from luizsalves/feat/f3-operational-runtime
2026-11-01 docs: record continuous operation validation and GitHub token setup
2026-11-01 fix: build images from readable releases and never import from the cwd
2026-11-01 chore: report failed external commands and document continuous operation
2026-11-01 fix: keep installer output parseable and let restore read the dump as UID 999
2026-11-01 feat: finish reviewed continuous runtime with backup, stop and rollback
primeiro: 2026-10-29 · total(≤80): 60 · branch: main
## arvore
.
.dockerignore
.env.example
AGENTS.md
Dockerfile
README.md
agents
agents/README.md
benchmark
benchmark/f2
benchmark/f3
benchmark/mocks
deploy
deploy/configure-github-token.py
deploy/continuous-v1.yml
deploy/controller.example.yml
deploy/egress
deploy/install-release.py
deploy/provision-operator.sh
docker-compose.yml
docs
docs/ARQUITETURA.md
docs/ESPECIFICACAO.md
docs/HISTORICO_CONVERSA.md
docs/OPERACAO.md
docs/RETOMADA-20261101.md
docs/STATUS.md
docs/decisoes
docs/validacoes
migrations
migrations/README.md
orchestrator
orchestrator/__init__.py
orchestrator/backlog.py
orchestrator/backup_exports.py
orchestrator/budget.py
orchestrator/cli.py
orchestrator/config.py
orchestrator/controller.py
orchestrator/db.py
orchestrator/delivery.py
orchestrator/engines.py
orchestrator/evidence.py
orchestrator/git_manager.py
orchestrator/github.py
orchestrator/github_intake.py
orchestrator/instructions
orchestrator/intake.py
orchestrator/main.py
orchestrator/notifications.py
orchestrator/operational.py
orchestrator/operational_backup.py
orchestrator/operations.py
orchestrator/packaging.py
orchestrator/pipeline.py
orchestrator/planning.py
orchestrator/policy.py
orchestrator/preview_runtime.py
orchestrator/previews.py
orchestrator/question_sync.py
## manifestos
pyproject.toml:
[build-system]
requires = ["setuptools>=75"]
build-backend = "setuptools.build_meta"

[project]
name = "auren-factory"
version = "0.1.0"
description = "Orquestração auditável de engenharia com agentes isolados"
requires-python = ">=3.12"
dependencies = [
    "psycopg[binary]>=3.2,<4",
    "PyYAML>=6.0.2,<7",
    # Windows has no system time zone database for zoneinfo.
    "tzdata>=2024.1; sys_platform == 'win32'",
]

[project.optional-dependencies]
dev = ["pytest>=8.3,<9", "ruff>=0.11,<1"]

[project.scripts]
auren = "orchestrator.cli:main"

[tool.setuptools.packages.find]
include = ["orchestrator*"]

[tool.setuptools.package-data]
orchestrator = ["sql/*.sql", "instructions/*.md"]

[tool.pytest.ini_options]
testpaths = ["tests"]
Dockerfile
docker-compose.yml
## README (README.md)
# AUREN Factory
Fábrica de software do AUREN Intelligence Ecosystem: recebe um pedido, planeja, constrói, testa e entrega sistemas com agentes de IA controlados.
- Especificação oficial (v1.2, arquitetura congelada): [docs/ESPECIFICACAO.md](docs/ESPECIFICACAO.md)
- Mudanças de arquitetura só por ADR em `docs/decisoes/`.
## Implementação inicial
O repositório agora inclui a CLI Python, persistência PostgreSQL, controles de
aprovação e orçamento e execução de tarefas com agentes Docker isolados.
Ainda não é a fábrica autônoma v1 homologada. Consulte
[STATUS](docs/STATUS.md), [operação](docs/OPERACAO.md) e
[arquitetura](docs/ARQUITETURA.md) antes de executar agentes.
```bash
python -m venv .venv
# Linux: . .venv/bin/activate | Windows: .venv\Scripts\Activate.ps1
pip install -e '.[dev]'
auren doctor
auren --help
```
```
