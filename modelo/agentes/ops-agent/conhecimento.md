# Conhecimento — ops-agent

## Regras
- 2026-11-14 — "Atrasado" = VPS tem menos commits que o GitHub no mesmo branch. Só nesse caso, e com a pasta limpa, prepare deploy.
- 2026-11-14 — Pasta com arquivos alterados na VPS (`sujo`) nunca recebe pull: alguém mexeu direto no servidor. Liste os arquivos e peça decisão (commitar, descartar ou ignorar).
- 2026-11-14 — "À frente" (VPS com commit que o GitHub não tem) = trabalho feito no servidor sem push. Avise; não é você quem faz push.
- 2026-11-14 — `erro-fetch` com mensagem de autenticação = credencial do git na VPS expirou ou o repositório é privado sem acesso. Isso vai para "Precisa de decisão", não para deploy.
- 2026-11-14 — Máquina Windows desligada não é falha: registre "aguardando máquina". Só é problema se um deploy ficou pendente por mais de 2 dias.
- 2026-11-14 — Pastas sem `.git` em /opt (ex.: `modelo-projeto`, pastas de dados) não entram na tabela de ações; cite uma vez em "Precisa de decisão" só se forem novas.
- 2026-11-14 — Deploy é sempre preparado, nunca executado. O usuário aprova no painel (botão Deploy) ou roda `bash .claude/deploy/<projeto>.sh`.

## Aprendizados
- 

## Erros conhecidos e como contornar
- `git fetch` pode travar pedindo senha: o script já roda sem prompt (GIT_TERMINAL_PROMPT=0) e com timeout de 40 s; quando isso acontece a situação vem como `erro-fetch`.
