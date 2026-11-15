---
tipo: projeto
status: pausado
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-geo-planning]], [[2026-11-15-0100-github-geoplanning]]
---

# GeoPlanning

**GeoPlanning — Latec Soluções**: base nacional de dados com mapas (empresas, população, renda, licitações e indicadores por município) com classificação territorial A/B/C.

## Estado (08/11/2026)
**Suspenso** pelo Luiz para rever o escopo. Na [[auren-factory]], o pedido da Fase 1 (pedido-18) foi planejado em 3 tarefas e está pausado antes da aprovação da especificação. Nada é construído até nova decisão.

## O que já existe
- Conferência das fontes públicas: 140 links do pedido (115 abrem), 81 pontos de dados (66 funcionam). CNPJ da Receita mudou para compartilhamento mensal (`2026-10`, 7,8 GB); sócios são dados pessoais e não devem ser usados.
- Modelo base da Factory para dados com mapas ([[auren-template-geo]]) rodando: PostGIS, API e mapa dos 16 municípios do Amapá.
- Frontend web com mapa de fundo em MapLibre (`web/`), zoom livre.
- Documentos: `docs/pedido-original.md`, `docs/pedido-fase-1.md`, `inventario/RESUMO.md`.

## Onde fica
GitHub `luizsalves/geo-planning` (o repositório `geoplanning` é a versão anterior, só documentos) · VPS `/opt/saas/geo-planning` · PC `C:\Projetos\geo-planning`, sincronizados 1x/dia à 1h.

## Próximos passos (do README)
1. Rever fontes que falharam. 2. Definir a Fase 1: mapa do Brasil por município com população, PIB e empresas, filtros por UF e município. 3. Construção pela Factory, que precisa aprender Python/Airflow/MinIO/PostGIS.

## Relacionados
[[auren-factory]] · [[auren-template-geo]] · [[latec-tecnologia]] · [[auren-ecossistema]]
