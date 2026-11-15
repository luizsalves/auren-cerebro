# Páginas de wiki/projetos geradas a partir dos repositórios do GitHub (carga inicial, 2026-11-15).
# Cada entrada: slug → (status, fontes (raw stems), corpo markdown sem frontmatter e sem o título H1).
HOJE = "2026-11-15"
R = lambda *n: ", ".join(f"[[2026-11-15-0100-github-{x}]]" for x in n)

PAGINAS = {}

PAGINAS["suite-planning"] = ("ativo", R("suite-planning", "painel-web-swisspark"), """
Suíte de sistemas em módulos da **Latec**. Hoje contém o **módulo contábil** (vendido como *BI Planning* / *Planning Contábil*): fechamento e conciliação contábil mensal sobre o TOTVS RM, balancete, balanço, DFC, indicadores, produtividade da equipe e a assistente de IA **Tati** (responde sobre os números sem inventar: todo número vem de uma ferramenta que consulta o sistema).

## Origem
Nasceu em 09/11/2026 como cópia do [[painel-web-swisspark]] (main `740faf9`), com histórico. O código foi renomeado (`backend/SuitePlanning.*`); a marca Swiss Park ainda aparece nas telas até a marca nova ser definida. Logo e tela de login do *Planning Contábil* com identidade Latec já entraram.

## Para quem
- Analista: prepara e concilia contas do fechamento.
- Gerente: confere e acompanha produtividade.
- Superadministrador: usuários, módulos, chat da Tati.
- Diretoria: visão de saúde da empresa.

## Stack
.NET 10 (API única que acessa bancos e IA) · React + Vite · PostgreSQL (dados próprios) · SQL Server do TOTVS RM só leitura · Docker Compose com nginx · provedor de IA (DeepSeek hoje). Especificação técnica para reconstrução em `docs/modulo-contabil/especificacao-tecnica.md`.

## Onde fica
GitHub privado (fonte) · VPS `/opt/saas/suite-planning` · PC `C:\\Projetos\\suite-planning`. Cópias só baixam a `main` (1h da manhã e botão Deploy do cérebro). Ainda não roda na VPS: falta banco, porta e `secrets/keys.json`.

## Estado (nov/2026)
96 commits desde 10/09/2026. Últimos: fechamento com observações e anexos, saldo anterior para conta sem movimento, posições mensais de saldo no PostgreSQL, produtividade por empresa, empresas por coligada, deploy só da `main`.

## Relacionados
[[painel-web-swisspark]] (origem) · [[swiss-park]] (cliente) · [[latec-tecnologia]] (quem vende) · [[painel-conciliacao]] (primeiro protótipo) · [[ia-planning-pilotos]] (agente contábil piloto) · [[auren-ecossistema]]
""")

PAGINAS["painel-web-swisspark"] = ("ativo", R("painel-web-swisspark"), """
Sistema web de **fechamento e conciliação contábil mensal** feito para o grupo **Swiss Park** (coligadas, filiais e SCPs), comercializado pela Latec como *BI Planning*. Lê a contabilidade do TOTVS RM (SQL Server, só leitura), controla o fechamento conta a conta (preparar → pré-conferir → conferir → fechar, com quem e quando), mostra balancete/balanço/DFC/indicadores e tem a IA "CFO Tati".

## Stack
.NET 10 · React + TypeScript + Vite · PostgreSQL · Docker Compose (nginx + api) · deploy automático da `main` na VPS (`.deploy/auto-deploy.sh`). 263 arquivos C#, 31 SQL, 29 documentos em `docs/` (autenticação, Docker, regra de integração contábil, processo de conciliação no TOTVS RM, prompts da Tati, roadmap).

## Histórico
Começou em 10/09/2026 (ideia inicial: API própria sobre Postgres; depois BFF em C# cruzando APIs do ERP). 97 commits e 32 PRs até 09/11/2026. Em 09/11 virou a base do [[suite-planning]], que passa a ser o repositório principal do módulo.

## Relacionados
[[suite-planning]] · [[swiss-park]] · [[painel-conciliacao]] · [[latec-tecnologia]]
""")

PAGINAS["latec-tecnologia"] = ("ativo", R("latec-tecnologia"), """
Site institucional da **Latec — Tecnologia contábil com IA** (latecsolucoes): landing page estática com as soluções (plataforma em módulos, "um especialista para cada" área, agentes), clientes que confiam (Swiss Park, RC Feres, Villa Suíça, Suite Planning) e chamada para escritórios contábeis parceiros.

## Stack
HTML/CSS estático, fontes Manrope e Sora · nginx na VPS (`deploy/nginx-latecsolucoes.conf`, `deploy/vps-setup.sh`). Menu fixo, botão flutuante de WhatsApp, ajustes para celular.

## Estado (nov/2026)
6 commits (08–09/11/2026): site antigo substituído pela nova landing page, deploy que não sobrescreve o nginx.

## Relacionados
[[suite-planning]] · [[geo-planning]] · [[swiss-park]] · [[rcferes-imobiliaria]]
""")

PAGINAS["geo-planning"] = ("pausado", R("geo-planning", "geoplanning"), """
**GeoPlanning — Latec Soluções**: base nacional de dados com mapas (empresas, população, renda, licitações e indicadores por município) com classificação territorial A/B/C.

## Estado (08/11/2026)
**Suspenso** pelo Luiz para rever o escopo. Na [[auren-factory]], o pedido da Fase 1 (pedido-18) foi planejado em 3 tarefas e está pausado antes da aprovação da especificação. Nada é construído até nova decisão.

## O que já existe
- Conferência das fontes públicas: 140 links do pedido (115 abrem), 81 pontos de dados (66 funcionam). CNPJ da Receita mudou para compartilhamento mensal (`2026-10`, 7,8 GB); sócios são dados pessoais e não devem ser usados.
- Modelo base da Factory para dados com mapas ([[auren-template-geo]]) rodando: PostGIS, API e mapa dos 16 municípios do Amapá.
- Frontend web com mapa de fundo em MapLibre (`web/`), zoom livre.
- Documentos: `docs/pedido-original.md`, `docs/pedido-fase-1.md`, `inventario/RESUMO.md`.

## Onde fica
GitHub `luizsalves/geo-planning` (o repositório `geoplanning` é a versão anterior, só documentos) · VPS `/opt/saas/geo-planning` · PC `C:\\Projetos\\geo-planning`, sincronizados 1x/dia à 1h.

## Próximos passos (do README)
1. Rever fontes que falharam. 2. Definir a Fase 1: mapa do Brasil por município com população, PIB e empresas, filtros por UF e município. 3. Construção pela Factory, que precisa aprender Python/Airflow/MinIO/PostGIS.

## Relacionados
[[auren-factory]] · [[auren-template-geo]] · [[latec-tecnologia]] · [[auren-ecossistema]]
""")

PAGINAS["auren-factory"] = ("ativo", R("auren-factory"), """
**AUREN Factory**: fábrica de software do AUREN Intelligence Ecosystem. Recebe um pedido, planeja, constrói, testa e entrega sistemas com agentes de IA controlados (Claude Code e Codex, isolados em Docker), com aprovação humana, orçamento e evidências. CLI Python (`auren`), PostgreSQL, Verifier independente.

## Como funciona
Pedido → spec aprovada por hash → tarefas → agente implementa em container isolado → Verifier roda os gates (build, lint, unit, integração, golden, e2e, secret-scan) → PR → revisão → preview → promoção/rollback. Orçamento com tetos (30/3/3) e aprovação do dono pelo Telegram. Claude e Codex se revezam quando um atinge limite de uso.

## Estado (nov/2026)
60 commits desde 29/10/2026, 17 PRs. F0, F1, F2 e F3 validados na VPS com evidências em `docs/validacoes/`. Operação contínua (release instalada, supervisão por cron, backup diário, restore mensal) implementada e testada, **ainda não ativada**. Em 08/11 entrou a stack de dados (PostGIS + S3) ao lado da stack .NET. Backup externo em `D:\\Projetos\\auren-factory`.

## Documentos
`docs/ESPECIFICACAO.md` (v1.2, arquitetura congelada; mudanças só por ADR em `docs/decisoes/`), `ARQUITETURA.md`, `OPERACAO.md`, `STATUS.md`, `RETOMADA-20261101.md`.

## Relacionados
Gera projetos a partir de [[auren-template-stack]] e [[auren-template-geo]] · validações em [[auren-factory-validacoes]] · construiu [[app-pedido-11]] · pedido pausado do [[geo-planning]] · parte do [[auren-ecossistema]]
""")

PAGINAS["auren-template-stack"] = ("ativo", R("auren-template-stack"), """
**AUREN Template Stack**: fundação dos sistemas gerados pela [[auren-factory]] — .NET 10, React/TypeScript, PostgreSQL 17, Identity (login com registro público desligado), migrations, testes com banco real (Testcontainers) e Playwright. Em homologação.

## O que traz
`backend/` (App.Api), `frontend/` (Vite), `database/migrations`, `tests/casos-ouro`, `scripts/check.sh` com os gates (build, lint, unit, integration, golden, e2e, secret-scan), `knowledge/` e `backlog/` para o projeto gerado, `AGENTS.md` por pasta.

## Estado
12 commits (29–30/10/2026), PR 1 integrado. CI valida os modos com e sem Docker socket. Sem deploy: publicação é controlada pela fábrica.

## Relacionados
[[auren-factory]] · [[auren-template-geo]] · cópias geradas: [[auren-factory-validacoes]], [[app-pedido-11]]
""")

PAGINAS["auren-template-geo"] = ("ativo", R("auren-template-geo"), """
**AUREN template de dados geográficos**: fundação dos projetos de dados com mapas gerados pela [[auren-factory]]. Conectores baixam fontes públicas e guardam Bronze (original), Silver (padronizado) e Gold (indicadores) em S3 (SeaweedFS); PostGIS serve a API; o mapa usa MapLibre GL JS; DAGs em Apache Airflow 3.4.

## O que traz
Python 3.12 (`app/`: api, db, storage, territorios), `dags/territorios_ibge.py`, frontend Vite com mapa, testes unit/integration/golden/e2e, amostra pública do Amapá (16 municípios, IBGE).

## Estado
4 commits (08/11/2026). Passou nos 8 testes com PostGIS, API e navegador reais; foi o modelo base testado para o [[geo-planning]].

## Relacionados
[[auren-factory]] · [[auren-template-stack]] · [[geo-planning]]
""")

PAGINAS["auren-factory-validacoes"] = ("concluido", R("auren-f1-validation-20261029", "auren-f2-benchmark-20261030", "auren-f3-demo-20261030"), """
Três repositórios gerados pela [[auren-factory]] a partir do [[auren-template-stack]] durante a homologação (29–30/10/2026). Não são produtos: são a evidência de que a fábrica gera, testa e integra projetos sozinha.

| Repositório | Fase | O que provou |
|---|---|---|
| `auren-f1-validation-20261029` | F1 | projeto gerado do template passou no CI e nos sete gates do Verifier na VPS (6 commits de ajuste no scanner e na verificação) |
| `auren-f2-benchmark-20261030` | F2 | rodada limpa de cinco tarefas, dez sessões de agente, cinco Verifiers e cinco PRs sem intervenção manual |
| `auren-f3-demo-20261030` | F3 | ensaio completo até o preview: spec aprovada, scaffold, implementação, revisão, CI e preview com login/logout em desktop e celular |

Evidências detalhadas em `auren-factory/docs/validacoes/`.

## Relacionados
[[auren-factory]] · [[auren-template-stack]]
""")

PAGINAS["app-pedido-11"] = ("pausado", R("app-pedido-11-675fa1b4"), """
Projeto gerado pela [[auren-factory]] para o **pedido 11** (03/11/2026), a partir do [[auren-template-stack]]: .NET 10 + React + PostgreSQL com Identity, gates e Playwright. Um único commit ("Initial commit"): é o scaffold, sem implementação de negócio ainda.

## Relacionados
[[auren-factory]] · [[auren-template-stack]]
""")

PAGINAS["auren-ecossistema"] = ("ativo", R("auren-intelligence-ecosystems"), """
**AUREN Intelligence Ecosystem**: o ecossistema tecnológico que sustenta o produto **IA Planning** (plataforma de FP&A com inteligência artificial). Repositório `auren-intelligence-ecosystems`, de setembro de 2026, concentra a documentação de arquitetura e um protótipo do módulo contábil.

## Peças
- **IA Planning** — produto de FP&A (portal web com Prompt AI/Tati, indicadores, DRE/DFC, forecast, orçamento, alertas; Teams, Outlook e Excel como canais).
- **AUREN Factory** — fábrica de desenvolvimento autônomo ([[auren-factory]]).
- **AUREN Agents** — agentes especializados (piloto em [[ia-planning-pilotos]]).
- **AUREN Harness** — controle e segurança dos agentes (tenant, permissões, políticas, custo, auditoria).
- **AUREN RAG** — base de conhecimento. **AUREN Core** — serviços centrais.

## Documentos
`docs/01_ARQUITETURA_COMPLETA.md`, `01_ARQUITETURA_FPA_AI.md`, `02_ARQUITETURA_DE_PRODUTO.md`, `02_ESCOPO_IA_PLANNING.md`, `03_ARQUITETURA_PROMPT_E_PORTAL.md`, `03_ROADMAP_IA_PLANNING.md`, `04_PROJETO_AGENTE_CONTABIL.md`, `05_ARQUITETURA_TECNICA.md`, estruturas do TOTVS RM, contrato back/front, telas do sistema, régua de cobrança.

## Estado
9 commits (20–28/09/2026): escopo de indicadores, chat e projeção com extrato; módulo contábil incluído no repositório principal; documentação centralizada em `docs/`.

## Relacionados
[[auren-factory]] · [[suite-planning]] · [[ia-planning-pilotos]] · [[geo-planning]] · [[modelo-estrutural]]
""")

PAGINAS["ia-planning-pilotos"] = ("pausado", R("iaplanning"), """
Pilotos pequenos de agentes de IA do IA Planning ([[auren-ecossistema]]), em Python com a API da Anthropic: a IA nunca calcula números sozinha, indicadores e regras são fixos e tudo passa por ferramenta.

| Agente | O que faz | Dados hoje |
|---|---|---|
| Contas a Pagar | total em aberto, vencido, a vencer, atrasos, resumo por categoria; aceita extrato bancário (PDF/imagem/CSV/OFX) e projeta saldo | `data/contas_a_pagar.csv` (fake); leitura isolada para trocar pelo TOTVS RM |
| Conciliação Contábil | só leitura: razão, balancete, plano de contas, conferência de partidas dobradas (`validar_lancamento` não grava) | `data/contabilidade/*.csv` (10 lançamentos fake) |

Cada agente é um módulo em `src/`, com spec em `specs/` e serviço no `docker-compose.yml`. 4 commits (21–25/09/2026); último removeu capacidade de escrita do agente contábil.

## Relacionados
[[auren-ecossistema]] · [[suite-planning]] (a Tati é a evolução em produção) · [[painel-web-swisspark]]
""")

PAGINAS["modelo-estrutural"] = ("pausado", R("modelo-estrutural"), """
**Portal Power BI Embedded v2**: estrutura inicial, sem código, em duas aplicações — `frontend/` (React, Vite, TypeScript, Atomic Design) e `backend/` (C#, ASP.NET Core Web API, .NET 10, arquitetura em camadas com projetos independentes). Regra: o frontend nunca contém segredos (Client Secret, JWT, banco, SMTP).

Um commit (10/09/2026). Serviu de modelo de organização de pastas para o [[painel-web-swisspark]] (citado em `docs/contexto-projeto-swisspark.md` como "projeto modelo usado por um dev sênior"). Na VPS existe a pasta [[modelo-projeto]].

## Relacionados
[[painel-web-swisspark]] · [[modelo-projeto]] · [[auren-ecossistema]]
""")

PAGINAS["painel-conciliacao"] = ("concluido", R("painel_conciliacao"), """
Primeiro protótipo (09/08/2026) do sistema de conciliação contábil do Swiss Park: frontend React + TypeScript + Vite com login mockado (usuária Karime, gerente) e dashboard com KPIs e gráficos em SVG puro. Identidade visual Swiss Park em variáveis CSS. Empresas, contas, fechamento, usuários e relatórios apareciam na sidebar desabilitados.

Foi substituído pelo [[painel-web-swisspark]] (setembro/2026), que virou o [[suite-planning]].

## Relacionados
[[painel-web-swisspark]] · [[suite-planning]] · [[swiss-park]]
""")

PAGINAS["work-planning"] = ("ativo", R("work-planning"), """
**Work Planning**: sistema de chamados baseado no **Zammad 7.2.2** (código aberto, AGPL-3.0): chamado com número, status, prazo, fila, responsável e relatórios; entrada por e-mail, formulário, WhatsApp e Telegram.

## Onde roda
http://200.141.19.25:3000 (sem HTTPS ainda). Containers Docker na conta do operador `auren-factory`, pasta `/var/lib/auren-factory/work-planning` (compose + `.env` fora do Git). Volumes: banco, anexos, busca (Elasticsearch) e backup diário às 03:00 (10 dias). Código e documentação em `/opt/saas/Chamados Workflow/work-planning`; o repositório traz o Zammad como submódulo e o `deploy/docker-compose.yml` oficial.

## Histórico
08/11/2026: Chatwoot testado e descartado (caixa de conversas, não tickets); Zammad escolhido e colocado no ar; conta de administrador criada.

## Relacionados
[[chamados-workflow]] · [[latec-tecnologia]]
""")

PAGINAS["zum-commerce"] = ("ativo", R("zum-commerce"), """
Front-end do **Zum Commerce**, a plataforma SaaS da [[zum-web-studio]] para lojas que vendem pela Shopify: a Zum administra todas as lojas num painel; cada lojista tem sua loja isolada (produtos, clientes, taxas, acessos); cada loja vende por um site sob medida (ex.: [[elika-tiaras]]) ou pela vitrine padrão; o lojista cadastra produtos no SaaS com simulador de taxas; o cliente final compra com cadastro (Google, Facebook ou e-mail); pagamento e checkout são sempre da Shopify. Modelo: implantação + mensalidade por loja.

## Stack
React 19, TypeScript, Vite, Tailwind 4, Firebase (Auth, Firestore, Hosting), Shopify Storefront API. `firebase.json` redireciona `/api/**` para a API no Cloud Run (`southamerica-east1`). Fotos de produto vão pela API direto para a Shopify (Storage não é usado).

## Estado
6 commits (23/10–08/11/2026): estrutura inicial, escolha dos canais de venda no painel, envio de fotos para a Shopify, conciliação com ajustes feitos na VPS. Escopo completo em `ESCOPO_DO_PROJETO.md`.

## Relacionados
[[zum-commerce-api]] (back) · [[zum-shop]] (agregador) · [[loja-virtual]] (pasta na VPS) · [[zum-web-studio]] · [[elika-tiaras]]
""")

PAGINAS["zum-commerce-api"] = ("ativo", R("zum-commerce-api"), """
API em C# do **Zum Commerce**: guarda as credenciais Shopify de cada loja (criptografadas com AES-256), valida o login do Firebase e faz tudo que exige a Admin API da Shopify (produtos, estoque, fotos, clientes, publicação nos canais de venda).

## Stack
ASP.NET Core Web API, .NET 10 · Firestore · Firebase Auth (JWT) · Shopify Admin API (GraphQL) · Google Cloud Run. Camadas: Core.Domain, Core.Application, Core.Infrastructure (+CrossCutting, IoC), Core.Web; testes xUnit. Configuração em `docs/CONFIGURACAO.md`; endpoints em `backend/docs/ENDPOINTS.md`.

## Estado
6 commits (23/10–08/11/2026), em par com o front.

## Relacionados
[[zum-commerce]] (front) · [[zum-shop]] · [[zum-web-studio]]
""")

PAGINAS["zum-shop"] = ("ativo", R("zum-shop"), """
Repositório agregador privado que reúne [[zum-commerce]] e [[zum-commerce-api]] como submódulos Git, preservando os históricos independentes. Na máquina de desenvolvimento a raiz é `C:\\Projetos\\zum-shop`; na VPS, `/opt/saas/loja-virtual/zum-shop` (pasta [[loja-virtual]]). `chaves/`, `secrets/`, `.env` e backups ficam fora do Git; a sincronização não reinicia serviços.

2 commits (08/11/2026).

## Relacionados
[[zum-commerce]] · [[zum-commerce-api]] · [[loja-virtual]] · [[zum-web-studio]]
""")

PAGINAS["zum-web-studio"] = ("ativo", R("zum-web-studio"), """
Site do **Zum Web Studio** (criação de sites, landing pages e lojas virtuais): páginas `index`, `contratar`, `changelog`, `style-guide`, 401/404. Exportado do Webflow (CSS `luizs-radical-site-*.webflow.css`) e hospedado no Firebase (`firebase.json`, `.firebaserc`). Seções: "Seu site pronto para…", "Seu negócio na palma da mão do cliente", "Investimento que se paga", "Sua loja já nasce integrada" (liga ao [[zum-commerce]]).

Versionado em 08/11/2026 (1 commit).

## Relacionados
[[zum-commerce]] · [[elika-tiaras]] · [[dib-acessoria]] · [[rcferes-imobiliaria]] · [[adelie-croche]]
""")

PAGINAS["elika-tiaras"] = ("ativo", R("elika-tiaras"), """
Site sob medida da **Elika Tiaras** (tiaras e laços infantis), cliente da [[zum-web-studio]]: um único arquivo `elika-tiaras.html` com vitrine, sacola e login ("Entrar"). É o exemplo de "site sob medida" ligado ao [[zum-commerce]] (produtos e checkout pela Shopify).

Versionado em 08/11/2026 (1 commit).

## Relacionados
[[zum-commerce]] · [[zum-web-studio]]
""")

PAGINAS["dib-acessoria"] = ("ativo", R("dib-acessoria"), """
Site da **DIB Consultoria Contábil** (contabilidade consultiva e estratégica: planejamento tributário, BPO financeiro), cliente da [[zum-web-studio]]. Estático: `index.html`, `style.css`, `script.js`, imagens (logo, CRC-SP, carrossel), hospedado no Firebase.

Versionado em 08/11/2026 (1 commit).

## Relacionados
[[zum-web-studio]]
""")

PAGINAS["adelie-croche"] = ("ativo", R("adelie-croche"), """
Site da **Adélie Crochê**, cliente da [[zum-web-studio]]. Projeto React + Vite + Tailwind gerado no Figma Make (`.figma/make`, `AGENTS.md` do Figma), com logo em SVG (coração/laço). Versionado em 08/11/2026 (1 commit).

## Relacionados
[[zum-web-studio]]
""")

PAGINAS["rcferes-imobiliaria"] = ("ativo", R("rcferes-imobiliaria"), """
Site da **RC Feres Imobiliária** ("11 anos de tradição"), cliente da [[zum-web-studio]]: landing page responsiva em `public/` (index, `imovel.html`, admin, js/css), Firebase Hosting + Firestore (rules e índices) + Storage. Botões de WhatsApp com prévia de mensagem até o número ser fornecido; imóveis reais entram no array `properties`; imagens ilustrativas geradas. Há também `corretora-site/` (versão anterior) e notas `CACHE-FOTOS.md` e `LEIA-ME-FIREBASE.md`.

Versionado em 08/11/2026 (1 commit).

## Relacionados
[[zum-web-studio]] · [[latec-tecnologia]] (RC Feres aparece como cliente)
""")

PAGINAS["whatsapp"] = ("pausado", R("crm-whatsapp", "crm-whatsapp-codex"), """
**WhatsCRM**: SaaS multiempresa para atendimento via WhatsApp, CRM (funil), agenda e pós-venda, com um núcleo compartilhado entre verticais (vendas, clínicas, serviços, estética). Dois repositórios de setembro de 2026:

| Repositório | O que tem |
|---|---|
| `CRM-WhatsApp` (branch `claude/...`) | fundação (auth multiempresa, .NET 10, React, Docker) + integração WhatsApp: contatos, conexão da conta, webhook e conversas em tempo real (SignalR). Compose `whatsclaude`, porta 8090 |
| `CRM-WhatsApp-Codex` | só a fundação da SPEC-001 (auth e multiempresa) + `docs/STATUS-E-ROADMAP.md` com as SPEC-001 a 012 |

## Stack
C# .NET 10 / ASP.NET Core / EF Core / PostgreSQL / JWT / SignalR · React + TypeScript + Vite + PWA · Docker Compose + Nginx · desenvolvimento guiado por specs (`docs/specs/`). Regras críticas em `AGENTS.md`: isolamento multiempresa, status comercial separado da etapa do Kanban, minimização de dados de saúde.

## Estado
Sem commits desde 08/09/2026. Pasta na VPS: `/opt/saas/WhatsApp`.

## Relacionados
[[zum-web-studio]]
""")

PAGINAS["auren-cerebro"] = ("ativo", R("auren-cerebro"), """
Kit do **segundo cérebro**: instalador (`instalar.sh`), painel web (`painel/`) e o molde do cérebro (`modelo/`: CLAUDE.md, skills, hooks, scripts, agentes de sistema). Instalado na VPS em `/opt/projetos/auren-cerebro`; o cérebro em si fica em `/opt/cerebro` (antes `/root/cerebro`).

## O que o kit entrega
Painel com grafo, busca, captura, Deploy (VPS + agente Windows) e lobo Agentes · agentes em `agentes/` com orquestrador, árbitro e devops-agent · motor trocável (Claude / Ollama / simulado) · isolamento por `systemd-run` · hook SessionEnd que registra sessões dos projetos em `raw/` · `ligar-projetos.sh` que mantém as páginas dos projetos da VPS.

## Relacionados
[[projetos-vps]] · [[auren-factory]]
""")
