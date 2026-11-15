---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/geo-planning), leitura automática do repositório
---

# Levantamento do repositório geo-planning

Repositório: https://github.com/luizsalves/geo-planning
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-09 Remove qualquer limite de zoom e de navegação no mapa
2026-11-09 Libera o zoom para ver o estado e corrige camadas que não carregavam
2026-11-09 Adiciona frontend web do GeoPlanning com mapa de fundo em MapLibre
2026-11-08 docs: projeto suspenso para revisão do escopo
2026-11-08 docs: foto do mapa do modelo base e link do pedido no repositório novo
2026-11-08 docs: sincronização uma vez por dia à 1h, como o Luiz pediu
2026-11-08 docs: onde o projeto fica e a sincronização do VPS e do PC
2026-11-08 docs: rascunho do pedido da Fase 1 para a AUREN Factory
2026-11-07 docs: novo local dos arquivos de CNPJ da Receita
2026-11-07 docs: pedido do GeoPlanning e conferência das fontes
primeiro: 2026-11-07 · total(≤80): 10 · branch: main
## arvore
.
README.md
docs
docs/imagens
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
tools/sincronizar-pc.ps1
tools/sincronizar-vps.sh
web
web/.env.example
web/.gitignore
web/README.md
web/index.html
web/package.json
web/src
web/tsconfig.app.json
web/tsconfig.json
web/tsconfig.node.json
web/vite.config.ts
## manifestos
## README (README.md)
# GeoPlanning — Latec Soluções
Base nacional de dados com mapas: empresas, população, renda, licitações e
indicadores por município, com classificação territorial A/B/C.
O pedido completo está em [`docs/pedido-original.md`](docs/pedido-original.md)
(SHA256 `ef5b82cf23f81e01cadda6a44e3c38974d38d28acb5a2ccfa80292653eb84c79`).
## Onde o projeto fica
- **GitHub** (fonte de tudo): https://github.com/luizsalves/geo-planning-
- **VPS**: `/opt/saas/geo-planning`, atualizado uma vez por dia à 1h de Brasília por
  `tools/sincronizar-vps.sh` (instalado em `/home/deploy/.local/bin/geo-planning-update`).
- **PC do Luiz**: `C:\Projetos\geo-planning`, atualizado uma vez por dia à 1h (ou assim que o
  PC ligar, se estiver desligado nessa hora) por `tools/sincronizar-pc.ps1`, rodado uma vez no PowerShell.
As cópias só baixam do GitHub. Uma mudança entra no GitHub e chega sozinha às duas. Uma cópia
com alteração local não é sobrescrita: a sincronização para e avisa no registro.
## Situação em 08/11/2026
**Projeto suspenso** pelo Luiz para rever o escopo. Na AUREN Factory, o pedido da Fase 1 (pedido-18) foi
planejado (3 tarefas) e está pausado antes da aprovação da especificação. Nada é construído até nova decisão.
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
2. **Modelo base rodando.** O modelo de projeto da Factory para dados com mapas
   (luizsalves/auren-template-geo) passou nos 8 testes, com banco PostGIS, API e navegador reais.
   No teste, o navegador abriu o mapa dos 16 municípios do Amapá (amostra pública do IBGE):
   ![Mapa do modelo base com os municípios do Amapá](docs/imagens/mapa-base-amapa.png)
3. **O sistema da Fase 1 ainda não foi construído.** O pedido está em
   [`docs/pedido-fase-1.md`](docs/pedido-fase-1.md) e espera o envio para a AUREN Factory.
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
imagens
pedido-fase-1.md
pedido-original.md
## contagem
      9 tsx       7 json       6 ts       5 md       2 py       2 gitignore       1 sh       1 ps1 

```
