---
tipo: projeto
status: pausado
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-iaplanning]]
---

# IA Planning — agentes piloto

Pilotos pequenos de agentes de IA do IA Planning ([[auren-ecossistema]]), em Python com a API da Anthropic: a IA nunca calcula números sozinha, indicadores e regras são fixos e tudo passa por ferramenta.

| Agente | O que faz | Dados hoje |
|---|---|---|
| Contas a Pagar | total em aberto, vencido, a vencer, atrasos, resumo por categoria; aceita extrato bancário (PDF/imagem/CSV/OFX) e projeta saldo | `data/contas_a_pagar.csv` (fake); leitura isolada para trocar pelo TOTVS RM |
| Conciliação Contábil | só leitura: razão, balancete, plano de contas, conferência de partidas dobradas (`validar_lancamento` não grava) | `data/contabilidade/*.csv` (10 lançamentos fake) |

Cada agente é um módulo em `src/`, com spec em `specs/` e serviço no `docker-compose.yml`. 4 commits (21–25/09/2026); último removeu capacidade de escrita do agente contábil.

## Relacionados
[[auren-ecossistema]] · [[suite-planning]] (a Tati é a evolução em produção) · [[painel-web-swisspark]]
