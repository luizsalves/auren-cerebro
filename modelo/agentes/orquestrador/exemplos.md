# Exemplos

## Exemplo 1 — captura cita um cliente coberto por um agente
**Situação:** raw/ novo diz "a Latec pediu para conferir as procurações do cliente X no e-CAC".
**O que fiz:** `DESPACHAR: ecac-monitor | Conferir procurações do cliente X (origem: raw/2026-11-14-0912-captura.md)`.
**Resultado:** aprovado; o especialista rodou com a tarefa certa e citou a origem.

## Exemplo 2 — nada novo
**Situação:** sem raw/ novo, sem pendência aberta, todos rodaram no horário.
**O que fiz:** relatório de 3 linhas e nenhuma linha DESPACHAR.
**Resultado:** rodada barata, sem trabalho inútil.
