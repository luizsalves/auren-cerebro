---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-auren-cerebro]]
---

# Auren Cérebro (kit)

Kit do **segundo cérebro**: instalador (`instalar.sh`), painel web (`painel/`) e o molde do cérebro (`modelo/`: CLAUDE.md, skills, hooks, scripts, agentes de sistema). Instalado na VPS em `/opt/projetos/auren-cerebro`; o cérebro em si fica em `/opt/cerebro` (antes `/root/cerebro`).

## O que o kit entrega
Painel com grafo, busca, captura, Deploy (VPS + agente Windows) e lobo Agentes · agentes em `agentes/` com orquestrador, árbitro e devops-agent · motor trocável (Claude / Ollama / simulado) · isolamento por `systemd-run` · hook SessionEnd que registra sessões dos projetos em `raw/` · `ligar-projetos.sh` que mantém as páginas dos projetos da VPS.

## Relacionados
[[projetos-vps]] · [[auren-factory]]
