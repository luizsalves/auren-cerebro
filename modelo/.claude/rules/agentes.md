---
paths:
  - "agentes/**"
---
# agentes/ — um agente por pasta

- `agente.md`, `conhecimento.md`, `exemplos.md`, `avaliacao.md`: só o usuário edita (em sessão interativa). Um agente em rodada automática propõe em `pendencias.md`.
- `pendencias.md`: `- [ ] AAAA-MM-DD [run_id] texto`. Resolver = marcar `[x]` e, se aceita, virar linha em `conhecimento.md` com a data.
- `execucoes/`: um arquivo por rodada, gravado pelo `rodar-agente.sh`; nunca editar depois de fechada.
- `conhecimento.md`: uma regra por linha, com data e fonte (`[[run_id]]` ou `[[raw-arquivo]]`). Regra que deixou de valer: risque, não apague.
- Nada de credenciais, documentos ou dados fiscais de clientes: só status e resumo. Segredos ficam em `/etc/cerebro-agentes/<nome>.env`.
- Código do agente fica fora, em `/opt/saas/<nome>/` (campo `codigo:`).
