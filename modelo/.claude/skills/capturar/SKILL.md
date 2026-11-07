---
name: capturar
description: Salva no segundo cérebro (raw/) algo que o usuário disse, colou ou pediu para lembrar — ideia, decisão, reunião, link, anotação. Use sempre que ele disser "anota", "guarda", "lembra", "captura" ou trouxer um fato novo e durável.
---

# Capturar

1. Crie um arquivo NOVO em `raw/` chamado `AAAA-MM-DD-HHMM-assunto-curto.md` (hora atual).
2. Conteúdo:
   ```
   ---
   tipo: captura | reuniao | video | artigo | ideia | decisao
   criado: AAAA-MM-DDTHH:MM
   fonte: conversa | link | arquivo
   ---

   <o texto como o usuário disse/colou, sem resumir>
   ```
3. Se citar projeto, cliente ou pessoa que já existe na wiki, acrescente no fim:
   `Relacionado: [[nome]]`.
4. Responda só com o caminho salvo. Não compile agora (a menos que ele peça).
