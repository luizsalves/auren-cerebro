---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-suite-planning]], [[2026-11-15-0100-github-painel-web-swisspark]]
---

# Suite Planning

Suíte de sistemas em módulos da **Latec**. Hoje contém o **módulo contábil** (vendido como *BI Planning* / *Planning Contábil*): fechamento e conciliação contábil mensal sobre o TOTVS RM, balancete, balanço, DFC, indicadores, produtividade da equipe e a assistente de IA **Tati** (responde sobre os números sem inventar: todo número vem de uma ferramenta que consulta o sistema).

## Origem
Nasceu em 09/11/2026 como cópia do [[painel-web-swisspark]] (main `740faf9`), com histórico. O código foi renomeado (`backend/SuitePlanning.*`); a marca Swiss Park ainda aparece nas telas até a marca nova ser definida. Logo e tela de login do *Planning Contábil* com identidade Latec já entraram.

## Para quem
- Analista: prepara e concilia contas do fechamento.
- Gerente: confere e acompanha produtividade.
- Superadministrador: usuários, módulos, chat da Tati.
- Diretoria: visão de saúde da empresa.

## Stack
.NET 10 (API única que acessa bancos e IA) · React + Vite · PostgreSQL (dados próprios) · SQL Server do TOTVS RM só leitura · Docker Compose com nginx · provedor de IA (DeepSeek hoje). Especificação técnica para reconstrução em `docs/modulo-contabil/especificacao-tecnica.md`.

## Onde fica
GitHub privado (fonte) · VPS `/opt/saas/suite-planning` · PC `C:\Projetos\suite-planning`. Cópias só baixam a `main` (1h da manhã e botão Deploy do cérebro). Ainda não roda na VPS: falta banco, porta e `secrets/keys.json`.

## Estado (nov/2026)
96 commits desde 10/09/2026. Últimos: fechamento com observações e anexos, saldo anterior para conta sem movimento, posições mensais de saldo no PostgreSQL, produtividade por empresa, empresas por coligada, deploy só da `main`.

## Relacionados
[[painel-web-swisspark]] (origem) · [[swiss-park]] (cliente) · [[latec-tecnologia]] (quem vende) · [[painel-conciliacao]] (primeiro protótipo) · [[ia-planning-pilotos]] (agente contábil piloto) · [[auren-ecossistema]]
