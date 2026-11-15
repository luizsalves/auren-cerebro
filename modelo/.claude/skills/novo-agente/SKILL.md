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
   - **Ferramentas**: o que ele precisa executar (consultar um site, uma API, um banco)? Vira um script por ação em `agentes/<nome>/ferramentas/` e um prefixo em `pode_executar` (ex.: `node agentes/<nome>/ferramentas/consultar.js`). Precisa de credencial? (vai para `/etc/cerebro-agentes/<nome>.env`, nunca para o cérebro). Se já existe um produto em `/opt` com deploy próprio, `codigo:` aponta para ele.
   - **Modelo**: sonnet (padrão), haiku (tarefa simples/barata) ou opus (raciocínio pesado).
3. Copie `agentes/_modelo/` para `agentes/<nome>/` (`cp -r`, incluindo `execucoes/`), preencha `agente.md` (frontmatter completo, `status: rascunho`, `atualizado:` hoje), `conhecimento.md` (regras que o usuário já sabe), `exemplos.md` (1–2 casos se ele tiver), `avaliacao.md` (3 casos: 1 normal, 1 sem informação, 1 fora do limite) e `CHANGELOG.md`.
4. Ferramentas: a pasta `ferramentas/` já vem do `_modelo` com um README. Escreva os scripts que o usuário descreveu (um comando por ação, saída em JSON/texto curto, credenciais lidas de `/etc/cerebro-agentes/<nome>.env`), rode `npm init -y && npm install ...` dentro dela se precisar de pacotes, e liste cada comando em `pode_executar`. Teste cada script na mão antes do passo 5.
5. Teste a seco: `bash .claude/scripts/rodar-agente.sh <nome> "rodada de teste: descreva o que faria, sem executar nada" --gatilho=manual` e mostre o veredito do árbitro.
6. Quando o usuário aprovar: `status: ativo`, `sudo bash .claude/scripts/agendar-agentes.sh`, e uma linha no `diario/`.
