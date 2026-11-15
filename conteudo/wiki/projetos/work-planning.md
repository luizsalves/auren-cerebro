---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-work-planning]]
---

# Work Planning (Zammad)

**Work Planning**: sistema de chamados baseado no **Zammad 7.2.2** (código aberto, AGPL-3.0): chamado com número, status, prazo, fila, responsável e relatórios; entrada por e-mail, formulário, WhatsApp e Telegram.

## Onde roda
http://200.141.19.25:3000 (sem HTTPS ainda). Containers Docker na conta do operador `auren-factory`, pasta `/var/lib/auren-factory/work-planning` (compose + `.env` fora do Git). Volumes: banco, anexos, busca (Elasticsearch) e backup diário às 03:00 (10 dias). Código e documentação em `/opt/saas/Chamados Workflow/work-planning`; o repositório traz o Zammad como submódulo e o `deploy/docker-compose.yml` oficial.

## Histórico
08/11/2026: Chatwoot testado e descartado (caixa de conversas, não tickets); Zammad escolhido e colocado no ar; conta de administrador criada.

## Relacionados
[[chamados-workflow]] · [[latec-tecnologia]]
