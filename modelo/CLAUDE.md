# Segundo cérebro

Esta pasta é o meu segundo cérebro: arquivos .md que você lê e mantém.
Responda sempre em português. Respostas curtas; só detalhe quando eu pedir.

## Mapa

| Pasta / arquivo   | O que é                                   | Quem escreve            |
|-------------------|-------------------------------------------|-------------------------|
| `identidade/`     | quem eu sou, valores, estilo              | só eu (você só se eu pedir) |
| `raw/`            | entrada bruta, com data                   | você cria; NUNCA edita nem apaga |
| `wiki/projetos/`  | um arquivo por projeto                    | você (via /compilar)    |
| `wiki/clientes/`  | um arquivo por cliente                    | você                    |
| `wiki/pessoas/`   | um arquivo por pessoa                     | você                    |
| `wiki/notas/`     | conhecimento permanente, 1 assunto/arquivo | você                   |
| `wiki/decisoes.md`| decisões e o porquê                       | você                    |
| `diario/`         | `AAAA-MM-DD.md`, resumo de cada sessão    | você                    |
| `agora.md`        | foco atual e próximos passos (máx. 30 linhas) | você e eu           |
| `_indice.md`      | lista de toda a wiki, 1 linha por arquivo | você                    |
| `_arquivo/`       | o que saiu de uso (nada é apagado)        | você                    |

Foco atual: @agora.md

## Regras

1. Antes de responder sobre um projeto, cliente ou pessoa, abra o arquivo dele.
   Se não existir, diga que não existe. Nunca invente.
2. Fato novo e durável que eu disser → salve em `raw/` (skill capturar).
   A wiki só muda via /compilar, citando a fonte em `raw/`.
3. Nomes de arquivo: minúsculas-com-hifens, 1 assunto por arquivo.
4. Todo arquivo da wiki começa com frontmatter:
   ```
   ---
   tipo: projeto | cliente | pessoa | nota
   status: ativo | pausado | concluido
   atualizado: AAAA-MM-DD
   fontes: [[raw-arquivo]], [[raw-outro]]
   ---
   ```
5. Ligue notas com `[[nome-do-arquivo]]` (sem .md). São as sinapses do painel.
6. Nunca apague: mova para `_arquivo/`.
7. Nada de dados sensíveis (senhas, documentos, dados bancários).
8. Ao fim de uma sessão com trabalho real, acrescente 3–5 linhas em
   `diario/AAAA-MM-DD.md` (o que foi feito, decisões, próximos passos).

## Comandos (skills)

- `/capturar` — salva algo em `raw/`
- `/compilar` — transforma o `raw/` novo em wiki
- `/revisao-semanal` — resumo da semana e o que está parado
- `/lint` — links quebrados, páginas sem fonte, páginas paradas
- `/entrevista` — me entrevista para popular o cérebro

## Painel

O painel web lê esta pasta e mostra o grafo ao vivo. Não precisa fazer nada
para ele: qualquer .md novo ou alterado aparece sozinho.
