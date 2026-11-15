---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/auren-template-geo), leitura automática do repositório
---

# Levantamento do repositório auren-template-geo

Repositório: https://github.com/luizsalves/auren-template-geo
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-08 fix: load MapLibre's worker through Vite so outlines are drawn
2026-11-08 fix(e2e): the map is ready only when all outlines are drawn
2026-11-08 fix: SeaweedFS with small volumes and the Verifier's hardened flags in CI
2026-11-08 feat: template de dados geográficos (Python, PostGIS, S3, Airflow e mapa)
primeiro: 2026-11-08 · total(≤80): 4 · branch: main
## arvore
.
AGENTS.md
CLAUDE.md
README.md
app
app/__init__.py
app/__main__.py
app/api.py
app/db.py
app/settings.py
app/storage.py
app/territorios.py
backlog
backlog/README.md
dags
dags/territorios_ibge.py
database
database/migrations
docker-compose.yml
docs
docs/ARQUITETURA.md
frontend
frontend/AGENTS.md
frontend/e2e
frontend/index.html
frontend/package-lock.json
frontend/package.json
frontend/playwright.config.ts
frontend/public
frontend/src
frontend/tsconfig.app.json
frontend/tsconfig.json
frontend/tsconfig.node.json
frontend/vite.config.ts
knowledge
knowledge/README.md
pyproject.toml
requirements.in
requirements.lock
scripts
scripts/check.sh
scripts/e2e.sh
scripts/secret-scan.sh
tests
tests/__init__.py
tests/casos-ouro
tests/conftest.py
tests/fixtures
tests/test_api.py
tests/test_golden.py
tests/test_storage.py
tests/test_territorios.py
## manifestos
pyproject.toml:
[project]
name = "app"
version = "0.1.0"
description = "Projeto AUREN de dados geográficos: conectores, camadas Bronze/Silver/Gold, PostGIS, API e mapa."
requires-python = ">=3.12"

[tool.ruff]
line-length = 100
target-version = "py312"
extend-exclude = ["frontend"]

[tool.ruff.lint]
select = ["E", "F", "I", "B", "UP"]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--strict-markers"
markers = [
  "unit: sem serviços externos",
  "integration: PostGIS e armazenamento S3 reais e descartáveis",
  "golden: casos-ouro aprovados pelo responsável",
]
docker-compose.yml
## CLAUDE.md
Leia e siga AGENTS.md na raiz e no diretório em que estiver trabalhando.
## README (README.md)
# AUREN template de dados geográficos
Fundação dos projetos de dados com mapas gerados pela AUREN Factory. Os conectores baixam as
fontes públicas e guardam o original em Bronze, os dados padronizados em Silver e os
indicadores em Gold (S3). O PostGIS serve a API, e o mapa usa MapLibre GL JS.
O exemplo incluído carrega os municípios e os contornos do IBGE. Os testes usam uma amostra
pública do Amapá (16 municípios), gravada em `tests/fixtures/ibge/` (Fonte: IBGE).
## Desenvolvimento
Requisitos: Python 3.12, Node 24 e Docker. Use só ambientes descartáveis e dados públicos ou
sintéticos.
```bash
docker compose up -d postgis s3
export DATABASE_URL=postgresql://app:synthetic-dev-password@127.0.0.1:5432/app
export S3_ENDPOINT=http://127.0.0.1:8333 AWS_ACCESS_KEY_ID=dev AWS_SECRET_ACCESS_KEY=dev
bash scripts/check.sh build
.venv/bin/python -m app carregar-amostra
.venv/bin/python -m app serve            # API em 127.0.0.1:8080
npm --prefix frontend run dev            # mapa em 127.0.0.1:5173
```
## Gates
```bash
bash scripts/check.sh build        # cria .venv pelo requirements.lock e compila o frontend
bash scripts/check.sh lint         # ruff e oxlint
bash scripts/check.sh unit         # pytest -m unit e vitest
bash scripts/check.sh integration  # PostGIS e S3 reais
bash scripts/check.sh golden       # casos-ouro
bash scripts/check.sh e2e          # API, banco e navegador reais (Playwright)
bash scripts/check.sh secret-scan  # gitleaks com controle positivo
```
O job `testcontainers` do CI repete integração e casos-ouro contra o Docker Compose e confere
que as DAGs carregam no Apache Airflow 3.4. No Verifier da Factory
(`AUREN_MANAGED_VERIFIER=1`), o PostGIS e o S3 são descartáveis e chegam pelas mesmas variáveis.
## Dependências
```bash
pip-compile --generate-hashes --strip-extras --allow-unsafe -o requirements.lock requirements.in
```
## docs
AGENTS.md
CLAUDE.md

docs:
ARQUITETURA.md
## contagem
     14 py       7 ts       7 md       7 json       3 sh       2 yml       2 tsx       2 toml 

```
