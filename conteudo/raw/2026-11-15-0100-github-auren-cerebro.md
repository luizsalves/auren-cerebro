---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/auren-cerebro), leitura automática do repositório
---

# Levantamento do repositório auren-cerebro

Repositório: https://github.com/luizsalves/auren-cerebro
Lido em 2026-11-15. Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-15 Painel: catálogo de agentes (por agente / por projeto) além do desempenho
2026-11-15 Renomeia ops-agent para devops-agent
2026-11-14 ops-agent, níveis de autonomia, sandbox systemd-run, hook SessionEnd, métricas no painel
2026-11-14 Ferramentas do agente dentro da pasta dele (agentes/<nome>/ferramentas)
2026-11-14 Agentes dentro do cérebro: orquestrador, especialistas, árbitro, motor trocável
2026-11-08 Botão Deploy no painel: git pull na VPS e na máquina Windows (agente)
2026-11-08 Liga os projetos da VPS ao cérebro (ligar-projetos.sh)
2026-11-07 Adiciona imagem do painel ao README
primeiro: 2026-11-07 · total(≤80): 8 · branch: main
## arvore
.
README.md
conteudo
conteudo/__pycache__
conteudo/paginas.py
conteudo/raw
conteudo/wiki
docs
docs/painel.png
importar-conteudo.sh
instalar.sh
modelo
modelo/.claude
modelo/.gitignore
modelo/CLAUDE.md
modelo/_arquivo
modelo/_indice.md
modelo/agentes
modelo/agora.md
modelo/diario
modelo/identidade
modelo/raw
modelo/wiki
painel
painel/public
painel/server.js
## manifestos
## README (README.md)
# Auren · Segundo cérebro
Segundo cérebro com Claude Code numa VPS: arquivos `.md` que o Claude lê e mantém,
compilação automática toda noite e um painel web ao vivo com o grafo das notas.
![Painel do cérebro](docs/painel.png)
## Instalar na VPS
```bash
ssh root@SEU_IP
git clone https://github.com/luizsalves/auren-cerebro.git /root/auren-cerebro
sudo bash /root/auren-cerebro/instalar.sh
```
O instalador pede a senha do painel e no fim mostra o endereço (`http://SEU_IP:3333`).
Com domínio (HTTPS automático): aponte o DNS para o IP da VPS e rode
`DOMINIO=cerebro.seudominio.com.br sudo bash /root/auren-cerebro/instalar.sh`.
Depois:
```bash
cd /root/cerebro
claude          # faça login na primeira vez
/entrevista     # popula o cérebro com suas respostas
```
Para atualizar: `cd /root/auren-cerebro && git pull && sudo bash instalar.sh`.
As suas notas nunca são sobrescritas.
## Arquitetura
```
/root/cerebro/                  ← o cérebro (repositório git próprio)
├── CLAUDE.md                   mapa + regras (lido em toda sessão)
├── AGENTS.md → CLAUDE.md       para Codex e outros agentes
├── agora.md                    foco atual (importado no CLAUDE.md)
├── _indice.md                  índice da wiki
├── identidade/                 quem você é (só você escreve)
├── raw/                        entrada bruta, append-only
├── wiki/
│   ├── projetos/  clientes/  pessoas/  notas/
│   └── decisoes.md
├── diario/                     AAAA-MM-DD.md + revisões semanais
├── agentes/                    _modelo/, orquestrador/, arbitro/ e os seus (agente.md, conhecimento, exemplos, avaliacao, pendencias, execucoes/, ferramentas/)
├── _arquivo/                   nada é apagado, vem pra cá
└── .claude/
    ├── settings.json           hooks
    ├── rules/                  raw.md, wiki.md, pessoas.md (carregam por pasta)
    ├── skills/                 capturar, compilar, revisao-semanal, lint, entrevista, agentes, agente, novo-agente, avaliar, despachar
    ├── hooks/                  inicio.sh, protege.js, salvar.sh
    ├── motor.env               MOTOR=claude|ollama|simulado, modelos, orçamento (fora do git)
    └── scripts/                lint.js, rotina.sh, guarda-raw.sh, ligar-projetos.sh, rodar-agente.sh, motor.sh, motor-ollama.js, avaliar-agente.sh, agendar-agentes.sh, agentes-lib.js, registrar-sessao.sh
/opt/cerebro-painel/            ← painel web (Node, sem dependências)
/etc/cerebro-painel.env         ← senha e configuração (só root lê)
/etc/cron.d/cerebro             ← rotinas
```
### Camadas
| Camada | Quem escreve | Regra |
|---|---|---|
| `identidade/` | você | o Claude só mexe se você pedir |
| `raw/` | você / Claude / painel | só cria; editar é bloqueado por hook e revertido pelo git |
| `wiki/` | Claude via `/compilar` | toda afirmação cita a fonte em `raw/` |
| `diario/` | Claude | resumo de sessões, compilações e revisões |
### Hooks
- **SessionStart** (`inicio.sh`): injeta data, último diário, quantos `raw/` faltam compilar e o último lint.
- **PreToolUse** (`protege.js`): bloqueia editar arquivo existente em `raw/`.
- **Stop** (`salvar.sh`): restaura `raw/` se algo foi alterado e faz commit (histórico e backup).
### Projetos da VPS
`ligar-projetos.sh` lê as pastas `/opt/projetos` e `/opt/saas` (menos `secrets`) e, para cada
projeto: cria ou atualiza `wiki/projetos/<nome>.md` com um bloco **Na VPS** (caminho, stack,
git, última atividade, resumo do README), mantém o hub `wiki/notas/projetos-vps.md`, o
`_indice.md`, a tabela **Projetos na VPS** no `CLAUDE.md` e libera as pastas em
`permissions.additionalDirectories` para o Claude Code ler o código. O inventário entra em
`raw/` só quando algo muda. Páginas que você já escreveu são mantidas; só o bloco entre as
marcas `vps:inicio`/`vps:fim` é reescrito.
Roda no instalador e todo domingo 18:30. Na mão:
`bash /root/cerebro/.claude/scripts/ligar-projetos.sh`
(outras pastas: `PASTAS="/opt/projetos /srv/apps" EXCLUIR="secrets tmp" bash ...`).
### Agentes
## docs

docs:
painel.png
## contagem
     97 md      15 sh      11 gitkeep       5 js       2 html       1 pyc       1 py       1 ps1 

```
