---
name: compilar
description: Compila o conteúdo novo de raw/ na wiki do segundo cérebro — atualiza projetos, clientes, pessoas, notas, decisões, agora.md e _indice.md. Use quando o usuário pedir /compilar, "organiza o cérebro" ou "processa o raw".
---

# Compilar

## 1. O que é novo
- Marcador: `.claude/ultima-compilacao` (contém uma data ISO). Sem marcador = tudo é novo.
- Liste `raw/*.md` modificados depois do marcador:
  `find raw -name '*.md' -newer .claude/ultima-compilacao` (ou todos, se não houver marcador).
- Nada novo → responda "Nada novo em raw/." e pare.

## 2. Para cada arquivo novo (em ordem de data)
1. Leia o arquivo.
2. Identifique: projetos, clientes, pessoas, decisões, conhecimento permanente, tarefas.
3. Para cada entidade, abra o arquivo da wiki correspondente (`_indice.md` ajuda a achar).
   - Existe → atualize a seção certa, `atualizado:` e acrescente a fonte em `fontes:`.
   - Não existe e é relevante → crie com o frontmatter padrão do CLAUDE.md.
4. Decisões → uma linha em `wiki/decisoes.md`: `AAAA-MM-DD — decisão — porquê — [[fonte]]`.
5. Tarefas e prioridades novas → `agora.md` (máx. 30 linhas; o que saiu vai para o diário).
6. Ligue tudo com `[[nome]]`.

## 3. Fechamento
- Atualize `_indice.md` (uma linha por arquivo da wiki, por seção).
- Acrescente em `diario/AAAA-MM-DD.md` (hoje): "Compilação: N arquivos de raw → páginas X, Y, Z".
- Grave a data/hora atual em `.claude/ultima-compilacao`.
- Responda em até 5 linhas: o que foi criado/atualizado.

## Regras
- Nunca edite nada em `raw/` nem em `identidade/`.
- Só fatos que estão nas fontes. Dúvida ou contradição → anote em `agora.md` como "Esperando: confirmar X".
- Prefira atualizar páginas existentes a criar novas.
