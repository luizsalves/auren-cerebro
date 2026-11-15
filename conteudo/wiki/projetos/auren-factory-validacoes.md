---
tipo: projeto
status: concluido
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-auren-f1-validation-20261029]], [[2026-11-15-0100-github-auren-f2-benchmark-20261030]], [[2026-11-15-0100-github-auren-f3-demo-20261030]]
---

# Validações da AUREN Factory (F1, F2, F3)

Três repositórios gerados pela [[auren-factory]] a partir do [[auren-template-stack]] durante a homologação (29–30/10/2026). Não são produtos: são a evidência de que a fábrica gera, testa e integra projetos sozinha.

| Repositório | Fase | O que provou |
|---|---|---|
| `auren-f1-validation-20261029` | F1 | projeto gerado do template passou no CI e nos sete gates do Verifier na VPS (6 commits de ajuste no scanner e na verificação) |
| `auren-f2-benchmark-20261030` | F2 | rodada limpa de cinco tarefas, dez sessões de agente, cinco Verifiers e cinco PRs sem intervenção manual |
| `auren-f3-demo-20261030` | F3 | ensaio completo até o preview: spec aprovada, scaffold, implementação, revisão, CI e preview com login/logout em desktop e celular |

Evidências detalhadas em `auren-factory/docs/validacoes/`.

## Relacionados
[[auren-factory]] · [[auren-template-stack]]
