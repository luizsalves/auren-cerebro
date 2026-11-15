---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-auren-template-geo]]
---

# AUREN Template Geo

**AUREN template de dados geográficos**: fundação dos projetos de dados com mapas gerados pela [[auren-factory]]. Conectores baixam fontes públicas e guardam Bronze (original), Silver (padronizado) e Gold (indicadores) em S3 (SeaweedFS); PostGIS serve a API; o mapa usa MapLibre GL JS; DAGs em Apache Airflow 3.4.

## O que traz
Python 3.12 (`app/`: api, db, storage, territorios), `dags/territorios_ibge.py`, frontend Vite com mapa, testes unit/integration/golden/e2e, amostra pública do Amapá (16 municípios, IBGE).

## Estado
4 commits (08/11/2026). Passou nos 8 testes com PostGIS, API e navegador reais; foi o modelo base testado para o [[geo-planning]].

## Relacionados
[[auren-factory]] · [[auren-template-stack]] · [[geo-planning]]
