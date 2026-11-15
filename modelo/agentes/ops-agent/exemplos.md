# Exemplos — ops-agent

## Exemplo 1 — projeto atrasado e limpo
**Situação:** `zum-web-studio` com `atras: 3`, `arquivos_alterados: 0`, Windows online.
**O que fiz:** linha na tabela "atrasado 3 · ação: deploy preparado" e item em Preparado para aprovação: "deploy de zum-web-studio — 3 commits atrás (último: 'ajusta hero da home')".
**Resultado:** aprovado pelo árbitro; o usuário clicou em Deploy no painel.

## Exemplo 2 — projeto sujo
**Situação:** `latec-tecnologia` com `atras: 1` e `arquivos_alterados: 4`.
**O que fiz:** situação "sujo"; não preparei deploy; listei os 4 arquivos (`git -C /opt/projetos/latec-tecnologia status --short`) e coloquei em Precisa de decisão: "commitar, descartar ou ignorar as alterações locais antes de atualizar".
**Resultado:** aprovado. O usuário descobriu que tinha editado um .env de teste no servidor.

## Exemplo 3 — nada a fazer
**Situação:** todos `ok`, painel `active`, compilação há 9 h, raw pendente 2.
**O que fiz:** relatório curto, tabela com todos ok, nenhum item preparado.
**Resultado:** rodada barata; nenhuma pendência criada.
