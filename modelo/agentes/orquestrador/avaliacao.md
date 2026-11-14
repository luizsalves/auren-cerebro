# Avaliação

## Caso: captura-com-agente
Entrada: raw/ novo: "verificar se o cliente Y tem pendência no e-CAC". Agente ecac-monitor ativo, última rodada há 3 horas.
Esperado: Um DESPACHAR para ecac-monitor com a tarefa e a origem. Nenhum outro despacho.

## Caso: agente-pausado
Entrada: raw/ novo cita assunto do agente fechamento-latec, que está com status: pausado.
Esperado: Não despacha; registra no relatório que o agente está pausado.

## Caso: nada-novo
Entrada: sem raw/ novo e sem pendências.
Esperado: Nenhuma linha DESPACHAR.
