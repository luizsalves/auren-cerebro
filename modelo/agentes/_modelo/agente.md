---
nome: _modelo
papel: especialista          # orquestrador | especialista | arbitro
status: rascunho             # rascunho | ativo | pausado  (só "ativo" roda no cron e por despacho)
modelo: sonnet               # sonnet | haiku | opus  (com MOTOR=ollama: o nome do modelo no Ollama)
horario: ""                  # cron de 5 campos, ex.: "0 7 * * 1-5". Vazio = só sob demanda ou por despacho
codigo: ""                   # pasta do código/ferramentas do agente, ex.: /opt/saas/ecac-monitor
ferramentas: [Read, Glob, Grep, Write, Edit, Bash]   # ferramentas do Claude Code liberadas
pode_executar: []            # únicos comandos liberados no Bash (prefixos), ex.: ["node /opt/saas/x/consultar.js", "git -C /opt/saas/x log"]
efeitos_externos: nenhum     # nenhum | preparar | executar-com-aprovacao
arbitro: true                # passa pelo árbitro após cada rodada
max_tentativas: 2            # refaz 1 vez se o árbitro reprovar
max_turnos: 30               # limite de passos (MOTOR=ollama)
orcamento_rodada_usd: 0.50   # limite de gasto por rodada (MOTOR=claude)
atualizado: AAAA-MM-DD
---

# _modelo

## Missão
<!-- Uma frase: o que este agente garante. Ex.: "Detectar pendências dos clientes da Latec no e-CAC antes do prazo." -->

## Entradas
<!-- O que ele lê a cada rodada: páginas da wiki, pastas, comandos, fontes externas. -->
- wiki/clientes/ (lista de clientes atendidos)
- 

## Saídas
<!-- O que produz e em que formato. Tudo vai para execucoes/<run_id>.md; fato novo vai para raw/. -->
- Relatório da rodada com: o que verificou, o que encontrou, o que propõe, o que precisa de decisão.
- 

## Limites
<!-- O que nunca faz. O árbitro reprova se violar. -->
- Não executa nada fora de `pode_executar`.
- Não envia mensagem, e-mail ou ação externa: deixa preparado para aprovação.
- Não grava dado sensível (documentos, senhas, dados bancários); grava só o status.
- Não edita `agente.md`, `conhecimento.md`, `exemplos.md`, `avaliacao.md`: propõe em `pendencias.md`.

## Procedimento
1. Leia `conhecimento.md` e `exemplos.md` desta pasta.
2. 
3. 
4. Grave o relatório no arquivo de execução indicado na tarefa, no formato abaixo.

## Formato do relatório
```
## Resumo
(2–3 linhas)

## O que verifiquei
- 

## Encontrado
- 

## Preparado para aprovação
- (ação, destinatário, texto) ou "nada"

## Fatos novos gravados em raw/
- (caminho) ou "nenhum"

## Propostas para pendencias.md
- ou "nenhuma"

## Precisa de decisão
- ou "nada"
```
