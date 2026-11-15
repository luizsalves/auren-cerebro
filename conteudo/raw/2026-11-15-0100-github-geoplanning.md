---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/geoplanning), leitura automática do repositório
---

# Levantamento do repositório geoplanning

Repositório: https://github.com/luizsalves/geoplanning
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-08 docs: rascunho do pedido da Fase 1 para a AUREN Factory
2026-11-07 docs: novo local dos arquivos de CNPJ da Receita
2026-11-07 docs: pedido do GeoPlanning e conferência das fontes
primeiro: 2026-11-07 · total(≤80): 3 · branch: main
## arvore
.
README.md
docs
docs/pedido-fase-1.md
docs/pedido-original.md
inventario
inventario/RESUMO.md
inventario/endpoints.json
inventario/links-do-pedido.json
tools
tools/check_sources.py
tools/endpoints.json
tools/resumo.py
## manifestos
## README (README.md)
# GeoPlanning — Latec Soluções
Base nacional de dados com mapas: empresas, população, renda, licitações e
indicadores por município, com classificação territorial A/B/C.
O pedido completo está em [`docs/pedido-original.md`](docs/pedido-original.md)
(SHA256 `ef5b82cf23f81e01cadda6a44e3c38974d38d28acb5a2ccfa80292653eb84c79`).
## Situação em 07/11/2026
1. **Conferência das fontes: feita.** O resultado está em
   [`inventario/RESUMO.md`](inventario/RESUMO.md).
   - Links citados no pedido: 140, dos quais 115 abrem normalmente.
   - Pontos de dados testados (APIs e arquivos): 81, dos quais 66 funcionam.
   - **CNPJ:** o link do pedido não responde, porque a Receita mudou os arquivos
     para um [compartilhamento público](https://arquivos.receitafederal.gov.br/index.php/s/gn672Ad4CF8N6TK?path=%2FDados%2FCadastros%2FCNPJ)
     com uma pasta por mês. A mais recente é `2026-10`, publicada em 13/10/2026,
     com 7,8 GB compactados:
     - Estabelecimentos: 5,4 GB (endereço, CNAE e situação);
     - Empresas: 1,4 GB;
     - Simples/MEI: 0,3 GB;
     - Sócios: 0,7 GB. São dados pessoais e o GeoPlanning não deve usá-los.
2. **Ainda não há código do sistema.**
## Próximos passos
1. Rever as fontes que falharam (lista em `inventario/RESUMO.md`).
2. Definir a Fase 1 (protótipo): mapa do Brasil por município com população,
   PIB e empresas, e filtros por UF e município. Ela só começa com a aprovação do Luiz.
3. Construção pela AUREN Factory, que antes precisa aprender a montar este
   tipo de sistema (Python, Airflow, MinIO e PostGIS).
## Como refazer a conferência
```
python3 -I tools/check_sources.py docs/pedido-original.md tools/endpoints.json inventario
python3 -I tools/resumo.py inventario
```
Só faz leituras públicas: uma requisição por vez em cada site, com pausa entre
elas, e nos downloads grandes lê só o começo do arquivo.
## docs

docs:
pedido-fase-1.md
pedido-original.md
## contagem
      4 md       3 json       2 py       1 gitignore 

```
