---
tipo: captura
criado: 2026-11-15T21:00
fonte: conversa do Luiz com o Claude (claude.ai), 15/11/2026
---

# Ideia: suporte-agent — agente que atende chamados dos clientes

Quando um cliente abrir um chamado no sistema de chamados ([[chamados-workflow]], em `/opt/saas/Chamados Workflow`), um agente atende:

1. lê o chamado;
2. consulta o sistema do cliente pela API (ex.: [[painel-web-swisspark]] / [[suite-planning]] para o [[swiss-park]]);
3. resolve ou prepara a resposta;
4. o árbitro confere;
5. a resposta volta para o cliente dentro do chamado.

Autonomia: começa **crítica** (o Luiz aprova toda resposta); depois de algumas semanas acertando, libera casos simples (dúvida, status, reabrir fechamento) como reversível.

## WhatsApp
O agente também deve conversar com o cliente pelo WhatsApp: o chamado é o registro, o WhatsApp é o canal. Opções:
- canal WhatsApp Business do próprio sistema de chamados (o Zammad, do [[work-planning]], tem);
- Evolution API, já testada em `EvolutionManager-LID-Test` e no WhatsCRM ([[whatsapp]]).
Toda mensagem ao cliente começa preparada para aprovação; respostas simples são liberadas depois.

## Decisão pendente
Três sistemas de chamados em teste em `/opt/saas/Chamados Workflow` (Zammad + dois instalados em 15/11/2026); o Luiz ainda não escolheu. Critério que a ideia acrescenta: **API e webhook de chamados** e canal WhatsApp, porque é por aí que o agente entra e responde.

## Próximo passo
Escolhido o sistema: `/novo-agente suporte-agent` com as ferramentas ler chamado · consultar painel do cliente · responder chamado · enviar WhatsApp (preparado para aprovação).
