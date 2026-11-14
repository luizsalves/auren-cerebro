---
name: avaliar
description: Roda os casos de avaliacao.md de um agente e dá nota (0–10) a cada um pelo árbitro. Use quando o usuário pedir /avaliar <nome>, "testa o agente X" ou depois de mudar conhecimento/missão de um agente.
---

# Avaliar

1. `bash .claude/scripts/avaliar-agente.sh <nome>`.
2. Leia o arquivo que o script imprime (`agentes/<nome>/avaliacoes/AAAA-MM-DD-HHMM.md`).
3. Responda: média, tabela caso/nota, e para cada nota < 7 o que o árbitro apontou e qual arquivo do agente provavelmente precisa mudar (`conhecimento.md`, `exemplos.md` ou `agente.md`).
4. Se houver avaliação anterior em `avaliacoes/`, compare as médias e diga se melhorou ou piorou.
5. Não altere os arquivos do agente sem o usuário pedir.
