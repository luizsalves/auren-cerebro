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
- `autonomia:` leitura (só relata) · reversivel (altera o desfazível e escreve "## Como reverter" no relatório) · critico (prepara; o usuário aprova). Rodadas automáticas rodam isoladas (systemd-run): sistema só leitura, escrita só em `execucoes/` da rodada, `pendencias.md`, `raw/` e `escreve_em:`.
- Código do agente fica em `ferramentas/` dentro da pasta dele (só o usuário edita; `node_modules` fora do git). Produto com deploy próprio fica em `/opt/...` e o campo `codigo:` aponta para lá.
