---
name: novo-agente
description: Cria um agente novo em agentes/<nome> a partir de agentes/_modelo, entrevistando o usuário sobre missão, entradas, saídas, limites, horário, código e permissões. Use quando o usuário pedir /novo-agente <nome>, "cria um agente para X" ou "quero um agente que...".
---

# Novo agente

1. Nome: minúsculas-com-hifens (ex.: `ecac-monitor`). Se já existir `agentes/<nome>/`, pare e sugira `/agente <nome>`.
2. Entreviste, uma pergunta por vez, só o que faltar:
   - **Missão** em uma frase (o que ele garante, para quem).
   - **Entradas**: o que lê (páginas da wiki, pastas, comandos, sites/APIs).
   - **Saídas**: o que produz; o que deve ficar "preparado para aprovação".
   - **Limites**: o que nunca pode fazer.
   - **Horário** (cron) ou só sob demanda/despacho.
   - **Código/ferramentas**: existe pasta em `/opt/saas/<nome>`? Quais comandos exatos ele pode rodar (`pode_executar`)? Precisa de credencial? (vai para `/etc/cerebro-agentes/<nome>.env`, nunca para o cérebro).
   - **Modelo**: sonnet (padrão), haiku (tarefa simples/barata) ou opus (raciocínio pesado).
3. Copie `agentes/_modelo/` para `agentes/<nome>/` (`cp -r`, incluindo `execucoes/`), preencha `agente.md` (frontmatter completo, `status: rascunho`, `atualizado:` hoje), `conhecimento.md` (regras que o usuário já sabe), `exemplos.md` (1–2 casos se ele tiver), `avaliacao.md` (3 casos: 1 normal, 1 sem informação, 1 fora do limite) e `CHANGELOG.md`.
4. Se tiver código: sugira a estrutura de `/opt/saas/<nome>/` (um comando por ação, saída em JSON/texto, lendo credenciais do `.env` em `/etc`), mas só crie se o usuário pedir.
5. Teste a seco: `bash .claude/scripts/rodar-agente.sh <nome> "rodada de teste: descreva o que faria, sem executar nada" --gatilho=manual` e mostre o veredito do árbitro.
6. Quando o usuário aprovar: `status: ativo`, `sudo bash .claude/scripts/agendar-agentes.sh`, e uma linha no `diario/`.
