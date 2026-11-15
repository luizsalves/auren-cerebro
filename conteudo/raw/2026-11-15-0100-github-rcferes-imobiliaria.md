---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/rcferes-imobiliaria), leitura automática do repositório
---

# Levantamento do repositório rcferes-imobiliaria

Repositório: https://github.com/luizsalves/rcferes-imobiliaria
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-08 Versiona projeto existente
primeiro: 2026-11-08 · total(≤80): 1 · branch: main
## arvore
.
.firebaserc
CACHE-FOTOS.md
LEIA-ME-FIREBASE.md
LEIA-ME.txt
README.md
corretora-site
corretora-site/.firebaserc
corretora-site/public
firebase.json
firestore.indexes.json
firestore.rules
imagens
imagens/Fita champagne 11 anos de tradição-2.png
imagens/Logotipo RC Feres em dourado champanhe-1.png
public
public/admin
public/assets
public/css
public/imovel.html
public/index.html
public/js
storage.rules
## manifestos
## README (README.md)
# Seu próximo lar
Landing page responsiva em português, sem dependências externas, sem formulários ou cadastro.
## Personalização
Preencher `dist/data.js` com os dados fornecidos pela corretora. O WhatsApp aceita o formato internacional `55 + DDD + número` ou um telefone brasileiro com DDD. Não preencher números de terceiros.
Enquanto o WhatsApp não for fornecido, os botões mostram explicitamente uma prévia da mensagem. Nenhum número foi inventado.
Adicionar apenas imóveis reais ao array `properties`, com `id`, `title`, `image`, `neighborhood`, `price`, `area`, `bedrooms` e `parking`. Os cartões de inspiração são substituídos automaticamente pelos imóveis fornecidos. As mensagens identificam o imóvel pelo código, título e bairro.
O retrato real pode ser adicionado em `portrait`. A biografia fornecida pode substituir o texto de apresentação em `bio`. Não existem depoimentos ou credenciais inventados. Remover os avisos de prévia apenas após completar e conferir os dados reais.
## Imagem
`dist/assets/lar.webp`: imagem arquitetônica ilustrativa gerada com o recurso integrado de geração de imagens. Prompt: fotografia editorial de uma residência brasileira contemporânea, sala com sofá de linho e piso de travertino, portas de vidro voltadas para jardim tropical; luz natural, tons areia e verde, sem pessoas, texto ou logos. Não representa um imóvel anunciado.
`dist/assets/casa-jardim.webp`: fotografia conceitual gerada de fachada de residência contemporânea brasileira, jardim tropical e luz do fim da tarde, com composição à direita e jardim sombreado à esquerda. Sem pessoas, textos ou logos.
`dist/assets/apartamento-terraco.webp`: fotografia conceitual gerada de sala de apartamento integrada a terraço e vista urbana, materiais naturais e luz da manhã. Sem pessoas, textos ou logos.
As três imagens ilustrativas compõem o carrossel de fundo do topo, com o cabeçalho transparente sobreposto. O carrossel alterna a cada sete segundos, tem setas, seleção direta, pausa e gestos horizontais no celular. A troca automática para quando a página fica oculta, o topo sai da tela ou há interação com o carrossel; a preferência por movimento reduzido inicia o carrossel pausado.
## Hospedagem
Site estático; diretório público: `dist`.
## docs
CACHE-FOTOS.md
LEIA-ME-FIREBASE.md
## contagem
     17 js       8 css       7 webp       5 html       3 md       2 svg       2 rules       2 png 

```
